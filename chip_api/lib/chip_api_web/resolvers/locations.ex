defmodule ChipApiWeb.Resolvers.Locations do
    alias ChipApi.Geospatial.ShorelineLocations
    alias Cachex

    # An example of fetching cached shoreline locations with a fallback to
    # fetching from the database.
    def shoreline_location(_, %{id: id}, _) do
        Cachex.fetch(:littoral_cell_cache, String.to_integer(id), fn(id) ->
            case ShorelineLocations.get_littoral_cell(id) do
                location -> {:commit, location}
                nil -> {:ignore, nil}
            end
        end)
        |> case do
            {:error, err} ->
                {:ok, nil}
            {:ignore, _} ->
                {:ok, nil}
            {success, value} when success in [:ok, :commit] -> 
                {:ok, value}
        end
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
    
    @public_path "/images/locations/"
    @valid_extensions ~w(.jpg .JPG .jpeg .png .gif)
    def image_path(shoreline_location, _args, _) do
        priv_dir = :code.priv_dir(:chip_api)
        static_dir = Path.join priv_dir, "static"

        file_name = location_to_file_name(shoreline_location)
        file_root = static_dir <> @public_path <> file_name

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
    
    defp image_exists?(file_root, extension) do
        (file_root <> extension)
        |> File.exists?
    end

end