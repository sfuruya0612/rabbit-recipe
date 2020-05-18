defmodule RabbitRecipeWeb.Router do
  use RabbitRecipeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RabbitRecipeWeb do
    pipe_through :api

    # Recipe
    # Title
    get("/title", TitleController, :index)
    post("/title/:title", TitleController, :create)
    get("/title/:id", TitleController, :show)
    put("/title/:id/:title", TitleController, :update)
    delete("/title/:id", TitleController, :delete)

    # Healthcheck
    get("/healthcheck", HealthcheckController, :index)
  end
end
