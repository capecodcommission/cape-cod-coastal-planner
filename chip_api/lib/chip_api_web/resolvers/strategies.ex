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

    def coastal_hazard(_, %{id: id}, _) do
        {:ok, Strategies.get_hazard(id)}
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

    def advantages_for_strategy(strategy, _args, _) do
        {:ok, Strategies.list_advantages_for_strategy(strategy)}
    end

    def disadvantages_for_strategy(strategy, _args, _) do
        {:ok, Strategies.list_disadvantages_for_strategy(strategy)}
    end

    def strategies_for_category(category, _args, _) do
        {:ok, Strategies.list_strategies_for_category(category)}
    end

    def strategies_for_benefit(benefit, _args, _) do
        {:ok, Strategies.list_strategies_for_benefit(benefit)}
    end

    def strategies_for_hazard(hazard, args, _) do
        {:ok, Strategies.list_strategies_for_hazard(hazard, args)}
    end

    def strategies_for_scale(scale, _args, _) do
        {:ok, Strategies.list_strategies_for_scale(scale)}
    end

    def strategies_for_placement(placement, _args, _) do
        {:ok, Strategies.list_strategies_for_placement(placement)}
    end

    @public_strategies_path "/images/strategies/"
    @valid_extensions ~w(.jpg .JPG .jpeg .png .gif)
    def strategy_image_path(strategy, _args, _) do
        priv_dir = :code.priv_dir(:chip_api)
        static_dir = Path.join priv_dir, "static"

        file_name = strategy_to_file_name(strategy)
        file_root = static_dir <> @public_strategies_path <> file_name

        case Enum.find @valid_extensions, &(image_exists?(file_root, &1)) do
            extension when is_binary(extension) -> 
                {:ok, @public_strategies_path <> file_name <> extension}

            _ ->
                {:ok, nil}
        end
    end

    @public_categories_path "/images/categories/"
    def category_active_image_path(category, _args, _) do
        priv_dir = :code.priv_dir(:chip_api)
        static_dir = Path.join priv_dir, "static"

        file_name = category_to_file_name(category, :active)
        file_root = static_dir <> @public_categories_path <> file_name

        case Enum.find @valid_extensions, &(image_exists?(file_root, &1)) do
            extension when is_binary(extension) -> 
                {:ok, @public_categories_path <> file_name <> extension}

            _ ->
                {:ok, nil}
        end
    end

    def category_inactive_image_path(category, _args, _) do
        priv_dir = :code.priv_dir(:chip_api)
        static_dir = Path.join priv_dir, "static"

        file_name = category_to_file_name(category, :inactive)
        file_root = static_dir <> @public_categories_path <> file_name

        case Enum.find @valid_extensions, &(image_exists?(file_root, &1)) do
            extension when is_binary(extension) -> 
                {:ok, @public_categories_path <> file_name <> extension}

            _ ->
                {:ok, nil}
        end
    end

    defp strategy_to_file_name(strategy) do
        strategy.name
            |> Zarex.sanitize
            |> String.downcase
            |> String.replace(" ", "_")
    end

    defp category_to_file_name(category, activeness) when is_atom(activeness) do
        category.name
            |> Zarex.sanitize
            |> String.downcase
            |> String.replace(" ", "_")
            |> (&(&1 <> "_" <> to_string activeness)).()
    end

    defp image_exists?(file_root, extension) do
        (file_root <> extension)
        |> File.exists?
    end


end