defmodule ChipApiWeb.Resolvers.Strategies do
    alias ChipApi.Adaptation.Strategies

    def adaptation_strategies(_, args, _) do
        {:ok, Strategies.list_strategies(args)}
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


end