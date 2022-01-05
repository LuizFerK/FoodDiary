defmodule FoodDiaryWeb.Resolvers.Meal do
  alias FoodDiary.Meals.Create

  def create(%{input: params}, _context), do: Create.call(params)

  # def create(%{input: params}, _context) do
  #   with {:ok, meal} <- Create.call(params) do
  #     Subscription.publish(Endpoint, meal, new_meal: "new_meal_topic")
  #     {:ok, meal}
  #   else
  #     error -> error
  #   end
  # end
end
