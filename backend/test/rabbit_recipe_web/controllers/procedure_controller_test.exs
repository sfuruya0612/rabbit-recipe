defmodule RabbitRecipeWeb.ProcedureControllerTest do
  use RabbitRecipeWeb.ConnCase

  alias RabbitRecipe.Recipes
  alias RabbitRecipe.Recipes.Procedure

  @create_attrs %{
    content: "some content",
    image: "some image"
  }
  @update_attrs %{
    content: "some updated content",
    image: "some updated image"
  }
  @invalid_attrs %{content: nil, image: nil}

  def fixture(:procedure) do
    {:ok, procedure} = Recipes.create_procedure(@create_attrs)
    procedure
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all procedures", %{conn: conn} do
      conn = get(conn, Routes.procedure_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create procedure" do
    test "renders procedure when data is valid", %{conn: conn} do
      conn = post(conn, Routes.procedure_path(conn, :create), procedure: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.procedure_path(conn, :show, id))

      assert %{
               "id" => id,
               "content" => "some content",
               "image" => "some image"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.procedure_path(conn, :create), procedure: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update procedure" do
    setup [:create_procedure]

    test "renders procedure when data is valid", %{conn: conn, procedure: %Procedure{id: id} = procedure} do
      conn = put(conn, Routes.procedure_path(conn, :update, procedure), procedure: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.procedure_path(conn, :show, id))

      assert %{
               "id" => id,
               "content" => "some updated content",
               "image" => "some updated image"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, procedure: procedure} do
      conn = put(conn, Routes.procedure_path(conn, :update, procedure), procedure: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete procedure" do
    setup [:create_procedure]

    test "deletes chosen procedure", %{conn: conn, procedure: procedure} do
      conn = delete(conn, Routes.procedure_path(conn, :delete, procedure))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.procedure_path(conn, :show, procedure))
      end
    end
  end

  defp create_procedure(_) do
    procedure = fixture(:procedure)
    {:ok, procedure: procedure}
  end
end
