defmodule ChipApi.Geospatial.PlanningAreas do
    @moduledoc """
    The Planning Areas context.
    """

    import Ecto.Query, warn: false
    alias ChipApi.Repo

    #
    # PLANNING AREAS (aka: Littoral Cells)
    #

    alias ChipApi.Geospatial.LittoralCell

    @doc """
    Returns the list of planning areas (aka: littoral cells)

    ## Examples

        iex> list_areas(%{order: :desc})
        [%LittoralCell{}, ...]

        iex> list_areas()
        [%LittoralCell{}, ...]

    """
    def list_areas(args) do
        args
        |> Enum.reduce(LittoralCell, fn
            {:order, order}, query ->
                query |> order_by([{^order, :name}, {^order, :id}])
        end)
        |> Repo.all
    end
    def list_areas() do
        Repo.all(LittoralCell)
    end
end