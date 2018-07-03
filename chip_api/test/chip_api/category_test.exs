defmodule ChipApi.CategoryTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Category}

    @moduletag :category_case

    setup do
        ChipApi.Seeds.run()
    end

    test "list_categories returns all adaptation categories" do
        categories = for c <- Strategies.list_categories(), do: c.name
        assert ["Protect", "Accommodate", "Retreat"] == categories
    end

    test "get_category! with a good id returns the correct category" do
        a_category = from(c in Category, where: c.name == "Protect") |> Repo.one!
        
        the_category = Strategies.get_category!(a_category.id)

        assert a_category == the_category
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

    test "get_category with a good id returns the correct category" do
        a_category = from(c in Category, where: c.name == "Protect") |> Repo.one!

        the_category = Strategies.get_category(a_category.id)

        assert a_category == the_category
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

    @attrs %{
        name: "test"
    }
    test "create_category with duplicate name returns error and changeset" do
        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.create_category(@attrs)
        end)

        assert {:ok, category} = Task.await(task)
        assert {:error, changeset} = Strategies.create_category(@attrs)
        assert "has already been taken" in errors_on(changeset).name
    end

    @attrs %{
        description: "new description"
    }
    test "update_category with a good value returns updated category" do
        a_category = from(c in Category, where: c.name == "Protect") |> Repo.one!

        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.update_category(a_category, @attrs)
        end)

        assert {:ok, category} = Task.await(task)
        assert @attrs ==
            Repo.get!(Category, category.id)
            |> Map.take([:description])
    end

    @attrs %{
        description: 5
    }
    test "update_category with a bad value returns error and changeset" do
        a_category = from(c in Category, where: c.name == "Protect") |> Repo.one!
        
        assert {:error, changeset} = Strategies.update_category(a_category, @attrs)
        assert "is invalid" in errors_on(changeset).description
    end

    @attrs %{
        name: "Accommodate"
    }
    test "update_category with a taken name returns error and changeset" do
        a_category = from(c in Category, where: c.name == "Protect") |> Repo.one!

        assert {:error, changeset} = Strategies.update_category(a_category, @attrs)
        assert "has already been taken" in errors_on(changeset).name
    end

    test "delete_category with a good value removes the category" do
        a_category = from(c in Category, where: c.name == "Protect") |> Repo.one!

        parent = self()
        task = Task.async(fn ->
            allow(parent, self())
            Strategies.delete_category(a_category)
        end)

        assert {:ok, category} = Task.await(task)
        assert nil == Repo.get(Category, category.id)
    end
end