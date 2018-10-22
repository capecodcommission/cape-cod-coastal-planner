defmodule ChipApi.Cache.Warmers.AdaptationStrategyWarmer do
    use Cachex.Warmer
    alias ChipApi.Repo
    alias ChipApi.Adaptation.Strategy

    def interval,
        do: :timer.seconds(300)

    @doc """
    In a successful operation, `execute/1` returns results in one of two forms: { :ok, pairs } or { :ok, pairs, options }.
    `Cachex.put_many/3` accepts this format readily and is particularly useful when fetching a bunch of remote data so you
    can warm a bunch of records in one pass rather than having a warmer for each row.
    """
    def execute(_) do
        Repo.all(Strategy)
        |> handle_results()
    end
    
    defp handle_results(rows) when is_list(rows) do
        {:ok, Enum.map(rows, fn(row) ->
            { row.id, row }
        end)}
    end
    defp handle_results(_) do
        :ignore
    end
end