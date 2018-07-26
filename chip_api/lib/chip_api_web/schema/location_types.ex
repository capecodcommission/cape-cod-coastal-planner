defmodule ChipApiWeb.Schema.LocationTypes do
    use Absinthe.Schema.Notation
    alias ChipApiWeb.Resolvers

    @desc "Available queries for location-related types"
    object :locations_queries do
        
        @desc "The list of shoreline locations"
        field :shoreline_locations, non_null(list_of(non_null(:shoreline_location))) do
            arg :filter, :location_filter
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Locations.shoreline_locations/3
        end

    end

    @desc "Filtering options for shoreline locations"
    input_object :location_filter do
        
        @desc "Matching a name"
        field :name, :string

    end

    @desc "A shoreline location (littoral cell)"
    object :shoreline_location do
        
        @desc "The name of the shoreline location"
        field :name, non_null(:string)

        @desc "The geographic extent of the location"
        field :extent, non_null(:geographic_extent) do
            resolve &Resolvers.Locations.geographic_extent/3
        end

        @desc "The westernmost latitude of the location's extent"
        field :min_x , non_null(:float)

        @desc "The southernmost longitude of the location's extent"
        field :min_y, non_null(:float)

        @desc "The easternmost latitude of the location's extent"
        field :max_x, non_null(:float)

        @desc "The northernmost longitude of the location's extent"
        field :max_y, non_null(:float)

    end

end