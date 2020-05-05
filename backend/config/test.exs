use Mix.Config

# Configure your database
config :rabbit_recipe, RabbitRecipe.Repo,
  username: "root",
  password: "root",
  database: "rabbit_recipe_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rabbit_recipe, RabbitRecipeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
