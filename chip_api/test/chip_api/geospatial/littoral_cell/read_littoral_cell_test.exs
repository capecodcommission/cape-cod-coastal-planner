defmodule ChipApi.Geospatial.LittoralCell.ReadLittoralCellTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Geospatial.{ShorelineLocations, LittoralCell}

    @moduletag :geospatial_case
    @moduletag :littoral_cell_case
    @moduletag :read_case

    setup do
        ChipApi.Fakes.run_littoral_cells()
    end

    describe "list_littoral_cells/0" do        
        test "returns all littoral cells", %{data: data} do
            cells = for l <- ShorelineLocations.list_littoral_cells(), do: l.name
            assert [data.cell1.name, data.cell2.name] == cells
        end
    end

    describe "list_littoral_cells/1" do        
        @attrs %{order: :asc}
        test "returns all littoral cells in ascending order", %{data: data} do
            cells = for l <- ShorelineLocations.list_littoral_cells(@attrs), do: l.name
            assert [data.cell1.name, data.cell2.name] == cells
        end

        @attrs %{order: :desc}
        test "returns all littoral cells in descending order", %{data: data} do
            cells = for l <- ShorelineLocations.list_littoral_cells(@attrs), do: l.name
            assert [data.cell2.name, data.cell1.name] == cells
        end

        @attrs %{filter: %{name: "cell1"}}
        test "filtered on name returns matching littoral cells when found", %{data: data} do
            cells = for l <- ShorelineLocations.list_littoral_cells(@attrs), do: l.name
            assert [data.cell1.name] == cells
        end

        @attrs %{filter: %{name: "cell12"}}
        test "filtered on name returns no littoral cells when none found", %{data: data} do
            cells = for l <- ShorelineLocations.list_littoral_cells(@attrs), do: l.name
            assert [] == cells
        end
    end

    describe "get_littoral_cell!/1" do        
        test "with a good id returns the correct littoral cell", %{data: data} do
            assert data.cell1 == ShorelineLocations.get_littoral_cell!(data.cell1.id)
        end

        test "with a bad id raises Ecto.NoResultsError" do
            try do
                _ = ShorelineLocations.get_littoral_cell!(-1)
            rescue
                Ecto.NoResultsError -> assert true == true

                _ ->
                    assert true == false
            end
        end
    end

    describe "get_littoral_cell/1" do        
        test "with a good id (%{id: id}) returns the correct littoral cell", %{data: data} do
            assert data.cell1 == ShorelineLocations.get_littoral_cell(%{id: data.cell1.id})
        end

        test "with a good id (integer) returns the correct littoral cell", %{data: data} do
            assert data.cell1 == ShorelineLocations.get_littoral_cell(data.cell1.id)
        end

        test "with a bad id returns nil" do
            assert ShorelineLocations.get_littoral_cell(-1) == nil
        end
    end

end