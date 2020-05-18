defmodule RabbitRecipeWeb.TitleController do
  use RabbitRecipeWeb, :controller

  alias RabbitRecipe.Recipes
  alias RabbitRecipe.Recipes.Title

  action_fallback RabbitRecipeWeb.FallbackController

  def index(conn, _params) do
    titles = Recipes.list_titles()
    render(conn, "index.json", titles: titles)
  end

  def create(conn, %{"title" => title_params}) do
    with {:ok, %Title{} = title} <- Recipes.create_title(title_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.title_path(conn, :show, title))
      |> render("show.json", title: title)
    end
  end

  def show(conn, %{"id" => id}) do
    title = Recipes.get_title!(id)
    render(conn, "show.json", title: title)
  end

  def update(conn, %{"id" => id, "title" => title_params}) do
    title = Recipes.get_title!(id)

    with {:ok, %Title{} = title} <- Recipes.update_title(title, title_params) do
      render(conn, "show.json", title: title)
    end
  end

  def delete(conn, %{"id" => id}) do
    title = Recipes.get_title!(id)

    with {:ok, %Title{}} <- Recipes.delete_title(title) do
      send_resp(conn, :no_content, "")
    end
  end
end
