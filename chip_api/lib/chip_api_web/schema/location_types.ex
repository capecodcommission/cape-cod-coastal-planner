defmodule ChipApiWeb.Schema.LocationTypes do
    use Absinthe.Schema.Notation
    alias ChipApiWeb.Resolvers

    import_types ChipApi.Schema.CommonTypes

    @desc "Available queries for location-related types"
    object :locations_queries do
        
        @desc "The list of shoreline locations"
        field :shoreline_locations, non_null(list_of(:shoreline_location)) do
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
        field :extent, non_null(:geographic_extent)

    end

    
end