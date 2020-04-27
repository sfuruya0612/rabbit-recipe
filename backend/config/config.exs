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
  secret_key_base: "Wwa7YyCXWHxLE8fXKV1Dg2g7kJM0guH6sJehFP5iUxAOdEsuQgmc6yrX0WLtsl42",
  render_errors: [view: RabbitRecipeWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: RabbitRecipe.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "n0+WN7YZ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
