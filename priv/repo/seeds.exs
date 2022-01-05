# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FoodDiary.Repo.insert!(%FoodDiary.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias FoodDiary.{Meal, Repo, User}

user1_params = %{email: "johndoe@example.com", name: "John Doe"}
user2_params = %{email: "foo@bar.com", name: "Foo Bar"}

meal1_params = %{description: "Pepperoni pizza", calories: 373.3, category: :food}
meal2_params = %{description: "Soda", calories: 80.0, category: :drink}
meal3_params = %{description: "Chocolate cake", calories: 250.55, category: :dessert}

# Inserting users
%User{id: user1_id} = user1_params |> User.changeset() |> Repo.insert!()
%User{id: user2_id} = user2_params |> User.changeset() |> Repo.insert!()

# Inserting meals to user1
meal1_params |> Map.put(:user_id, user1_id) |> Meal.changeset() |> Repo.insert!()
meal2_params |> Map.put(:user_id, user1_id) |> Meal.changeset() |> Repo.insert!()

# Inserting meals to user2
meal1_params |> Map.put(:user_id, user2_id) |> Meal.changeset() |> Repo.insert!()
meal2_params |> Map.put(:user_id, user2_id) |> Meal.changeset() |> Repo.insert!()
meal3_params |> Map.put(:user_id, user2_id) |> Meal.changeset() |> Repo.insert!()
