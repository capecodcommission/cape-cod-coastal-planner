defmodule ChipApiWeb.Resolvers.Locations do
    alias ChipApi.Geospatial.ShorelineLocations

    def shoreline_locations(_, args, _) do
        {:ok, ShorelineLocations.list_littoral_cells(args)}
    end

    def geographic_extent(shoreline_location, _args, _) do
        {:ok, [
            shoreline_location.min_x,
            shoreline_location.min_y,
            shoreline_location.max_x,
            shoreline_location.max_y
        ]}
    end

end