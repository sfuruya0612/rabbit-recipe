defmodule RabbitRecipeWeb.PageController do
  use RabbitRecipeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
