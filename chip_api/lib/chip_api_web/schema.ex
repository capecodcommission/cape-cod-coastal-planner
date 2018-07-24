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
        
        parse fn input ->
            with %Absinthe.Blueprint.Input.List{items: values} <- input,
                4 <- Enum.count(values),
                {:ok, minX} <- values |> Enum.at(0) |> valid_lat?,
                {:ok, minY} <- values |> Enum.at(1) |> valid_long?,
                {:ok, maxX} <- values |> Enum.at(2) |> valid_lat?,
                {:ok, maxY} <- values |> Enum.at(3) |> valid_long?
            do
                {:ok, [minX, minY, maxX, maxY]}
            else
                _ -> :error
            end
        end

        serialize fn extent ->
            extent
        end

    end

    defp valid_lat?(%Absinthe.Blueprint.Input.Float{value: latitude}) 
        when is_float(latitude) and latitude >= -90 and latitude <= 90, do: {:ok, latitude}
    defp valid_lat?(_), do: :error

    defp valid_long?(%Absinthe.Blueprint.Input.Float{value: longitude})
        when is_float(longitude) and longitude >= -180 and longitude <= 180, do: {:ok, longitude}
    defp valid_long?(_), do: :error
end