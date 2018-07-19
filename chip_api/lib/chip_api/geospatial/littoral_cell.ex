defmodule ChipApi.Geospatial.LittoralCell do
    use Ecto.Schema
    import Ecto.Changeset

    schema "littoral_cells" do
        field :name, :string
        field :minX, :float
        field :minY, :float
        field :maxX, :float
        field :maxY, :float

        timestamps()
    end

    @doc false
    def changeset(lit_cell, attrs) do
        lit_cell
        |> cast(attrs, [:name, :minX, :minY, :maxX, :maxY])
        |> validate_required([:name, :minX, :minY, :maxX, :maxY])
        |> unique_constraint(:name)
    end
    
end