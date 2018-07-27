defmodule ChipApi.Geospatial.LittoralCell do
    use Ecto.Schema
    import Ecto.Changeset
    alias Decimal, as: D

    schema "littoral_cells" do
        field :name, :string
        field :min_x, :float
        field :min_y, :float
        field :max_x, :float
        field :max_y, :float
        field :length_miles, :decimal, default: D.new("0.0")
        field :imperv_percent, :decimal, default: D.new("0.0")

        timestamps()
    end

    
    @fields [:name, :min_x, :min_y, :max_x, :max_y, :length_miles, :imperv_percent]
    @required [:name, :min_x, :min_y, :max_x, :max_y]
    def changeset(lit_cell, attrs) do
        lit_cell
        |> cast(attrs, @fields)
        |> validate_required(@required)
        |> validate_number(:min_x, greater_than_or_equal_to: -180.0)
        |> validate_number(:min_x, less_than_or_equal_to: 180.0)
        |> validate_number(:min_y, greater_than_or_equal_to: -90.0)
        |> validate_number(:min_y, less_than_or_equal_to: 90.0)
        |> validate_number(:max_x, greater_than_or_equal_to: -180.0)
        |> validate_number(:max_x, less_than_or_equal_to: 180.0)
        |> validate_number(:max_y, greater_than_or_equal_to: -90.0)
        |> validate_number(:max_y, less_than_or_equal_to: 90.0)
        |> validate_change(:length_miles, fn :length_miles, length_miles ->
            case D.cmp(length_miles, "0.0") do
                :lt -> [length_miles: "cannot be less than 0.0"]
                _ -> []
            end
        end)
        |> validate_change(:imperv_percent, fn :imperv_percent, imperv_percent ->
            case {D.cmp(imperv_percent, "0.0"), D.cmp(imperv_percent, "100.0")} do
                {:gt, :gt} -> [imperv_percent: "cannot be greater than 100.0"]
                {:lt, _} -> [imperv_percent: "cannot be less than 0.0"]
                {_, _} -> []
            end
        end)
        |> unique_constraint(:name)
    end
end