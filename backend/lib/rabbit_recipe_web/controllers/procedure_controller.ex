defmodule RabbitRecipeWeb.ProcedureController do
  use RabbitRecipeWeb, :controller

  alias RabbitRecipe.Recipes
  alias RabbitRecipe.Recipes.Procedure

  action_fallback RabbitRecipeWeb.FallbackController

  def index(conn, _params) do
    procedures = Recipes.list_procedures()
    render(conn, "index.json", procedures: procedures)
  end

  def create(conn, %{"procedure" => procedure_params}) do
    with {:ok, %Procedure{} = procedure} <- Recipes.create_procedure(procedure_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.procedure_path(conn, :show, procedure))
      |> render("show.json", procedure: procedure)
    end
  end

  def show(conn, %{"id" => id}) do
    procedure = Recipes.get_procedure!(id)
    render(conn, "show.json", procedure: procedure)
  end

  def update(conn, %{"id" => id, "procedure" => procedure_params}) do
    procedure = Recipes.get_procedure!(id)

    with {:ok, %Procedure{} = procedure} <- Recipes.update_procedure(procedure, procedure_params) do
      render(conn, "show.json", procedure: procedure)
    end
  end

  def delete(conn, %{"id" => id}) do
    procedure = Recipes.get_procedure!(id)

    with {:ok, %Procedure{}} <- Recipes.delete_procedure(procedure) do
      send_resp(conn, :no_content, "")
    end
  end
end
