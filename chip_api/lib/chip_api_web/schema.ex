defmodule ChipApiWeb.Schema do
    use Absinthe.Schema

    import_types __MODULE__.StrategyTypes
    import_types __MODULE__.LocationTypes

    #
    # QUERY
    #

    query do
        import_fields :strategies_queries

        import_fields :locations_queries
    end


    #
    # ENUMS
    #

    enum :sort_order do
        value :asc
        value :desc
    end

    #
    # CUSTOM SCALARS
    #

    @desc "A custom scalar for representing a Geographic Extent of the format [min_x, min_y, max_x, max_y]"
    scalar :geographic_extent do
        parse &parse_geographic_extent/1
        serialize &serialize_geographic_extent/1
    end

    @type extent_map :: %{min_x: float, min_y: float, max_x: float, max_y: float}

    @spec parse_geographic_extent(Absinthe.Blueprint.Input.List.t) :: {:ok, extent_map} | :error
    defp parse_geographic_extent(%Absinthe.Blueprint.Input.List{items: values}) do
        with 4 <- Enum.count(values),
            {:ok, min_x} <- values |> Enum.at(0) |> valid_lat?,
            {:ok, min_y} <- values |> Enum.at(1) |> valid_long?,
            {:ok, max_x} <- values |> Enum.at(2) |> valid_lat?,
            {:ok, max_y} <- values |> Enum.at(3) |> valid_long?
        do
            {:ok, %{
                min_x: min_x,
                min_y: min_y,
                max_x: max_x,
                max_y: max_y
            }}
        else
            _ -> :error
        end
    end
    defp parse_geographic_extent(_), do: :error

    @type extent_arr :: [float, ...]

    @spec serialize_geographic_extent({:ok, extent_arr}) :: {:ok, extent_arr}
    defp serialize_geographic_extent(value), do: value    
    

    @desc "A custom scalar for representing latitude"
    scalar :latitude do
        parse &parse_latitude/1
        serialize &serialize_latitude/1
    end

    defp parse_latitude(%Absinthe.Blueprint.Input.Float{value: latitude}) do
        if valid_lat?(latitude) do
            {:ok, latitude}
        else
            :error
        end
    end
    defp parse_latitude(_), do: :error

    defp serialize_latitude(value), do: value


    @desc "A custom scalar for representing longitude"
    scalar :longitude do
        parse &parse_longitude/1
        serialize &serialize_longitude/1
    end

    defp parse_longitude(%Absinthe.Blueprint.Input.Float{value: longitude}) do
        if valid_long?(longitude) do
            {:ok, longitude}
        else
            :error
        end
    end
    defp parse_longitude(_), do: :error

    defp serialize_longitude(value), do: value

    @spec valid_lat?(Absinthe.Blueprint.Input.Float.t) :: {:ok, float} | :error
    defp valid_lat?(%Absinthe.Blueprint.Input.Float{value: latitude}) 
        when is_float(latitude) and latitude >= -90 and latitude <= 90, do: {:ok, latitude}
    defp valid_lat?(_), do: :error

    @spec valid_long?(Absinthe.Blueprint.Input.Float.t) :: {:ok, float} | :error
    defp valid_long?(%Absinthe.Blueprint.Input.Float{value: longitude})
        when is_float(longitude) and longitude >= -180 and longitude <= 180, do: {:ok, longitude}
    defp valid_long?(_), do: :error
end