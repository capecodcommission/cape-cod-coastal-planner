defmodule ChipApi.Geospatial.LittoralCellTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Geospatial.{ShorelineLocations, LittoralCell}

    @moduletag :geospatial_case
    @moduletag :littoral_cell_case

    setup do
        ChipApi.Fakes.run_littoral_cells()
    end

    test "list_littoral_cells returns all littoral cells", %{data: data} do
        cells = for l <- ShorelineLocations.list_littoral_cells(), do: l.name
        assert [data.cell1.name, data.cell2.name] == cells
    end

    @attrs %{order: :desc}
    test "list_littoral_cells desc returns all littoral cells in descending order", %{data: data} do
        cells = for l <- ShorelineLocations.list_littoral_cells(@attrs), do: l.name
        assert [data.cell2.name, data.cell1.name] == cells
    end

    @attrs %{filter: %{name: "cell1"}}
    test "list_littoral_cells that match name returns only matching littoral cells", %{data: data} do
        cells = for l <- ShorelineLocations.list_littoral_cells(@attrs), do: l.name
        assert [data.cell1.name] == cells
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
    test "create_littoral_cell with a good values creates a new littoral cell" do
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
        minX: -50.0,
        minY: 42.0,
        maxX: -49.0,
        maxY: 43.0
    }
    test "create_littoral_cell without name returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "can't be blank" in errors_on(changeset).name
    end

    @attrs %{
        minX: -50.0,
        minY: 42.0,
        maxX: -49.0,
        maxY: 43.0
    }
    test "create_littoral_cell with duplicate name returns error and changeset", %{data: data} do
        bad_attrs = Map.put(@attrs, :name, data.cell1.name)
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(bad_attrs)
        assert "has already been taken" in errors_on(changeset).name
    end

    @attrs %{
        name: 405,
        minX: -50.0,
        minY: 42.0,
        maxX: -49.0,
        maxY: 43.0
    }
    test "create_littoral_cell with bad name value returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "is invalid" in errors_on(changeset).name
    end

    @attrs %{
        name: "test",
        minX: "bad",
        minY: 42.0,
        maxX: -49.0,
        maxY: 43.0
    }
    test "create_littoral_cell with bad minX value returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "is invalid" in errors_on(changeset).minX
    end

    @attrs %{
        name: "test",
        minX: -50.0,
        minY: "bad",
        maxX: -49.0,
        maxY: 43.0
    }
    test "create_littoral_cell with bad minY value returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "is invalid" in errors_on(changeset).minY
    end

    @attrs %{
        name: "test",
        minX: -50.0,
        minY: 42.0,
        maxX: "bad",
        maxY: 43.0
    }
    test "create_littoral_cell with bad maxX value returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "is invalid" in errors_on(changeset).maxX
    end

    @attrs %{
        name: "test",
        minX: -50.0,
        minY: 42.0,
        maxX: -49.0,
        maxY: "bad"
    }
    test "create_littoral_cell with bad maxY value returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "is invalid" in errors_on(changeset).maxY
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

    @attrs %{
        name: "cell3"
    }
    test "update_littoral_cell with a good name value returns updated littoral cell", %{data: data} do
        parent = self()
        task = Task.async(fn -> 
            allow(parent, self())
            ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        end)

        assert {:ok, cell} = Task.await(task)
        assert @attrs ==
            Repo.get!(LittoralCell, cell.id)
            |> Map.take([:name])
    end

    @attrs %{
        minX: -39.3
    }
    test "update_littoral_cell with a good minX value returns updated littoral cell", %{data: data} do
        parent = self()
        task = Task.async(fn -> 
            allow(parent, self())
            ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        end)

        assert {:ok, cell} = Task.await(task)
        assert @attrs ==
            Repo.get!(LittoralCell, cell.id)
            |> Map.take([:minX])
    end

    @attrs %{
        minY: 41.7
    }
    test "update_littoral_cell with a good minY value returns updated littoral cell", %{data: data} do
        parent = self()
        task = Task.async(fn -> 
            allow(parent, self())
            ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        end)

        assert {:ok, cell} = Task.await(task)
        assert @attrs ==
            Repo.get!(LittoralCell, cell.id)
            |> Map.take([:minY])
    end

    @attrs %{
        maxX: 39.3
    }
    test "update_littoral_cell with a good maxX value returns updated littoral cell", %{data: data} do
        parent = self()
        task = Task.async(fn -> 
            allow(parent, self())
            ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        end)

        assert {:ok, cell} = Task.await(task)
        assert @attrs ==
            Repo.get!(LittoralCell, cell.id)
            |> Map.take([:maxX])
    end

    @attrs %{
        maxY: 55.3
    }
    test "update_littoral_cell with a good maxY value returns updated littoral cell", %{data: data} do
        parent = self()
        task = Task.async(fn -> 
            allow(parent, self())
            ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        end)

        assert {:ok, cell} = Task.await(task)
        assert @attrs ==
            Repo.get!(LittoralCell, cell.id)
            |> Map.take([:maxY])
    end

    @attrs %{
        name: 5
    }
    test "update_littoral_cell with a bad name value returns error and changeset", %{data: data} do
        assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        assert "is invalid" in errors_on(changeset).name
    end

    test "update_littoral_cell with a taken name returns error and changeset", %{data: data} do
        assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, %{name: data.cell2.name})
        assert "has already been taken" in errors_on(changeset).name
    end

    @attrs %{
        minX: "bad"
    }
    test "update_littoral_cell with a bad minX value returns error and changeset", %{data: data} do
        assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        assert "is invalid" in errors_on(changeset).minX
    end
    
    @attrs %{
        minY: "bad"
    }
    test "update_littoral_cell with a bad minY value returns error and changeset", %{data: data} do
        assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        assert "is invalid" in errors_on(changeset).minY
    end
    
    @attrs %{
        maxX: "bad"
    }
    test "update_littoral_cell with a bad maxX value returns error and changeset", %{data: data} do
        assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        assert "is invalid" in errors_on(changeset).maxX
    end
    
    @attrs %{
        maxY: "bad"
    }
    test "update_littoral_cell with a bad maxY value returns error and changeset", %{data: data} do
        assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        assert "is invalid" in errors_on(changeset).maxY
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