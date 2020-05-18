defmodule RabbitRecipeWeb.IngredientsView do
  use RabbitRecipeWeb, :view
  alias RabbitRecipeWeb.IngredientsView

  def render("index.json", %{ingredients: ingredients}) do
    %{data: render_many(ingredients, IngredientsView, "ingredients.json")}
  end

  def render("show.json", %{ingredients: ingredients}) do
    %{data: render_one(ingredients, IngredientsView, "ingredients.json")}
  end

  def render("ingredients.json", %{ingredients: ingredients}) do
    %{id: ingredients.id,
      name: ingredients.name,
      amount: ingredients.amount}
  end
end
