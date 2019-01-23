use Mix.Config

# Create a `test.secret.exs` file on your dev and/or build machine and add the following
# in order to use a local test db instance:
#
# use Mix.Config
# 
# config :chip_api, ChipApi.Repo,
#    password: "local_db_password"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chip_api, ChipApiWeb.Endpoint,
  http: [port: 4000],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :chip_api, ChipApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  database: "chip_api_test",
  hostname: "localhost",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox

import_config "#{Mix.env}.secret.exs"