defmodule ChipApi.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec
    import Cachex.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(ChipApi.Repo, []),
      # Start the endpoint when the application starts
      supervisor(ChipApiWeb.Endpoint, []),
      # Start your own worker by calling: ChipApi.Worker.start_link(arg1, arg2, arg3)
      worker(Cachex, [ 
        :littoral_cell_cache, [
          warmers: [
            warmer(module: ChipApi.Cache.Warmers.LittoralCellWarmer)
          ]
        ] 
      ], id: :cachex_worker_1),
      worker(Cachex, [ 
        :adaptation_strategy_cache, [
          warmers: [
            warmer(module: ChipApi.Cache.Warmers.AdaptationStrategyWarmer)
          ]
        ]
      ], id: :cachex_worker_2)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChipApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ChipApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
