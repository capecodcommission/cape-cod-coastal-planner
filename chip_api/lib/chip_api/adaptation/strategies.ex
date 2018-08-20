defmodule ChipApi.Adaptation.Strategies do
    @moduledoc """
    The Adaptation Strategies context.
    """

    import Ecto.Query, warn: false
    alias ChipApi.Repo

    #
    # ADAPTATION CATEGORIES
    #

    alias ChipApi.Adaptation.Category


    @doc """
    Returns the list of adaptation Categories. When ordering by display_order,
    nulls are returned first.

    ## Examples

        iex> list_categories(%{order: :desc})
        [%Category{}, ...]

        iex> list_categories()
        [%Category{}, ...]

    """
    def list_categories(args) do
        args
        |> Enum.reduce(Category, fn
            {:order, order}, query ->
                query |> order_by([{^order, :display_order}, {^order, :id}])
        end)
        |> Repo.all
    end
    def list_categories do
        Repo.all(Category)
    end

    @doc """
    Returns the list of adaptation strategies associated with 
    the given category.

    ## Examples

        iex> list_strategies_for_category(category)
        [%Strategy{}, ...]

    """
    def list_strategies_for_category(%Category{} = category) do
        query = Ecto.assoc(category, :adaptation_strategies)
        Repo.all(query)
    end


    @doc """
    Gets a single Category by id. 
    
    Raises `Ecto.NoResultsError` if the Category does not exist.

    ## Examples

        iex> get_category!(1)
        %Category{}

        iex> get_category!(100)
        ** (Ecto.NoResultsError)

    """
    def get_category!(id), do: Repo.get!(Category, id)

    @doc """
    Gets a single Category by id. 
    
    Returns `nil` if the Category does not exist.

    ## Examples

        iex> get_category(1)
        %Category{}

        iex> get_category(100)
        nil

    """
    def get_category(id), do: Repo.get(Category, id)

    @doc """
    Creates a Category.

    ## Examples

        iex> create_category(%{field: value})
        {:ok, %Category{}}

        iex> create_category(%{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def create_category(attrs \\ %{}) do
        %Category{}
        |> Category.changeset(attrs)
        |> Repo.insert()
    end

    @doc """
    Updates a Category.

    ## Examples

        iex> update_category(category, %{field: new_value})
        {:ok, %Category{}}

        iex> update_category(category, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """    
    def update_category(%Category{} = category, attrs) do
        category
        |> Category.changeset(attrs)
        |> Repo.update()
    end

    @doc """
    Deletes a Category.

    ## Examples

        iex> delete_category(category)
        {:ok, %Category{}}

        iex> delete_category(category)
        {:error, %Ecto.Changeset{}}

    """
    def delete_category(%Category{} = category) do
        Repo.delete(category)
    end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking category changes.

    ## Examples

        iex> change_category(category)
        %Ecto.Changeset{source: %Category{}}

    """
    def change_category(%Category{} = category) do
        Category.changeset(category, %{})
    end


    #
    # COASTAL HAZARDS
    #

    alias ChipApi.Adaptation.Hazard


    @doc """
    Returns the list of coastal Hazards. When ordering by display_order,
    nulls are returned first.

    ## Examples

        iex> list_hazards(%{order: :desc})
        [%Hazard{}, ...]

        iex> list_hazards()
        [%Hazard{}, ...]

    """
    def list_hazards(args) do
        args
        |> Enum.reduce(Hazard, fn
            {:order, order}, query ->
                query |> order_by([{^order, :display_order}, {^order, :id}])
        end)
        |> Repo.all
    end
    def list_hazards do
        Repo.all(Hazard)
    end

    @doc """
    Returns the list of adaptation strategies associated with 
    the given coastal hazard.

    ## Examples

        iex> list_strategies_for_hazard(hazard)
        [%Strategy{}, ...]

    """
    def list_strategies_for_hazard(%Hazard{} = hazard) do
        query = Ecto.assoc(hazard, :adaptation_strategies)
        Repo.all(query)
    end

    @doc """
    Gets a single Hazard by id. 
    
    Raises `Ecto.NoResultsError` if the Hazard does not exist.

    ## Examples

        iex> get_hazard!(1)
        %Hazard{}

        iex> get_hazard!(100)
        ** (Ecto.NoResultsError)

    """
    def get_hazard!(id), do: Repo.get!(Hazard, id)

    @doc """
    Gets a single Hazard by id. 
    
    Returns `nil` if the Hazard does not exist.

    ## Examples

        iex> get_hazard(1)
        %Hazard{}

        iex> get_hazard(100)
        nil

    """
    def get_hazard(id), do: Repo.get(Hazard, id)

    @doc """
    Creates a Hazard.

    ## Examples

        iex> create_hazard(%{field: value})
        {:ok, %Hazard{}}

        iex> create_hazard(%{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def create_hazard(attrs \\ %{}) do
        %Hazard{}
        |> Hazard.changeset(attrs)
        |> Repo.insert()
    end

    @doc """
    Updates a Hazard.

    ## Examples

        iex> update_hazard(hazard, %{field: new_value})
        {:ok, %Hazard{}}

        iex> update_hazard(hazard, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """    
    def update_hazard(%Hazard{} = hazard, attrs) do
        hazard
        |> Hazard.changeset(attrs)
        |> Repo.update()
    end

    @doc """
    Deletes a Hazard.

    ## Examples

        iex> delete_hazard(hazard)
        {:ok, %Hazard{}}

        iex> delete_hazard(hazard)
        {:error, %Ecto.Changeset{}}

    """
    def delete_hazard(%Hazard{} = hazard) do
        Repo.delete(hazard)
    end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking hazard changes.

    ## Examples

        iex> change_hazard(hazard)
        %Ecto.Changeset{source: %Hazard{}}

    """
    def change_hazard(%Hazard{} = hazard) do
        Hazard.changeset(hazard, %{})
    end

    #
    # IMPACT SCALES
    #

    alias ChipApi.Adaptation.Scale


    @doc """
    Returns the list of impact scales. When ordering by display_order,
    nulls are returned first.

    ## Examples

        iex> list_scales(%{order: :desc})
        [%Scale{}, ...]

        iex> list_scales()
        [%Scale{}, ...]

    """
    def list_scales(args) do
        args
        |> Enum.reduce(Scale, fn
            {:order, order}, query ->
                query |> order_by([{^order, :display_order}, {^order, :id}])
        end)
        |> Repo.all
    end
    def list_scales do
        Repo.all(Scale)
    end

    @doc """
    Returns the list of adaptation strategies associated with 
    the given impact scale.

    ## Examples

        iex> list_strategies_for_scale(scale)
        [%Strategy{}, ...]

    """
    def list_strategies_for_scale(%Scale{} = scale) do
        query = Ecto.assoc(scale, :adaptation_strategies)
        Repo.all(query)
    end

    @doc """
    Gets a single Scale by id. 
    
    Raises `Ecto.NoResultsError` if the Scale does not exist.

    ## Examples

        iex> get_scale!(1)
        %Scale{}

        iex> get_scale!(100)
        ** (Ecto.NoResultsError)

    """
    def get_scale!(id), do: Repo.get!(Scale, id)

    @doc """
    Gets a single Scale by id. 
    
    Returns `nil` if the Scale does not exist.

    ## Examples

        iex> get_scale(1)
        %Scale{}

        iex> get_scale(100)
        nil

    """
    def get_scale(id), do: Repo.get(Scale, id)

    @doc """
    Creates a Scale.

    ## Examples

        iex> create_scale(%{field: value})
        {:ok, %Scale{}}

        iex> create_scale(%{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def create_scale(attrs \\ %{}) do
        %Scale{}
        |> Scale.changeset(attrs)
        |> Repo.insert()
    end

    @doc """
    Updates a Scale.

    ## Examples

        iex> update_scale(scale, %{field: new_value})
        {:ok, %Scale{}}

        iex> update_scale(scale, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """    
    def update_scale(%Scale{} = scale, attrs) do
        scale
        |> Scale.changeset(attrs)
        |> Repo.update()
    end

    @doc """
    Deletes a Scale.

    ## Examples

        iex> delete_scale(scale)
        {:ok, %Scale{}}

        iex> delete_scale(scale)
        {:error, %Ecto.Changeset{}}

    """
    def delete_scale(%Scale{} = scale) do
        Repo.delete(scale)
    end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking Scale changes.

    ## Examples

        iex> change_scale(scale)
        %Ecto.Changeset{source: %Scale{}}

    """
    def change_scale(%Scale{} = scale) do
        Scale.changeset(scale, %{})
    end

    #
    # STRATEGY PLACEMENTS
    #

    alias ChipApi.Adaptation.Placement


    @doc """
    Returns the list of strategy Placements. 

    ## Examples
        iex> list_placements()
        [%Placement{}, ...]

    """
    def list_placements do
        Repo.all(Placement)
    end

    @doc """
    Returns the list of adaptation strategies associated with 
    the given strategy Placement.

    ## Examples

        iex> list_strategies_for_placement(placement)
        [%Strategy{}, ...]

    """
    def list_strategies_for_placement(%Placement{} = placement) do
        query = Ecto.assoc(placement, :adaptation_strategies)
        Repo.all(query)
    end

    @doc """
    Gets a single Placement by id. 
    
    Raises `Ecto.NoResultsError` if the Placement does not exist.

    ## Examples

        iex> get_placement!(1)
        %Placement{}

        iex> get_placement!(100)
        ** (Ecto.NoResultsError)

    """
    def get_placement!(id), do: Repo.get!(Placement, id)

    @doc """
    Gets a single Placement by id. 
    
    Returns `nil` if the Placement does not exist.

    ## Examples

        iex> get_placement(1)
        %Placement{}

        iex> get_placement(100)
        nil

    """
    def get_placement(id), do: Repo.get(Placement, id)

    @doc """
    Creates a Placement.

    ## Examples

        iex> create_placement(%{field: value})
        {:ok, %Placement{}}

        iex> create_placement(%{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def create_placement(attrs \\ %{}) do
        %Placement{}
        |> Placement.changeset(attrs)
        |> Repo.insert()
    end

    @doc """
    Updates a Placement.

    ## Examples

        iex> update_placement(placement, %{field: new_value})
        {:ok, %Placement{}}

        iex> update_placement(placement, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """    
    def update_placement(%Placement{} = placement, attrs) do
        placement
        |> Placement.changeset(attrs)
        |> Repo.update()
    end

    @doc """
    Deletes a Placement.

    ## Examples

        iex> delete_placement(placement)
        {:ok, %Placement{}}

        iex> delete_placement(placement)
        {:error, %Ecto.Changeset{}}

    """
    def delete_placement(%Placement{} = placement) do
        Repo.delete(placement)
    end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking placement changes.

    ## Examples

        iex> change_placement(placement)
        %Ecto.Changeset{source: %Placement{}}

    """
    def change_placement(%Placement{} = placement) do
        Placement.changeset(placement, %{})
    end

    #
    # ADAPTATION STRATEGIES
    #

    alias ChipApi.Adaptation.Strategy


    @doc """
    Returns the list of adaptation strategies. When ordering by display_order,
    nulls are returned first.

    ## Examples

        iex> list_strategies(%{order: :desc})
        [%Strategy{}, ...]

        iex> list_strategies(%{filter: %{is_active: true}})
        [%Strategy{}, ...]

        iex> list_strategies()
        [%Strategy{}, ...]

    """
    def list_strategies(args) do
        args
        |> Enum.reduce(Strategy, fn
            {:order, order}, query ->
                query |> order_by([{^order, :display_order}, {^order, :id}])
            {:filter, filter}, query ->
                query |> filter_strategies_with(filter)
        end)
        |> Repo.all
    end
    def list_strategies do
        Repo.all(Strategy)
    end

    defp filter_strategies_with(query, filter) do
        Enum.reduce(filter, query, fn
            {:name, name}, query ->
                from q in query, where: ilike(q.name, ^"%#{name}%")
            {:is_active, is_active}, query ->
                from q in query, where: q.is_active == ^is_active
        end)
    end

    @doc """
    Returns the list of categories associated with the given strategy.

    ## Examples

        iex> list_categories_for_strategy(strategy)
        [%Category{}, ...]

    """
    def list_categories_for_strategy(%Strategy{} = strategy) do
        query = Ecto.assoc(strategy, :adaptation_categories)
        Repo.all(query)
    end

    @doc """
    Returns the list of hazards associated with the given strategy.

    ## Examples

        iex> list_hazards_for_strategy(strategy)
        [%Hazard{}, ...]

    """
    def list_hazards_for_strategy(%Strategy{} = strategy) do
        query = Ecto.assoc(strategy, :coastal_hazards)
        Repo.all(query)
    end

    @doc """
    Returns the list of scales associated with the given strategy.

    ## Examples

        iex> list_scales_for_strategy(strategy)
        [%Scale{}, ...]

    """
    def list_scales_for_strategy(%Strategy{} = strategy) do
        query = Ecto.assoc(strategy, :impact_scales)
        Repo.all(query)
    end

    @doc """
    Returns the list of placements associated with the given strategy.

    ## Examples

        iex> list_placements_for_strategy(strategy)
        [%Placement{}, ...]

    """
    def list_placements_for_strategy(%Strategy{} = strategy) do
        query = Ecto.assoc(strategy, :strategy_placements)
        Repo.all(query)
    end


    @doc """
    Gets a single Strategy by id. 
    
    Raises `Ecto.NoResultsError` if the Strategy does not exist.

    ## Examples

        iex> get_strategy!(1)
        %Strategy{}

        iex> get_strategy!(100)
        ** (Ecto.NoResultsError)

    """
    def get_strategy!(id), do: Repo.get!(Strategy, id)

    @doc """
    Gets a single Strategy by id. 
    
    Returns `nil` if the Strategy does not exist.

    ## Examples

        iex> get_strategy(1)
        %Scale{}

        iex> get_strategy(100)
        nil

    """
    def get_strategy(id), do: Repo.get(Strategy, id)

    @doc """
    Creates a Strategy.

    ## Examples

        iex> create_strategy(%{field: value})
        {:ok, %Strategy{}}

        iex> create_strategy(%{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def create_strategy(attrs \\ %{}) do
        %Strategy{}
        |> Strategy.changeset(attrs)
        |> Repo.insert()
    end

    @doc """
    Updates a Strategy.

    ## Examples

        iex> update_strategy(strategy, %{field: new_value})
        {:ok, %Strategy{}}

        iex> update_strategy(strategy, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """    
    def update_strategy(%Strategy{} = strategy, attrs) do
        strategy
        |> Strategy.changeset(attrs)
        |> Repo.update()
    end

    @doc """
    Deletes a Strategy.

    ## Examples

        iex> delete_strategy(strategy)
        {:ok, %Strategy{}}

        iex> delete_strategy(strategy)
        {:error, %Ecto.Changeset{}}

    """
    def delete_strategy(%Strategy{} = strategy) do
        Repo.delete(strategy)
    end

    @doc """
    Returns an `%Ecto.Changeset{}` for tracking Strategy changes.

    ## Examples

        iex> change_strategy(strategy)
        %Ecto.Changeset{source: %Strategy{}}

    """
    def change_strategy(%Strategy{} = strategy) do
        Strategy.changeset(strategy, %{})
    end


end