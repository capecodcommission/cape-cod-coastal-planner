defmodule ChipApi.ScaleTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Scale}

    @moduletag :scale_case

    setup do
        ChipApi.Seeds.run()
    end

    test "list_scales returns all impact scales" do
        scales = for c <- Strategies.list_scales(), do: c.name
        assert ["Site", "Neighborhood", "Community", "Regional"] == scales
    end

    test "get_scale! with a good id returns the correct scale" do
        a_scale = from(c in Scale, where: c.name == "Site") |> Repo.one!
        
        the_scale = Strategies.get_scale!(a_scale.id)

        assert a_scale == the_scale
    end

    test "get_scale! with a bad id raises Ecto.NoResultsError" do
        try do
            _ = Strategies.get_scale!(-1)
        rescue
            Ecto.NoResultsError -> assert true == true

            _ ->
                assert true == false
        end
    end

    test "get_scale with a good id returns the correct scale" do
        a_scale = from(c in Scale, where: c.name == "Site") |> Repo.one!

        the_scale = Strategies.get_scale(a_scale.id)

        assert a_scale == the_scale
    end

    test "get_scale with a bad id returns nil" do
        assert Strategies.get_scale(-1) == nil
    end

    @attrs %{
        name: "test",
        description: "test",
        impact: 6
    }
    test "create_scale with a good value creates a new scale" do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.create_scale(@attrs)
        end)

        assert {:ok, scale} = Task.await(task)
        assert @attrs ==
            Repo.get!(Scale, scale.id)
            |> Map.take([:name, :description, :impact])
    end

    @attrs %{
        description: "test",
        impact: 6
    }
    test "create_scale without name returns error and changeset" do
        assert {:error, changeset} = Strategies.create_scale(@attrs)
        assert "can't be blank" in errors_on(changeset).name
    end

    @attrs %{
        name: "test",
        impact: 6
    }
    test "create_scale with duplicate name returns error and changeset" do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.create_scale(@attrs)
        end)

        assert {:ok, _scale} = Task.await(task)
        assert {:error, changeset} = Strategies.create_scale(@attrs)
        assert "has already been taken" in errors_on(changeset).name
    end

    @attrs %{
        name: "test"
    }
    test "create_scale without impact returns error and changeset" do
        assert {:error, changeset} = Strategies.create_scale(@attrs)
        assert "can't be blank" in errors_on(changeset).impact
    end

    @attrs %{
        description: "new description"
    }
    test "update_scale with a good value returns updated scale" do
        a_scale = from(c in Scale, where: c.name == "Site") |> Repo.one!

        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.update_scale(a_scale, @attrs)
        end)

        assert {:ok, scale} = Task.await(task)
        assert @attrs ==
            Repo.get!(Scale, scale.id)
            |> Map.take([:description])
    end

    @attrs %{
        description: 5
    }
    test "update_scale with a bad description returns error and changeset" do
        a_scale = from(c in Scale, where: c.name == "Site") |> Repo.one!
        
        assert {:error, changeset} = Strategies.update_scale(a_scale, @attrs)
        assert "is invalid" in errors_on(changeset).description
    end

    @attrs %{
        impact: "twenty"
    }
    test "update_scale with a bad impact returns error and changeset" do
        a_scale = from(c in Scale, where: c.name == "Site") |> Repo.one!

        assert {:error, changeset} = Strategies.update_scale(a_scale, @attrs)
        assert "is invalid" in errors_on(changeset).impact
    end

    @attrs %{
        name: "Regional"
    }
    test "update_scale with to a taken name returns error and changeset" do
        a_scale = from(c in Scale, where: c.name == "Site") |> Repo.one!

        assert {:error, changeset} = Strategies.update_scale(a_scale, @attrs)
        assert "has already been taken" in errors_on(changeset).name
    end

    test "delete_scale with a good value removes the scale" do
        a_scale = from(c in Scale, where: c.name == "Site") |> Repo.one!

        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.delete_scale(a_scale)
        end)

        assert {:ok, scale} = Task.await(task)
        assert nil == Repo.get(Scale, scale.id)
    end
end