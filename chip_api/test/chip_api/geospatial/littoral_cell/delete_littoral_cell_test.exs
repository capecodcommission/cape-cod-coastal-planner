defmodule ChipApi.Geospatial.LittoralCell.DeleteLittoralCellTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Geospatial.{ShorelineLocations, LittoralCell}
    alias Decimal, as: D

    @moduletag :geospatial_case
    @moduletag :littoral_cell_case
    @moduletag :delete_case

    setup do
        ChipApi.Fakes.run_littoral_cells()
    end

    test "delete_littoral_cell with a good value removes the littoral cell", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            ShorelineLocations.delete_littoral_cell(data.cell2)
        end)

        assert {:ok, cell} = Task.await(task)
        assert nil == Repo.get(LittoralCell, cell.id)
    end
end