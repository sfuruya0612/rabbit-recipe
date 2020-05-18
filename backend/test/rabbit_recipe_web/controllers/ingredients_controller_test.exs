defmodule RabbitRecipeWeb.IngredientsControllerTest do
  use RabbitRecipeWeb.ConnCase

  alias RabbitRecipe.Recipes
  alias RabbitRecipe.Recipes.Ingredients

  @create_attrs %{
    amount: "some amount",
    name: "some name"
  }
  @update_attrs %{
    amount: "some updated amount",
    name: "some updated name"
  }
  @invalid_attrs %{amount: nil, name: nil}

  def fixture(:ingredients) do
    {:ok, ingredients} = Recipes.create_ingredients(@create_attrs)
    ingredients
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all ingredients", %{conn: conn} do
      conn = get(conn, Routes.ingredients_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create ingredients" do
    test "renders ingredients when data is valid", %{conn: conn} do
      conn = post(conn, Routes.ingredients_path(conn, :create), ingredients: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.ingredients_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => "some amount",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.ingredients_path(conn, :create), ingredients: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update ingredients" do
    setup [:create_ingredients]

    test "renders ingredients when data is valid", %{conn: conn, ingredients: %Ingredients{id: id} = ingredients} do
      conn = put(conn, Routes.ingredients_path(conn, :update, ingredients), ingredients: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.ingredients_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => "some updated amount",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, ingredients: ingredients} do
      conn = put(conn, Routes.ingredients_path(conn, :update, ingredients), ingredients: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete ingredients" do
    setup [:create_ingredients]

    test "deletes chosen ingredients", %{conn: conn, ingredients: ingredients} do
      conn = delete(conn, Routes.ingredients_path(conn, :delete, ingredients))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.ingredients_path(conn, :show, ingredients))
      end
    end
  end

  defp create_ingredients(_) do
    ingredients = fixture(:ingredients)
    {:ok, ingredients: ingredients}
  end
end
