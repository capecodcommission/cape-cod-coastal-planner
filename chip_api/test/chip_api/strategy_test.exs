defmodule ChipApi.StrategyTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Strategy, Category, Hazard, Scale}

    @moduletag :strategy_case

    setup do
        cat1 = %Category{name: "cat1"}
        |> Repo.insert!

        cat2 = %Category{name: "cat2"}
        |> Repo.insert!

        haz1 = %Hazard{name: "haz1"}
        |> Repo.insert!

        haz2 = %Hazard{name: "haz2"}
        |> Repo.insert!

        scale1 = %Scale{name: "scale1", impact: 1}
        |> Repo.insert!

        scale2 = %Scale{name: "scale2", impact: 2}
        |> Repo.insert!

        strat1 = %Strategy{
            name: "strat1", 
            description: "desc1",
            adaptation_categories: [cat1, cat2],
            coastal_hazards: [haz1, haz2],
            impact_scales: [scale1, scale2]
        }
        |> Repo.insert!

        strat2 = %Strategy{
            name: "strat2", 
            description: "desc2",
            adaptation_categories: [cat1, cat2],
            coastal_hazards: [haz1, haz2],
            impact_scales: [scale1, scale2]
        }
        |> Repo.insert!

        {:ok, data: %{
            cat1: cat1,
            cat2: cat2,
            haz1: haz1,
            haz2: haz2,
            scale1: scale1,
            scale2: scale2,
            strat1: strat1,
            strat2: strat2
        }}
    end

    test "list_strategies returns all adaptation strategies", %{data: data} do
        strategies = for s <- Strategies.list_strategies(), do: s.name
        assert [data.strat1.name, data.strat2.name] == strategies
    end

    test "list_categories_for_strategy returns all categories for a strategy", %{data: data} do
        categories = for c <- Strategies.list_categories_for_strategy(data.strat1), do: c.name
        assert [data.cat1.name, data.cat2.name] == categories
    end

    test "list_hazards_for_strategy returns all hazards for a strategy", %{data: data} do
        hazards = for h <- Strategies.list_hazards_for_strategy(data.strat1), do: h.name
        assert [data.haz1.name, data.haz2.name] == hazards
    end

    test "list_scales_for_strategy returns all scales for a strategy", %{data: data} do
        scales = for s <- Strategies.list_scales_for_strategy(data.strat1), do: s.name
        assert [data.scale1.name, data.scale2.name] == scales
    end

    test "get_strategy! with a good id returns the correct strategy", %{data: data} do
        assert data.strat1.name == Strategies.get_strategy!(data.strat1.id) |> Map.fetch!(:name)
    end

    test "get_strategy! with a bad id raises Ecto.NoResultsError" do
        try do
            _ = Strategies.get_strategy!(-1)
        rescue
            Ecto.NoResultsError -> assert true == true

            _ ->
                assert true == false
        end
    end

    test "get_strategy with a good id returns the correct category", %{data: data} do
        assert data.strat1.name == Strategies.get_strategy(data.strat1.id) |> Map.fetch!(:name)
    end

    test "get_strategy with a bad id returns nil" do
        assert Strategies.get_strategy(-1) == nil
    end

    @attrs %{
        name: "test",
        description: "test"
    }
    test "create_strategy with a good value creates a new strategy" do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.create_strategy(@attrs)
        end)

        assert {:ok, strategy} = Task.await(task)
        assert @attrs ==
            Repo.get!(Strategy, strategy.id)
            |> Map.take([:name, :description])
    end

    @attrs %{
        description: "test"
    }
    test "create_strategy without name returns error and changeset" do
        assert {:error, changeset} = Strategies.create_strategy(@attrs)
        assert "can't be blank" in errors_on(changeset).name
    end

    test "create_strategy with duplicate name returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.create_strategy(%{name: data.strat1.name})
        assert "has already been taken" in errors_on(changeset).name
    end

    @attrs %{
        description: "new description"
    }
    test "update_strategy with a good value returns updated strategy", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.update_strategy(data.strat1, @attrs)
        end)

        assert {:ok, strategy} = Task.await(task)
        assert @attrs ==
            Repo.get!(Strategy, strategy.id)
            |> Map.take([:description])
    end

    @attrs %{
        description: 5
    }
    test "update_strategy with a bad value returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_strategy(data.strat1, @attrs)
        assert "is invalid" in errors_on(changeset).description
    end

    test "update_strategy with a taken name returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_strategy(data.strat1, %{name: data.strat2.name})
        assert "has already been taken" in errors_on(changeset).name
    end

    test "delete_strategy with a good value removes the strategy", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.delete_strategy(data.strat2)
        end)

        assert {:ok, strategy} = Task.await(task)
        assert nil == Repo.get(Strategy, strategy.id)
    end
end