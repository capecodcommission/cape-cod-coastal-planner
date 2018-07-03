defmodule ChipApi.ScaleTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Scale, Strategy}

    @moduletag :scale_case

    setup do
        scale1 = %Scale{name: "scale1", impact: 1}
        |> Repo.insert!

        scale2 = %Scale{name: "scale2", impact: 2}
        |> Repo.insert!

        strat1 = %Strategy{
            name: "strat1", 
            description: "desc1",
            adaptation_categories: [],
            coastal_hazards: [],
            impact_scales: [scale1, scale2]
        }
        |> Repo.insert!

        strat2 = %Strategy{
            name: "strat2", 
            description: "desc2",
            adaptation_categories: [],
            coastal_hazards: [],
            impact_scales: [scale1, scale2]
        }
        |> Repo.insert!

        {:ok, data: %{
            scale1: scale1,
            scale2: scale2,
            strat1: strat1,
            strat2: strat2
        }}
    end

    test "list_scales returns all impact scales", %{data: data} do
        scales = for c <- Strategies.list_scales(), do: c.name
        assert [data.scale1.name, data.scale2.name] == scales
    end

    test "get_scale! with a good id returns the correct scale", %{data: data} do
        assert data.scale1 == Strategies.get_scale!(data.scale1.id)
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

    test "get_scale with a good id returns the correct scale", %{data: data} do
       assert data.scale1 == Strategies.get_scale(data.scale1.id)
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

    test "create_scale with duplicate name returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.create_scale(%{
            name: data.scale1.name,
            impact: 6
        })
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
    test "update_scale with a good value returns updated scale", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.update_scale(data.scale1, @attrs)
        end)

        assert {:ok, scale} = Task.await(task)
        assert @attrs ==
            Repo.get!(Scale, scale.id)
            |> Map.take([:description])
    end

    @attrs %{
        description: 5
    }
    test "update_scale with a bad description returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_scale(data.scale1, @attrs)
        assert "is invalid" in errors_on(changeset).description
    end

    @attrs %{
        impact: "twenty"
    }
    test "update_scale with a bad impact returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_scale(data.scale1, @attrs)
        assert "is invalid" in errors_on(changeset).impact
    end

    test "update_scale with a taken name returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_scale(data.scale1, %{name: data.scale2.name})
        assert "has already been taken" in errors_on(changeset).name
    end

    test "delete_scale with a good value removes the scale", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.delete_scale(data.scale2)
        end)

        assert {:ok, scale} = Task.await(task)
        assert nil == Repo.get(Scale, scale.id)
    end
end