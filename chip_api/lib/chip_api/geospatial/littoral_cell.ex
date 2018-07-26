defmodule ChipApi.Geospatial.LittoralCell do
    use Ecto.Schema
    import Ecto.Changeset

    schema "littoral_cells" do
        field :name, :string
        field :min_x, :float
        field :min_y, :float
        field :max_x, :float
        field :max_y, :float

        timestamps()
    end

    @doc false
    def changeset(lit_cell, attrs) do
        lit_cell
        |> cast(attrs, [:name, :min_x, :min_y, :max_x, :max_y])
        |> validate_required([:name, :min_x, :min_y, :max_x, :max_y])
        |> unique_constraint(:name)
    end
    
end