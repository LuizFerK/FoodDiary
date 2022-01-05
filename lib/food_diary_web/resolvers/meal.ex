defmodule FoodDiaryWeb.Resolvers.Meal do
  alias FoodDiary.Meals.Create

  def create(%{input: params}, _context) do
    Create.call(params)
  end
end
