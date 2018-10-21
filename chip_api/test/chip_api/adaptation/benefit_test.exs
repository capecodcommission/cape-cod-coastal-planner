defmodule ChipApi.Adaptation.BenefitTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Benefit}

    @moduletag :adaptation_case
    @moduletag :benefit_case

    setup do
        ChipApi.Fakes.run_benefits()
    end

    test "list_benefits returns all adaptation benefits", %{data: data} do
        benefits = for c <- Strategies.list_benefits(), do: c.name
        assert [data.benefit1.name, data.benefit2.name] == benefits
    end

    @attrs %{order: :desc}
    test "list_benefits desc returns all adaptation benefits in descending order", %{data: data} do
        benefits = for c <- Strategies.list_benefits(@attrs), do: c.name
        assert [data.benefit2.name, data.benefit1.name] == benefits
    end

    test "list_strategies_for_benefit returns all strategies for a benefit", %{data: data} do
        strategies = for s <- Strategies.list_strategies_for_benefit(data.benefit1), do: s.name
        assert [data.strat1.name, data.strat2.name] == strategies
    end

    test "get_benefit! with a good id returns the correct benefit", %{data: data} do
        assert data.benefit1 == Strategies.get_benefit!(data.benefit1.id)
    end

    test "get_benefit! with a bad id raises Ecto.NoResultsError" do
        try do
            _ = Strategies.get_benefit!(-1)
        rescue
            Ecto.NoResultsError -> assert true == true

            _ ->
                assert true == false
        end
    end

    test "get_benefit with a good id returns the correct benefit", %{data: data} do
        assert data.benefit1 == Strategies.get_benefit(data.benefit1.id)
    end

    test "get_benefit with a bad id returns nil" do
        assert Strategies.get_benefit(-1) == nil
    end

    @attrs %{
        name: "test",
        display_order: 0
    }
    test "create_benefit with a good value creates a new benefit" do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.create_benefit(@attrs)
        end)

        assert {:ok, benefit} = Task.await(task)
        assert @attrs ==
            Repo.get!(Benefit, benefit.id)
            |> Map.take([:name, :display_order])
    end

    @attrs %{
        display_order: 0
    }
    test "create_benefit without name returns error and changeset" do
        assert {:error, changeset} = Strategies.create_benefit(@attrs)
        assert "can't be blank" in errors_on(changeset).name
    end

    test "create_benefit with duplicate name returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.create_benefit(%{name: data.benefit1.name})
        assert "has already been taken" in errors_on(changeset).name
    end

    @attrs %{
        display_order: 3
    }
    test "update_benefit with a good value returns updated benefit", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.update_benefit(data.benefit1, @attrs)
        end)

        assert {:ok, benefit} = Task.await(task)
        assert @attrs ==
            Repo.get!(Benefit, benefit.id)
            |> Map.take([:display_order])
    end

    @attrs %{
        display_order: "bad_value"
    }
    test "update_benefit with a bad value returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_benefit(data.benefit1, @attrs)        
        assert "is invalid" in errors_on(changeset).display_order
    end

    test "update_benefit with a taken name returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_benefit(data.benefit1, %{name: data.benefit2.name})
        assert "has already been taken" in errors_on(changeset).name
    end

    test "delete_benefit with a good value removes the benefit", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.delete_benefit(data.benefit2)
        end)

        assert {:ok, benefit} = Task.await(task)
        assert nil == Repo.get(Benefit, benefit.id)
    end

end