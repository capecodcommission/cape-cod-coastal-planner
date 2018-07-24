defmodule ChipApi.Adaptation.StrategyTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Strategy}

    @moduletag :adaptation_case
    @moduletag :strategy_case

    setup do
        ChipApi.Fakes.run_all_adaptation()
    end

    test "list_strategies returns all adaptation strategies", %{data: data} do
        strategies = for s <- Strategies.list_strategies(), do: s.name
        assert [data.strat1.name, data.strat2.name] == strategies
    end

    @attrs %{order: :desc}
    test "list_strategies desc returns all adaptation strategies in descending order", %{data: data} do
        strategies = for s <- Strategies.list_strategies(@attrs), do: s.name
        assert [data.strat2.name, data.strat1.name] == strategies
    end

    @attrs %{filter: %{is_active: true}}
    test "list_strategies that are active returns only active strategies", %{data: data} do
        strategies = for s <- Strategies.list_strategies(@attrs), do: s.name
        assert [data.strat1.name] == strategies
    end

    @attrs %{filter: %{is_active: false}}
    test "list_strategies that are NOT active returns only inactive strategies", %{data: data} do
        strategies = for s <- Strategies.list_strategies(@attrs), do: s.name
        assert [data.strat2.name] == strategies
    end

    @attrs %{filter: %{name: "strat1"}}
    test "list_strategies that match name returns only matching strategies", %{data: data} do
        strategies = for s <- Strategies.list_strategies(@attrs), do: s.name
        assert [data.strat1.name] == strategies
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