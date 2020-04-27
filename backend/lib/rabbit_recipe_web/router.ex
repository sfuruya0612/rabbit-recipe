defmodule RabbitRecipeWeb.Router do
  use RabbitRecipeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RabbitRecipeWeb do
    pipe_through :api
  end
end
