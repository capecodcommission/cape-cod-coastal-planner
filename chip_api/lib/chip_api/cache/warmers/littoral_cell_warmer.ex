defmodule ChipApi.Cache.Warmers.LittoralCellWarmer do
    @moduledoc """
    Proactive warmer that caches Littoral Cell data from Postgres

    While this is overkill for the scenario, I wanted to include it for illustrative reasons 
    in the event that it could be more useful in future scenarios. One potential use-case
    here would be to make a warmer that uses an http client like HTTPoison to query an
    AGS Service for geospatial data (say, the actual geometries of the littoral cells) on a
    set interval, performs calculations on it (say, to calculate the boundary of the geometry)
    and then caches it while also writing calculated values to db for backup. 
    Or whatever else you can imagine...

    Resources:

    * https://hexdocs.pm/cachex/getting-started.html
    * https://github.com/whitfin/cachex/blob/master/docs/features/cache-warming/proactive-warming.md
    """
    use Cachex.Warmer
    alias ChipApi.Repo
    alias ChipApi.Geospatial.LittoralCell

    def interval,
        do: :timer.seconds(300)

    @doc """
    In a successful operation, `execute/1` returns results in one of two forms: { :ok, pairs } or { :ok, pairs, options }.
    `Cachex.put_many/3` accepts this format readily and is particularly useful when fetching a bunch of remote data so you
    can warm a bunch of records in one pass rather than having a warmer for each row.
    """
    def execute(_) do
        Repo.all(LittoralCell)
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