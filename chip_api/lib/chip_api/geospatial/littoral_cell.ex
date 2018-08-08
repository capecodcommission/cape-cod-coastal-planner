defmodule ChipApi.Geospatial.LittoralCell do
    use Ecto.Schema
    import Ecto.Changeset
    alias Decimal, as: D

    schema "littoral_cells" do
        field :name, :string
        # these should probably be converted to decimal types as well
        field :min_x, :float
        field :min_y, :float
        field :max_x, :float
        field :max_y, :float
        # general info
        field :length_miles, :decimal, default: D.new("0.0")
        field :imperv_percent, :decimal, default: D.new("0.0")
        # public infrastructure
        field :critical_facilities_count, :integer, default: 0
        field :coastal_structures_count, :integer, default: 0
        field :working_harbor, :boolean, default: false
        field :public_buildings_count, :integer, default: 0
        # habitat
        field :salt_marsh_acres, :decimal, default: D.new("0.0")
        field :eelgrass_acres, :decimal, default: D.new("0.0")
        # recreation
        field :public_beach_count, :integer, default: 0
        field :recreation_open_space_acres, :decimal, default: D.new("0.0")
        field :town_ways_to_water, :integer, default: 0
        # private infrastructure
        field :total_assessed_value, :decimal, default: D.new("0.0")

        timestamps()
    end

    
    @fields [:name, :min_x, :min_y, :max_x, :max_y, :length_miles, 
        :imperv_percent, :critical_facilities_count, :coastal_structures_count,
        :working_harbor, :public_buildings_count, :salt_marsh_acres, :eelgrass_acres,
        :public_beach_count, :recreation_open_space_acres, :town_ways_to_water, 
        :total_assessed_value
    ]
    @required [:name, :min_x, :min_y, :max_x, :max_y]
    #
    # Consider breaking this changeset up into separate changeset functions for creating vs editing
    #
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
        |> validate_number(:critical_facilities_count, greater_than_or_equal_to: 0)
        |> validate_number(:coastal_structures_count, greater_than_or_equal_to: 0)
        |> validate_number(:public_buildings_count, greater_than_or_equal_to: 0)
        |> validate_change(:salt_marsh_acres, fn :salt_marsh_acres, salt_marsh_acres ->
            case D.cmp(salt_marsh_acres, "0.0") do
                :lt -> [salt_marsh_acres: "cannot be less than 0.0"]
                _ -> []
            end
        end)
        |> validate_change(:eelgrass_acres, fn :eelgrass_acres, eelgrass_acres ->
            case D.cmp(eelgrass_acres, "0.0") do
                :lt -> [eelgrass_acres: "cannot be less than 0.0"]
                _ -> []
            end
        end)
        |> validate_number(:public_beach_count, greater_than_or_equal_to: 0)
        |> validate_change(:recreation_open_space_acres, fn :recreation_open_space_acres, recreation_open_space_acres ->
            case D.cmp(recreation_open_space_acres, "0.0") do
                :lt -> [recreation_open_space_acres: "cannot be less than 0.0"]
                _ -> []
            end
        end)
        |> validate_number(:town_ways_to_water, greater_than_or_equal_to: 0)
        |> validate_change(:total_assessed_value, fn :total_assessed_value, total_assessed_value ->
            case D.cmp(total_assessed_value, "0.0") do
                :lt -> [total_assessed_value: "cannot be less than 0.0"]
                _ -> []
            end
        end)
        |> unique_constraint(:name)
    end
end