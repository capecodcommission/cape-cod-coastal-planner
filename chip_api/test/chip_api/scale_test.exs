defmodule ChipApi.ScaleTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Scale}

    @moduletag :scale_case

    setup do
        ChipApi.Fakes.run_scales()
    end

    test "list_scales returns all impact scales", %{data: data} do
        scales = for s <- Strategies.list_scales(), do: s.name
        assert [data.scale1.name, data.scale2.name] == scales
    end

    @attrs %{order: :desc}
    test "list_scales desc returns all impact scales in descending order", %{data: data} do
        scales = for s <- Strategies.list_scales(@attrs), do: s.name
        assert [data.scale2.name, data.scale1.name] == scales
    end

    test "list_strategies_for_scale returns all strategies for a scale", %{data: data} do
        strategies = for s <- Strategies.list_strategies_for_scale(data.scale1), do: s.name
        assert [data.strat1.name, data.strat2.name] == strategies
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