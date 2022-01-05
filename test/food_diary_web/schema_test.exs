defmodule FoodDiaryWeb.SchemaTest do
  use FoodDiaryWeb.ConnCase, async: true

  alias FoodDiary.User
  alias FoodDiary.Users

  describe "users query" do
    test "when a valid id is given, returns the user", %{conn: conn} do
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

    test "when the user does not exists, returns an error", %{conn: conn} do
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
end
