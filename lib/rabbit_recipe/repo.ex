defmodule RabbitRecipe.Repo do
  use Ecto.Repo,
    otp_app: :rabbit_recipe,
    adapter: Ecto.Adapters.Postgres
end
