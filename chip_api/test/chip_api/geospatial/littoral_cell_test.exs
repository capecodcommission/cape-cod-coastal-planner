defmodule ChipApi.Geospatial.LittoralCellTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Geospatial.{ShorelineLocations, LittoralCell}

    @moduletag :geospatial_case
    @moduletag :littoral_cell_case

    setup do
        ChipApi.Fakes.run_littoral_cells()
    end

    test "list_littoral_cells returns all littoral cells", %{data: data} do
        hazards = for h <- ShorelineLocations.list_littoral_cells(), do: h.name
        assert [data.cell1.name, data.cell2.name] == hazards
    end

    @attrs %{order: :desc}
    test "list_littoral_cells desc returns all littoral cells in descending order", %{data: data} do
        hazards = for h <- ShorelineLocations.list_littoral_cells(@attrs), do: h.name
        assert [data.cell2.name, data.cell1.name] == hazards
    end

    test "get_littoral_cell! with a good id returns the correct littoral cell", %{data: data} do
        assert data.cell1 == ShorelineLocations.get_littoral_cell!(data.cell1.id)
    end

    test "get_littoral_cell! with a bad id raises Ecto.NoResultsError" do
        try do
            _ = ShorelineLocations.get_littoral_cell!(-1)
        rescue
            Ecto.NoResultsError -> assert true == true

            _ ->
                assert true == false
        end
    end

    test "get_littoral_cell with a good id returns the correct littoral cell", %{data: data} do
        assert data.cell1 == ShorelineLocations.get_littoral_cell(data.cell1.id)
    end

    test "get_littoral_cell with a bad id returns nil" do
        assert ShorelineLocations.get_littoral_cell(-1) == nil
    end

    @attrs %{
        name: "test",
        minX: -50.0,
        minY: 42.0,
        maxX: -49.0,
        maxY: 43.0
    }
    test "create_littoral_cell with a good value creates a new littoral cell" do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            ShorelineLocations.create_littoral_cell(@attrs)
        end)

        assert {:ok, cell} = Task.await(task)
        assert @attrs ==
            Repo.get!(LittoralCell, cell.id)
            |> Map.take([:name, :minX, :minY, :maxX, :maxY])
    end

    @attrs %{
        name: "test",
        minY: 42.0,
        maxX: -49.0,
        maxY: 43.0
    }
    test "create_littoral_cell without minX returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "can't be blank" in errors_on(changeset).minX
    end

    @attrs %{
        name: "test",
        minX: -50.0,
        maxX: -49.0,
        maxY: 43.0
    }
    test "create_littoral_cell without minY returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "can't be blank" in errors_on(changeset).minY
    end

    @attrs %{
        name: "test",
        minX: -50.0,
        minY: 42.0,
        maxY: 43.0
    }
    test "create_littoral_cell without maxX returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "can't be blank" in errors_on(changeset).maxX
    end

    @attrs %{
        name: "test",
        minX: -50.0,
        minY: 42.0,
        maxX: -49.0
    }
    test "create_littoral_cell without maxY returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "can't be blank" in errors_on(changeset).maxY
    end

end