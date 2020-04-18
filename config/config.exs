# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :rabbit_recipe,
  ecto_repos: [RabbitRecipe.Repo]

# Configures the endpoint
config :rabbit_recipe, RabbitRecipeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/WCYy8CMlJ6S1HtlRkpuzG88vkrGqz63gTuy6r8eaY9XhDv2e3jJBd/VeYSsjUWa",
  render_errors: [view: RabbitRecipeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RabbitRecipe.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "Vtr9a26g"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
