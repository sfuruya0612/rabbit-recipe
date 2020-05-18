defmodule RabbitRecipeWeb.IngredientsController do
  use RabbitRecipeWeb, :controller

  alias RabbitRecipe.Recipes
  alias RabbitRecipe.Recipes.Ingredients

  action_fallback RabbitRecipeWeb.FallbackController

  def index(conn, _params) do
    ingredients = Recipes.list_ingredients()
    render(conn, "index.json", ingredients: ingredients)
  end

  def create(conn, %{"ingredients" => ingredients_params}) do
    with {:ok, %Ingredients{} = ingredients} <- Recipes.create_ingredients(ingredients_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.ingredients_path(conn, :show, ingredients))
      |> render("show.json", ingredients: ingredients)
    end
  end

  def show(conn, %{"id" => id}) do
    ingredients = Recipes.get_ingredients!(id)
    render(conn, "show.json", ingredients: ingredients)
  end

  def update(conn, %{"id" => id, "ingredients" => ingredients_params}) do
    ingredients = Recipes.get_ingredients!(id)

    with {:ok, %Ingredients{} = ingredients} <- Recipes.update_ingredients(ingredients, ingredients_params) do
      render(conn, "show.json", ingredients: ingredients)
    end
  end

  def delete(conn, %{"id" => id}) do
    ingredients = Recipes.get_ingredients!(id)

    with {:ok, %Ingredients{}} <- Recipes.delete_ingredients(ingredients) do
      send_resp(conn, :no_content, "")
    end
  end
end
