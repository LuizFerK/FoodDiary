defmodule FoodDiaryWeb.Resolvers.Meal do
  alias Absinthe.Subscription
  alias FoodDiary.Meals.Create
  alias FoodDiaryWeb.Endpoint

  def create(%{input: params}, _context) do
    with {:ok, meal} <- Create.call(params) do
      Subscription.publish(Endpoint, meal, new_meal: "new_meal_topic")
      {:ok, meal}
    else
      error -> error
    end
  end
end
