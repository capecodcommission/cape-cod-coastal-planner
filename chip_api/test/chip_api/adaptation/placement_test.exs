defmodule ChipApi.Adaptation.PlacementTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Placement}

    @moduletag :adaptation_case
    @moduletag :placement_case

    setup do
        ChipApi.Fakes.run_placements()
    end

    test "list_placements returns all strategy placements", %{data: data} do
        placements = for c <- Strategies.list_placements(), do: c.name
        assert [data.place1.name, data.place2.name] == placements
    end

    test "list_strategies_for_placement returns all strategies for a placement", %{data: data} do
        placements = for s <- Strategies.list_strategies_for_placement(data.place1), do: s.name
        assert [data.strat1.name, data.strat2.name] == placements
    end

    test "get_placement! with a good id returns the correct placement", %{data: data} do
        assert data.place1 == Strategies.get_placement!(data.place1.id)
    end

    test "get_placement! with a bad id raises Ecto.NoResultsError" do
        try do
            _ = Strategies.get_placement!(-1)
        rescue
            Ecto.NoResultsError -> assert true == true

            _ ->
                assert true == false
        end
    end

    test "get_placement with a good id returns the correct placement", %{data: data} do
        assert data.place1 == Strategies.get_placement(data.place1.id)
    end

    test "get_placement with a bad id returns nil" do
        assert Strategies.get_placement(-1) == nil
    end

    @attrs %{name: "test"}
    test "create_placement with a good value creates a new placement" do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.create_placement(@attrs)
        end)

        assert {:ok, placement} = Task.await(task)
        assert @attrs ==
            Repo.get!(Placement, placement.id)
            |> Map.take([:name])
    end

    @attrs %{}
    test "create_placement without name returns error and changeset" do
        assert {:error, changeset} = Strategies.create_placement(@attrs)
        assert "can't be blank" in errors_on(changeset).name
    end

    test "create_placement with duplicate name returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.create_placement(%{name: data.place1.name})
        assert "has already been taken" in errors_on(changeset).name
    end

    @attrs %{name: "place3"}
    test "update_placement with a good value returns updated placement", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.update_placement(data.place1, @attrs)
        end)

        assert {:ok, placement} = Task.await(task)
        assert @attrs ==
            Repo.get!(Placement, placement.id)
            |> Map.take([:name])
    end

    @attrs %{name: 5}
    test "update_placement with a bad value returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_placement(data.place1, @attrs)
        assert "is invalid" in errors_on(changeset).name
    end

    test "update_placement with a taken name returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_placement(data.place1, %{name: data.place2.name})
        assert "has already been taken" in errors_on(changeset).name
    end

    test "delete_placement with a good value removes the placement", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.delete_placement(data.place1)
        end)

        assert {:ok, placement} = Task.await(task)
        assert nil == Repo.get(Placement, placement.id)
    end
end