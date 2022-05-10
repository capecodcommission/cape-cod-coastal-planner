defmodule ChipApi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :chip_api,
      version: "0.0.1",
      # elixir: "~> 1.6.5",
      elixir: "~> 1.13.3",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ChipApi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "dev/support", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "dev/support"]
  defp elixirc_paths(:prod), do: ["lib", "prod/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.6"},
      {:phoenix_pubsub, "~> 2.1.0"},
      {:phoenix_ecto, "~> 4.4.0"},
      {:ecto_sql, "~> 3.0-rc.1"},
      {:postgrex, ">= 0.13.5"},
      {:cachex, "~> 3.0.3"},
      {:httpoison, "~> 1.2"},
      {:poison, "~> 3.1"},
      {:phoenix_html, "~> 2.14.2"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:cors_plug, "~> 1.5.2"},
      {:absinthe, "~> 1.5.0"},
      {:absinthe_plug, "~> 1.5.8"},
      {:absinthe_phoenix, "~> 2.0.2"},
      {:unsafe, "~> 1.0"},
      {:zarex, "~> 0.4"},
      {:excoveralls, "~> 0.9.1", only: :test},
      {:distillery, "~> 1.5.3", runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["test"],
      "dump": ["ecto.dump -d priv/repo/migrations.sql"]
    ]
  end
end
