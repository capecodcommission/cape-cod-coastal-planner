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
        min_x: -50.0,
        min_y: 42.0,
        max_x: -49.0,
        max_y: 43.0
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
            |> Map.take([:name, :min_x, :min_y, :max_x, :max_y])
    end

    @attrs %{
        min_x: -50.0,
        min_y: 42.0,
        max_x: -49.0,
        max_y: 43.0
    }
    test "create_littoral_cell without name returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "can't be blank" in errors_on(changeset).name
    end

    @attrs %{
        min_x: -50.0,
        min_y: 42.0,
        max_x: -49.0,
        max_y: 43.0
    }
    test "create_littoral_cell with duplicate name returns error and changeset", %{data: data} do
        bad_attrs = Map.put(@attrs, :name, data.cell1.name)
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(bad_attrs)
        assert "has already been taken" in errors_on(changeset).name
    end

    @attrs %{
        name: 405,
        min_x: -50.0,
        min_y: 42.0,
        max_x: -49.0,
        max_y: 43.0
    }
    test "create_littoral_cell with bad name value returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "is invalid" in errors_on(changeset).name
    end

    @attrs %{
        name: "test",
        min_x: "bad",
        min_y: 42.0,
        max_x: -49.0,
        max_y: 43.0
    }
    test "create_littoral_cell with bad min_x value returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "is invalid" in errors_on(changeset).min_x
    end

    @attrs %{
        name: "test",
        min_x: -50.0,
        min_y: "bad",
        max_x: -49.0,
        max_y: 43.0
    }
    test "create_littoral_cell with bad min_y value returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "is invalid" in errors_on(changeset).min_y
    end

    @attrs %{
        name: "test",
        min_x: -50.0,
        min_y: 42.0,
        max_x: "bad",
        max_y: 43.0
    }
    test "create_littoral_cell with bad max_x value returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "is invalid" in errors_on(changeset).max_x
    end

    @attrs %{
        name: "test",
        min_x: -50.0,
        min_y: 42.0,
        max_x: -49.0,
        max_y: "bad"
    }
    test "create_littoral_cell with bad max_y value returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "is invalid" in errors_on(changeset).max_y
    end

    @attrs %{
        name: "test",
        min_y: 42.0,
        max_x: -49.0,
        max_y: 43.0
    }
    test "create_littoral_cell without min_x returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "can't be blank" in errors_on(changeset).min_x
    end

    @attrs %{
        name: "test",
        min_x: -50.0,
        max_x: -49.0,
        max_y: 43.0
    }
    test "create_littoral_cell without min_y returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "can't be blank" in errors_on(changeset).min_y
    end

    @attrs %{
        name: "test",
        min_x: -50.0,
        min_y: 42.0,
        max_y: 43.0
    }
    test "create_littoral_cell without max_x returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "can't be blank" in errors_on(changeset).max_x
    end

    @attrs %{
        name: "test",
        min_x: -50.0,
        min_y: 42.0,
        max_x: -49.0
    }
    test "create_littoral_cell without max_y returns error and changeset" do
        assert {:error, changeset} = ShorelineLocations.create_littoral_cell(@attrs)
        assert "can't be blank" in errors_on(changeset).max_y
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
        min_x: -39.3
    }
    test "update_littoral_cell with a good min_x value returns updated littoral cell", %{data: data} do
        parent = self()
        task = Task.async(fn -> 
            allow(parent, self())
            ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        end)

        assert {:ok, cell} = Task.await(task)
        assert @attrs ==
            Repo.get!(LittoralCell, cell.id)
            |> Map.take([:min_x])
    end

    @attrs %{
        min_y: 41.7
    }
    test "update_littoral_cell with a good min_y value returns updated littoral cell", %{data: data} do
        parent = self()
        task = Task.async(fn -> 
            allow(parent, self())
            ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        end)

        assert {:ok, cell} = Task.await(task)
        assert @attrs ==
            Repo.get!(LittoralCell, cell.id)
            |> Map.take([:min_y])
    end

    @attrs %{
        max_x: 39.3
    }
    test "update_littoral_cell with a good max_x value returns updated littoral cell", %{data: data} do
        parent = self()
        task = Task.async(fn -> 
            allow(parent, self())
            ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        end)

        assert {:ok, cell} = Task.await(task)
        assert @attrs ==
            Repo.get!(LittoralCell, cell.id)
            |> Map.take([:max_x])
    end

    @attrs %{
        max_y: 55.3
    }
    test "update_littoral_cell with a good max_y value returns updated littoral cell", %{data: data} do
        parent = self()
        task = Task.async(fn -> 
            allow(parent, self())
            ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        end)

        assert {:ok, cell} = Task.await(task)
        assert @attrs ==
            Repo.get!(LittoralCell, cell.id)
            |> Map.take([:max_y])
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
        min_x: "bad"
    }
    test "update_littoral_cell with a bad min_x value returns error and changeset", %{data: data} do
        assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        assert "is invalid" in errors_on(changeset).min_x
    end
    
    @attrs %{
        min_y: "bad"
    }
    test "update_littoral_cell with a bad min_y value returns error and changeset", %{data: data} do
        assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        assert "is invalid" in errors_on(changeset).min_y
    end
    
    @attrs %{
        max_x: "bad"
    }
    test "update_littoral_cell with a bad max_x value returns error and changeset", %{data: data} do
        assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        assert "is invalid" in errors_on(changeset).max_x
    end
    
    @attrs %{
        max_y: "bad"
    }
    test "update_littoral_cell with a bad max_y value returns error and changeset", %{data: data} do
        assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
        assert "is invalid" in errors_on(changeset).max_y
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