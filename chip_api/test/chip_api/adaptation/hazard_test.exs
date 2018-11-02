defmodule ChipApi.Adaptation.HazardTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Hazard}

    @moduletag :adaptation_case
    @moduletag :hazard_case

    setup do
        ChipApi.Fakes.run_hazards()
    end

    test "list_hazards returns all coastal hazards", %{data: data} do
        hazards = for h <- Strategies.list_hazards(), do: h.name
        assert [data.haz1.name, data.haz2.name] == hazards
    end

    @attrs %{order: :desc}
    test "list_hazards desc returns all coastal hazards in descending order", %{data: data} do
        hazards = for h <- Strategies.list_hazards(@attrs), do: h.name
        assert [data.haz1.name, data.haz2.name] == hazards
    end

    test "list_strategies_for_hazard returns all strategies for a hazard", %{data: data} do
        strategies = for s <- Strategies.list_strategies_for_hazard(data.haz1), do: s.name
        assert [data.strat1.name, data.strat2.name] == strategies
    end

    test "get_hazard! with a good id returns the correct hazard", %{data: data} do
        assert data.haz1 == Strategies.get_hazard!(data.haz1.id)
    end

    test "get_hazard! with a bad id raises Ecto.NoResultsError" do
        try do
            _ = Strategies.get_hazard!(-1)
        rescue
            Ecto.NoResultsError -> assert true == true

            _ ->
                assert true == false
        end
    end

    test "get_hazard with a good id returns the correct hazard", %{data: data} do
        assert data.haz1 == Strategies.get_hazard(data.haz1.id)
    end

    test "get_hazard with a bad id returns nil" do
        assert Strategies.get_hazard(-1) == nil
    end

    @attrs %{
        name: "test",
        description: "test",
        duration: "test"
    }
    test "create_hazard with a good value creates a new hazard" do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.create_hazard(@attrs)
        end)

        assert {:ok, hazard} = Task.await(task)
        assert @attrs ==
            Repo.get!(Hazard, hazard.id)
            |> Map.take([:name, :description, :duration])
    end

    @attrs %{
        description: "test"
    }
    test "create_hazard without name returns error and changeset" do
        assert {:error, changeset} = Strategies.create_hazard(@attrs)
        assert "can't be blank" in errors_on(changeset).name
    end

    test "create_hazard with duplicate name returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.create_hazard(%{name: data.haz1.name, duration: data.haz1.duration})
        assert "has already been taken" in errors_on(changeset).name
    end

    @attrs %{
        description: "new description"
    }
    test "update_hazard with a good value returns updated hazard", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.update_hazard(data.haz1, @attrs)
        end)

        assert {:ok, hazard} = Task.await(task)
        assert @attrs ==
            Repo.get!(Hazard, hazard.id)
            |> Map.take([:description])
    end

    @attrs %{
        description: 5
    }
    test "update_hazard with a bad value returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_hazard(data.haz1, @attrs)
        assert "is invalid" in errors_on(changeset).description
    end

    test "update_hazard with to a taken name returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_hazard(data.haz1, %{name: data.haz2.name})
        assert "has already been taken" in errors_on(changeset).name
    end

    test "delete_hazard with a good value removes the hazard", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.delete_hazard(data.haz2)
        end)

        assert {:ok, hazard} = Task.await(task)
        assert nil == Repo.get(Hazard, hazard.id)
    end
end