defmodule ChipApiWeb.Resolvers.Locations do
    alias ChipApi.Geospatial.ShorelineLocations

    def shoreline_location(_, args, _) do
        {:ok, ShorelineLocations.get_littoral_cell(args)}
    end

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

    
    @root_dir "/priv/static/"
    @public_path "images/locations/"
    @valid_extensions ~w(.jpg .JPG .jpeg .png .gif)
    def image_path(shoreline_location, _args, _) do
        file_name = location_to_file_name(shoreline_location)
        file_root = @root_dir <> @public_path <> file_name
        
        case Enum.find @valid_extensions, &(image_exists?(file_root, &1)) do
            extension when is_binary(extension) -> 
                {:ok, @public_path <> file_name <> extension}

            _ ->
                {:ok, nil}
        end
    end

    defp location_to_file_name(shoreline_location) do
        shoreline_location.name
            |> Zarex.sanitize
            |> String.downcase
            |> String.replace(" ", "_")
    end
    
    def image_exists?(file_root, extension) do
        (file_root <> extension)
        |> Path.relative()
        |> File.exists?
    end

end