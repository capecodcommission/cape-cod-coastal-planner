defmodule ChipApiWeb.Resolvers.Locations do
    alias ChipApi.Geospatial.ShorelineLocations

    def shoreline_locations(_, args, _) do
        {:ok, ShorelineLocations.list_littoral_cells(args)}
    end
   
end