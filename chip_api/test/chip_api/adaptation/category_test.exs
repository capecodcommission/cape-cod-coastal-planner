defmodule ChipApi.Adaptation.CategoryTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Category}

    @moduletag :adaptation_case
    @moduletag :category_case

    setup do
        ChipApi.Fakes.run_categories()
    end

    test "list_categories returns all adaptation categories", %{data: data} do
        categories = for c <- Strategies.list_categories(), do: c.name
        assert [data.cat1.name, data.cat2.name] == categories
    end

    @attrs %{order: :desc}
    test "list_categories desc returns all adaptation categories in descending order", %{data: data} do
        categories = for c <- Strategies.list_categories(@attrs), do: c.name
        assert [data.cat2.name, data.cat1.name] == categories
    end

    test "list_strategies_for_category returns all strategies for a category", %{data: data} do
        strategies = for s <- Strategies.list_strategies_for_category(data.cat1), do: s.name
        assert [data.strat1.name, data.strat2.name] == strategies
    end

    test "get_category! with a good id returns the correct category", %{data: data} do
        assert data.cat1 == Strategies.get_category!(data.cat1.id)
    end

    test "get_category! with a bad id raises Ecto.NoResultsError" do
        try do
            _ = Strategies.get_category!(-1)
        rescue
            Ecto.NoResultsError -> assert true == true

            _ ->
                assert true == false
        end
    end

    test "get_category with a good id returns the correct category", %{data: data} do
        assert data.cat1 == Strategies.get_category(data.cat1.id)
    end

    test "get_category with a bad id returns nil" do
        assert Strategies.get_category(-1) == nil
    end

    @attrs %{
        name: "test",
        description: "test"
    }
    test "create_category with a good value creates a new category" do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.create_category(@attrs)
        end)

        assert {:ok, category} = Task.await(task)
        assert @attrs ==
            Repo.get!(Category, category.id)
            |> Map.take([:name, :description])
    end

    @attrs %{
        description: "test"
    }
    test "create_category without name returns error and changeset" do
        assert {:error, changeset} = Strategies.create_category(@attrs)
        assert "can't be blank" in errors_on(changeset).name
    end

    test "create_category with duplicate name returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.create_category(%{name: data.cat1.name})
        assert "has already been taken" in errors_on(changeset).name
    end

    @attrs %{
        description: "new description"
    }
    test "update_category with a good value returns updated category", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.update_category(data.cat1, @attrs)
        end)

        assert {:ok, category} = Task.await(task)
        assert @attrs ==
            Repo.get!(Category, category.id)
            |> Map.take([:description])
    end

    @attrs %{
        description: 5
    }
    test "update_category with a bad value returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_category(data.cat1, @attrs)
        assert "is invalid" in errors_on(changeset).description
    end

    test "update_category with a taken name returns error and changeset", %{data: data} do
        assert {:error, changeset} = Strategies.update_category(data.cat1, %{name: data.cat2.name})
        assert "has already been taken" in errors_on(changeset).name
    end

    test "delete_category with a good value removes the category", %{data: data} do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.delete_category(data.cat2)
        end)

        assert {:ok, category} = Task.await(task)
        assert nil == Repo.get(Category, category.id)
    end
end