defmodule RabbitRecipeWeb.TitleControllerTest do
  use RabbitRecipeWeb.ConnCase

  alias RabbitRecipe.Recipes
  alias RabbitRecipe.Recipes.Title

  @create_attrs %{
    image: "some image",
    memo: "some memo",
    name: "some name"
  }
  @update_attrs %{
    image: "some updated image",
    memo: "some updated memo",
    name: "some updated name"
  }
  @invalid_attrs %{image: nil, memo: nil, name: nil}

  def fixture(:title) do
    {:ok, title} = Recipes.create_title(@create_attrs)
    title
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all titles", %{conn: conn} do
      conn = get(conn, Routes.title_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create title" do
    test "renders title when data is valid", %{conn: conn} do
      conn = post(conn, Routes.title_path(conn, :create), title: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.title_path(conn, :show, id))

      assert %{
               "id" => id,
               "image" => "some image",
               "memo" => "some memo",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.title_path(conn, :create), title: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update title" do
    setup [:create_title]

    test "renders title when data is valid", %{conn: conn, title: %Title{id: id} = title} do
      conn = put(conn, Routes.title_path(conn, :update, title), title: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.title_path(conn, :show, id))

      assert %{
               "id" => id,
               "image" => "some updated image",
               "memo" => "some updated memo",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, title: title} do
      conn = put(conn, Routes.title_path(conn, :update, title), title: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete title" do
    setup [:create_title]

    test "deletes chosen title", %{conn: conn, title: title} do
      conn = delete(conn, Routes.title_path(conn, :delete, title))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.title_path(conn, :show, title))
      end
    end
  end

  defp create_title(_) do
    title = fixture(:title)
    {:ok, title: title}
  end
end
