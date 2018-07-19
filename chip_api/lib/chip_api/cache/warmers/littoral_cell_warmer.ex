defmodule ChipApi.Cache.Warmers.LittoralCellWarmer do
    @moduledoc """
    Proactive warmer that caches Littoral Cell geometries from AGS Server

    Resources:

    * https://hexdocs.pm/cachex/getting-started.html
    * https://github.com/whitfin/cachex/blob/master/docs/features/cache-warming/proactive-warming.md
    """
    use Cachex.Warmer

    def interval,
        do: :timer.seconds(30)

    @doc """
    In a successful operation, `execute/1` returns results in one of two forms: { :ok, pairs } or { :ok, pairs, options }.
    `Cachex.put_many/3` accepts this format readily and is particularly useful when fetching a bunch of remote data so you
    can warm a bunch of records in one pass rather than having a warmer for each row.
    """
    def execute(url) do
        {:ok, []}
    end

    defp handle_results({:ok, data}) do
        {:ok, []}
    end
end