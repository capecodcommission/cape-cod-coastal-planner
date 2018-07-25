defmodule ChipApiWeb.Schema do
    use Absinthe.Schema

    #import_types __MODULE__.CommonTypes
    import_types __MODULE__.StrategyTypes
    import_types __MODULE__.LocationTypes

    query do
        import_fields :strategies_queries

        import_fields :locations_queries
    end

    enum :sort_order do
        value :asc
        value :desc
    end

    @desc "A custom scalar for representing a Geographic Extent of the format [minX, minY, maxX, maxY]"
    scalar :geographic_extent do
        parse &parse_geographic_extent/1
        serialize &serialize_geographic_extent/1
    end

    @type extent_map :: %{minX: float, minY: float, maxX: float, maxY: float}

    @spec parse_geographic_extent(Absinthe.Blueprint.Input.List.t) :: {:ok, extent_map} | :error
    defp parse_geographic_extent(%Absinthe.Blueprint.Input.List{items: values}) do
        with 4 <- Enum.count(values),
            {:ok, minX} <- values |> Enum.at(0) |> valid_lat?,
            {:ok, minY} <- values |> Enum.at(1) |> valid_long?,
            {:ok, maxX} <- values |> Enum.at(2) |> valid_lat?,
            {:ok, maxY} <- values |> Enum.at(3) |> valid_long?
        do
            {:ok, %{
                minX: minX,
                minY: minY,
                maxX: maxX,
                maxY: maxY
            }}
        else
            _ -> :error
        end
    end
    defp parse_geographic_extent(_), do: :error

    @type extent_arr :: [float, ...]

    @spec serialize_geographic_extent({:ok, extent_arr}) :: {:ok, extent_arr}
    defp serialize_geographic_extent(value), do: value    
    

    @spec valid_lat?(Absinthe.Blueprint.Input.Float.t) :: {:ok, float} | :error
    defp valid_lat?(%Absinthe.Blueprint.Input.Float{value: latitude}) 
        when is_float(latitude) and latitude >= -90 and latitude <= 90, do: {:ok, latitude}
    defp valid_lat?(_), do: :error

    @spec valid_long?(Absinthe.Blueprint.Input.Float.t) :: {:ok, float} | :error
    defp valid_long?(%Absinthe.Blueprint.Input.Float{value: longitude})
        when is_float(longitude) and longitude >= -180 and longitude <= 180, do: {:ok, longitude}
    defp valid_long?(_), do: :error
end