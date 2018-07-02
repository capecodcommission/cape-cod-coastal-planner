defmodule ChipApi.HazardTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Hazard}

    @moduletag :hazard_case

    setup do
        ChipApi.Seeds.run()
    end

    test "list_hazards returns all coastal hazards" do
        hazards = for c <- Strategies.list_hazards(), do: c.name
        assert ["Erosion", "Storm Surge", "Sea Level Rise"] == hazards
    end

    test "get_hazard! with a good id returns the correct hazard" do
        a_hazard = from(c in Hazard, where: c.name == "Erosion") |> Repo.one!
        
        the_hazard = Strategies.get_hazard!(a_hazard.id)

        assert a_hazard == the_hazard
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

    test "get_hazard with a good id returns the correct hazard" do
        a_hazard = from(c in Hazard, where: c.name == "Erosion") |> Repo.one!

        the_hazard = Strategies.get_hazard(a_hazard.id)

        assert a_hazard == the_hazard
    end

    test "get_hazard with a bad id returns nil" do
        assert Strategies.get_hazard(-1) == nil
    end

    @attrs %{
        name: "test",
        description: "test"
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
            |> Map.take([:name, :description])
    end

    @attrs %{
        description: "test"
    }
    test "create_hazard without name returns error and changeset" do
        assert {:error, changeset} = Strategies.create_hazard(@attrs)
        assert "can't be blank" in errors_on(changeset).name
    end

    @attrs %{
        name: "test"
    }
    test "create_hazard with duplicate name returns error and changeset" do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.create_hazard(@attrs)
        end)

        assert {:ok, hazard} = Task.await(task)
        assert {:error, changeset} = Strategies.create_hazard(@attrs)
        assert "has already been taken" in errors_on(changeset).name
    end

    @attrs %{
        description: "new description"
    }
    test "update_hazard with a good value returns updated hazard" do
        a_hazard = from(c in Hazard, where: c.name == "Erosion") |> Repo.one!

        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.update_hazard(a_hazard, @attrs)
        end)

        assert {:ok, hazard} = Task.await(task)
        assert @attrs ==
            Repo.get!(Hazard, hazard.id)
            |> Map.take([:description])
    end

    @attrs %{
        description: 5
    }
    test "update_hazard with a bad value returns error and changeset" do
        a_hazard = from(c in Hazard, where: c.name == "Erosion") |> Repo.one!
        
        assert {:error, changeset} = Strategies.update_hazard(a_hazard, @attrs)
        assert "is invalid" in errors_on(changeset).description
    end

    @attrs %{
        name: "Storm Surge"
    }
    test "update_hazard with to a taken name returns error and changeset" do
        a_hazard = from(c in Hazard, where: c.name == "Erosion") |> Repo.one!

        assert {:error, changeset} = Strategies.update_hazard(a_hazard, @attrs)
        assert "has already been taken" in errors_on(changeset).name
    end

    test "delete_hazard with a good value removes the hazard" do
        a_hazard = from(c in Hazard, where: c.name == "Erosion") |> Repo.one!

        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.delete_hazard(a_hazard)
        end)

        assert {:ok, hazard} = Task.await(task)
        assert nil == Repo.get(Hazard, hazard.id)
    end
end