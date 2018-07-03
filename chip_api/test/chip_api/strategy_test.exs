defmodule ChipApi.StrategyTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Strategy}

    @moduletag :strategy_case

    setup do
        ChipApi.Seeds.run()
    end

    test "list_strategies returns all adaptation strategies" do
        strategies = for c <- Strategies.list_strategies(), do: c.name
        assert ["Do Nothing" | _] = strategies
    end

    test "get_strategy! with a good id returns the correct strategy" do
        a_strategy = from(c in Strategy, where: c.name == "Do Nothing") |> Repo.one!

        the_strategy = Strategies.get_strategy!(a_strategy.id)

        assert a_strategy == the_strategy
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

    test "get_strategy with a good id returns the correct category" do
        a_strategy = from(c in Strategy, where: c.name == "Do Nothing") |> Repo.one!

        the_strategy = Strategies.get_strategy(a_strategy.id)

        assert a_strategy == the_strategy
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

    @attrs %{
        name: "test"
    }
    test "create_strategy with duplicate name returns error and changeset" do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.create_strategy(@attrs)
        end)

        assert {:ok, strategy} = Task.await(task)
        assert {:error, changeset} = Strategies.create_strategy(@attrs)
        assert "has already been taken" in errors_on(changeset).name
    end

    @attrs %{
        description: "new description"
    }
    test "update_strategy with a good value returns updated strategy" do
        a_strategy = from(c in Strategy, where: c.name == "Do Nothing") |> Repo.one!

        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.update_strategy(a_strategy, @attrs)
        end)

        assert {:ok, strategy} = Task.await(task)
        assert @attrs ==
            Repo.get!(Strategy, strategy.id)
            |> Map.take([:description])
    end

    @attrs %{
        description: 5
    }
    test "update_strategy with a bad value returns error and changeset" do
        a_strategy = from(c in Strategy, where: c.name == "Do Nothing") |> Repo.one!
        
        assert {:error, changeset} = Strategies.update_strategy(a_strategy, @attrs)
        assert "is invalid" in errors_on(changeset).description
    end

    @attrs %{
        name: "Undevelopment"
    }
    test "update_strategy with a taken name returns error and changeset" do
        a_strategy = from(c in Strategy, where: c.name == "Do Nothing") |> Repo.one!

        assert {:error, changeset} = Strategies.update_strategy(a_strategy, @attrs)
        assert "has already been taken" in errors_on(changeset).name
    end

    test "delete_strategy with a good value removes the strategy" do
        a_strategy = from(c in Strategy, where: c.name == "Do Nothing") |> Repo.one!

        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.delete_strategy(a_strategy)
        end)

        assert {:ok, strategy} = Task.await(task)
        assert nil == Repo.get(Strategy, strategy.id)
    end
end