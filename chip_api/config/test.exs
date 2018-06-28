use Mix.Config


# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chip_api, ChipApiWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :chip_api, ChipApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  database: "chip_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

import_config "#{Mix.env}.secret.exs"