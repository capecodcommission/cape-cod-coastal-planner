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

    end

end