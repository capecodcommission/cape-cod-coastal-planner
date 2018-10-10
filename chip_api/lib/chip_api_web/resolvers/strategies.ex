defmodule ChipApiWeb.Resolvers.Strategies do
    alias ChipApi.Adaptation.Strategies
    alias Cachex

    def adaptation_strategies(_, args, _) do
        {:ok, Strategies.list_strategies(args)}
    end

    def adaptation_strategy(_, %{id: id}, _) do
        Cachex.fetch(:adaptation_strategy_cache, String.to_integer(id), fn(id) ->
            case Strategies.get_strategy(id) do
                strategy -> {:commit, strategy}
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

    def adaptation_categories(_, args, _) do
        {:ok, Strategies.list_categories(args)}
    end

    def adaptation_benefits(_, args, _) do
        {:ok, Strategies.list_benefits(args)}
    end
    
    def coastal_hazards(_, args, _) do
        {:ok, Strategies.list_hazards(args)}
    end

    def impact_scales(_, args, _) do
        {:ok, Strategies.list_scales(args)}
    end

    def strategy_placements(_, args, _) do
        {:ok, Strategies.list_placements()}
    end

    def categories_for_strategy(strategy, _args, _) do
        {:ok, Strategies.list_categories_for_strategy(strategy)}
    end

    def benefits_for_strategy(strategy, _args, _) do
        {:ok, Strategies.list_benefits_for_strategy(strategy)}
    end

    def hazards_for_strategy(strategy, _args, _) do
        {:ok, Strategies.list_hazards_for_strategy(strategy)}
    end

    def scales_for_strategy(strategy, _args, _) do
        {:ok, Strategies.list_scales_for_strategy(strategy)}
    end

    def placements_for_strategy(strategy, _args, _) do
        {:ok, Strategies.list_placements_for_strategy(strategy)}
    end

    # TODO Advantages
    def advantages_for_strategy(strategy, _args, _) do
        {:ok, Strategies.list_advantages_for_strategy(strategy)}
    end

    # TODO Disadvantages
    def disadvantages_for_strategy(strategy, _args, _) do
        {:ok, Strategies.list_disadvantages_for_strategy(strategy)}
    end

    def strategies_for_category(category, _args, _) do
        {:ok, Strategies.list_strategies_for_category(category)}
    end

    def strategies_for_benefit(benefit, _args, _) do
        {:ok, Strategies.list_strategies_for_benefit(benefit)}
    end

    def strategies_for_hazard(hazard, _args, _) do
        {:ok, Strategies.list_strategies_for_hazard(hazard)}
    end

    def strategies_for_scale(scale, _args, _) do
        {:ok, Strategies.list_strategies_for_scale(scale)}
    end

    def strategies_for_placement(placement, _args, _) do
        {:ok, Strategies.list_strategies_for_placement(placement)}
    end

    # TODO Throws error: Invalid schema notation: `field` must only be used within `input_object`, `interface`, `object`
    @public_path "/images/strategies/"
    @valid_extensions ~w(.jpg .JPG .jpeg .png .gif)
    def image_path(strategy, _args, _) do
        priv_dir = :code.priv_dir(:chip_api)
        static_dir = Path.join priv_dir, "static"

        file_name = location_to_file_name(strategy)
        file_root = static_dir <> @public_path <> file_name

        case Enum.find @valid_extensions, &(image_exists?(file_root, &1)) do
            extension when is_binary(extension) -> 
                {:ok, @public_path <> file_name <> extension}

            _ ->
                {:ok, nil}
        end
    end

    defp location_to_file_name(strategy) do
        strategy.name
            |> Zarex.sanitize
            |> String.downcase
            |> String.replace(" ", "_")
    end
    
    defp image_exists?(file_root, extension) do
        (file_root <> extension)
        |> File.exists?
    end


end