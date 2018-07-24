defmodule ChipApiWeb.Resolvers.Locations do
    alias ChipApi.Geospatial.ShorelineLocations

    def shoreline_locations(_, args, _) do
        shoreline_locations = 
            args
            |> ShorelineLocations.list_littoral_cells
            |> Enum.map(&(transform_extent(&1)))
        {:ok, shoreline_locations}
    end

    defp transform_extent(shoreline_location) do
        shoreline_location
        |> Map.from_struct()
        |> Map.take([:name])
        |> Map.put(:extent, [
            shoreline_location.minX,
            shoreline_location.minY,
            shoreline_location.maxX,
            shoreline_location.maxY
        ])
    end

end