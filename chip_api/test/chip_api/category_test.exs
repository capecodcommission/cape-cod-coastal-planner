defmodule ChipApi.CategoryTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Category, Strategy}

    @moduletag :category_case

    setup do
        cat1 = %Category{name: "cat1"}
        |> Repo.insert!

        cat2 = %Category{name: "cat2"}
        |> Repo.insert!

        strat1 = %Strategy{
            name: "strat1", 
            description: "desc1",
            adaptation_categories: [cat1, cat2],
            coastal_hazards: [],
            impact_scales: []
        }
        |> Repo.insert!

        strat2 = %Strategy{
            name: "strat2", 
            description: "desc2",
            adaptation_categories: [cat1, cat2],
            coastal_hazards: [],
            impact_scales: []
        }
        |> Repo.insert!

        {:ok, data: %{
            cat1: cat1,
            cat2: cat2,
            strat1: strat1,
            strat2: strat2
        }}
    end

    test "list_categories returns all adaptation categories", %{data: data} do
        categories = for c <- Strategies.list_categories(), do: c.name
        assert [data.cat1.name, data.cat2.name] == categories
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