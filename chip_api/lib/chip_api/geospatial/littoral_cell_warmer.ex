defmodule ChipApi.Geospatial.LittoralCellWarmer do
    use Cachex.Warmer

    def interval,
        do: :timer.seconds(30)

    def execute(_state) do
        { :ok, [] }
    end


    defp handle_results({:error, _reason}),
        do: :ignore

    defp handle_results({:ok, _data}) do
        :ok
    end
end