defmodule ChipApiWeb.Schema.LocationTypes do
    use Absinthe.Schema.Notation
    alias ChipApiWeb.Resolvers

    @desc "Available queries for location-related types"
    object :locations_queries do
        
        @desc "The list of shoreline locations, filterable and sortable by name"
        field :shoreline_locations, non_null(list_of(non_null(:shoreline_location))) do
            arg :filter, :location_filter
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Locations.shoreline_locations/3
        end

        @desc "An individual shoreline location matched on id"
        field :shoreline_location, :shoreline_location do
            @desc "The ID of the shoreline location"
            arg :id, non_null(:id)
            resolve &Resolvers.Locations.shoreline_location/3
        end
    end

    @desc "Filtering options for shoreline locations"
    input_object :location_filter do
        
        @desc "Matching a name"
        field :name, :string

    end

    @desc "A shoreline location (littoral cell)"
    object :shoreline_location do

        @desc "The ID of the shoreline location"
        field :id, non_null(:id)
        
        @desc "The name of the shoreline location"
        field :name, non_null(:string)

        @desc "The geographic extent of the location"
        field :extent, non_null(:geographic_extent) do
            resolve &Resolvers.Locations.geographic_extent/3
        end

        @desc "The westernmost longitude of the location's extent"
        field :min_x , non_null(:float)

        @desc "The southernmost latitude of the location's extent"
        field :min_y, non_null(:float)

        @desc "The easternmost longitude of the location's extent"
        field :max_x, non_null(:float)

        @desc "The northernmost latitude of the location's extent"
        field :max_y, non_null(:float)

        @desc "The length in miles of the shoreline"
        field :length_miles, non_null(:decimal)

        @desc "The percentage of impervious surface area"
        field :imperv_percent, non_null(:decimal)

        @desc "The number of critical facilities in the area"
        field :critical_facilities_count, non_null(:integer)

        @desc "The number of coastal structures in the area"
        field :coastal_structures_count, non_null(:integer)

        @desc "Whether or not the location has a working harbor"
        field :working_harbor, non_null(:boolean)

        @desc "The number of public buildings in the area"
        field :public_buildings_count, non_null(:integer)

        @desc "The total acreage of salt marsh in the area"
        field :salt_marsh_acres, non_null(:decimal)

        @desc "The total acreage of eelgrass in the area"
        field :eelgrass_acres, non_null(:decimal)

        @desc "The total acreage of coastal dunes in the area"
        field :coastal_dune_acres, non_null(:decimal)

        @desc "The total acreage of rare species habitat in the area"
        field :rare_species_acres, non_null(:decimal)

        @desc "The number of public beaches in the area"
        field :public_beach_count, non_null(:integer)

        @desc "The total acreage of recreational open space in the area"
        field :recreation_open_space_acres, non_null(:decimal)

        @desc "The number of town ways to water in the area"
        field :town_ways_to_water, non_null(:integer)

        @desc "Whether or not the location is a national seashore"
        field :national_seashore, non_null(:boolean)

        @desc "The total assessed value of property in the area"
        field :total_assessed_value, non_null(:decimal)

        @desc "The server path to an image of the shoreline location"
        field :image_path, :string do
            resolve &Resolvers.Locations.image_path/3
        end

    end

end