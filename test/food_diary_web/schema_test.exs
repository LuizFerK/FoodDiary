defmodule FoodDiaryWeb.SchemaTest do
  use FoodDiaryWeb.ConnCase, async: true
  use FoodDiaryWeb.SubscriptionCase

  alias FoodDiary.User
  alias FoodDiary.Users

  describe "users query" do
    test "when a valid id is given, returns the user", %{conn: conn} do
      params = %{email: "user@test.com", name: "User test"}

      {:ok, %User{id: user_id}} = Users.Create.call(params)

      query = """
      {
        user(id: #{user_id}) {
          name
          email
        }
      }
      """

      expected_response = %{
        "data" => %{"user" => %{"email" => "user@test.com", "name" => "User test"}}
      }

      response =
        conn
        |> post("api/graphql", %{query: query})
        |> json_response(200)

      assert response == expected_response
    end

    test "when the user does not exists, returns an error", %{conn: conn} do
      query = """
      {
        user(id: 123456) {
          name
          email
        }
      }
      """

      expected_response = %{
        "data" => %{"user" => nil},
        "errors" => [
          %{
            "locations" => [%{"column" => 3, "line" => 2}],
            "message" => "User not found",
            "path" => ["user"]
          }
        ]
      }

      response =
        conn
        |> post("api/graphql", %{query: query})
        |> json_response(200)

      assert response == expected_response
    end
  end

  describe "users mutation" do
    test "when all params are valid, creates the user", %{conn: conn} do
      mutation = """
      mutation {
        createUser(input: {name: "John Doe", email: "john@doe.com"}) {
          name
          email
        }
      }
      """

      expected_response = %{
        "data" => %{"createUser" => %{"email" => "john@doe.com", "name" => "John Doe"}}
      }

      response =
        conn
        |> post("api/graphql", %{query: mutation})
        |> json_response(200)

      assert response == expected_response
    end
  end

  describe "subscriptions" do
    test "meal subscription", %{socket: socket} do
      params = %{email: "user@test.com", name: "User test"}

      {:ok, %User{id: user_id}} = Users.Create.call(params)

      mutation = """
      mutation {
        createMeal(input: {calories: 333.33, category: FOOD, description: "Pizza test", userId: #{user_id}}) {
          description
        }
      }
      """

      subscription = """
      subscription {
        newMeal {
          description
        }
      }
      """

      # Subscription setup
      socket_ref = push_doc(socket, subscription)
      assert_reply socket_ref, :ok, %{subscriptionId: subscription_id}

      # Mutation setup
      socket_ref = push_doc(socket, mutation)
      assert_reply socket_ref, :ok, mutation_response

      expected_subscription_response = %{
        result: %{data: %{"newMeal" => %{"description" => "Pizza test"}}},
        subscriptionId: subscription_id
      }

      expected_mutation_response = %{data: %{"createMeal" => %{"description" => "Pizza test"}}}

      assert_push "subscription:data", subscription_response
      assert subscription_response == expected_subscription_response
      assert mutation_response == expected_mutation_response
    end
  end
end
