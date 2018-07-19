defmodule ChipApi.Geospatial.ShorelineLocations do
    @moduledoc """
    The Planning Areas context.
    """

    import Ecto.Query, warn: false
    alias ChipApi.Repo

    #
    # SHORELINE LOCATIONS (Littoral Cells)
    #

    alias ChipApi.Geospatial.LittoralCell

    @doc """
    Returns the list of littoral cells

    ## Examples

        iex> list_areas(%{order: :desc})
        [%LittoralCell{}, ...]

        iex> list_areas()
        [%LittoralCell{}, ...]

    """
    def list_littoral_cells(args) do
        args
        |> Enum.reduce(LittoralCell, fn
            {:order, order}, query ->
                query |> order_by([{^order, :name}, {^order, :id}])
        end)
        |> Repo.all
    end
    def list_littoral_cells do
        Repo.all(LittoralCell)
    end


    @doc """
    Gets a single littoral cell by id.

    Raises `Ecto.NoResultsError` if the LittoralCell does not exist.

    ## Examples

        iex> get_littoral_cell!(1)
        %LittoralCell{}

        iex> get_littoral_cell!(-1)
        ** (Ecto.NoResultsError)

    """
    def get_littoral_cell!(id), do: Repo.get!(LittoralCell, id)

    @doc """
    Gets a single littoral cell by id.

    Returns `nil` if the LittoralCell does not exist.

    ## Examples

        iex> get_littoral_cells(1)
        {:ok, %LittoralCell{}}

        iex> get_littoral_cells(-1)
        nil

    """
    def get_littoral_cell(id), do: Repo.get(LittoralCell, id)

    @doc """
    Creates a littoral cell.

    ## Examples

        iex> create_littoral_cell(%{field: value})
        {:ok, %LittoralCell{}}

        iex> create_littoral_cell(%{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def create_littoral_cell(attrs \\ %{}) do
        %LittoralCell{}
        |> LittoralCell.changeset(attrs)
        |> Repo.insert()
    end

    @doc """
    Updates a littoral cell.

    ## Examples

        iex> update_littoral_cell(littoral_cell, %{field: new_value})
        {:ok, %LittoralCell{}}

        iex> update_littoral_cell(littoral_cell, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

    """
    def update_littoral_cell(%LittoralCell{} = lit_cell, attrs) do
        lit_cell
        |> LittoralCell.changeset(attrs)
        |> Repo.update()
    end

    @doc """
    Deletes a littoral cell.

    ## Examples

        iex> delete_littoral_cell(littoral_cell)
        %{:ok, %LittoralCell{}}

        iex> delete_littoral_cell(littoral_cell)
        {:error, %Ecto.Changeset{}}

    """
    def delete_littoral_cell(%LittoralCell{} = lit_cell) do
        Repo.delete(lit_cell)
    end

    @doc """
    Returns an `%Ecto.Changeset{}` for trackign littoral cell changes.

    ## Examples

        iex> change_littoral_cell(littoral_cell)
        %Ecto.Changeset{source: %LittoralCell{}}
        
    """
    def change_littoral_cell(%LittoralCell{} = lit_cell) do
        LittoralCell.changeset(lit_cell, %{})
    end

end