defmodule ChipApiWeb.Schema do
    use Absinthe.Schema
    alias ChipApi.{Strategies, Repo}

    import_types __MODULE__.StrategyTypes

    query do
        import_fields :strategies_queries
    end
end