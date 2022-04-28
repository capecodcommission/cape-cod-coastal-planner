# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chip_api,
  ecto_repos: [ChipApi.Repo]

# Configures the endpoint
config :chip_api, ChipApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8j7cl7qTlB6Hw7x91lHl+X98tiaWKXjNQ9aM44bGEB/S0Om3G0TpGpfhYXjViqmD",
  render_errors: [view: ChipApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: [name: ChipApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
