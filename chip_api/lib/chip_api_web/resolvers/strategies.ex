defmodule ChipApiWeb.Resolvers.Strategies do
    alias ChipApi.Adaptation.Strategies

    def adaptation_strategies(_, args, _) do
        {:ok, Strategies.list_strategies(args)}
    end

    def adaptation_categories(_, args, _) do
        {:ok, Strategies.list_categories(args)}
    end
    
    def coastal_hazards(_, args, _) do
        {:ok, Strategies.list_hazards(args)}
    end

    def impact_scales(_, args, _) do
        {:ok, Strategies.list_scales(args)}
    end

    def categories_for_strategy(strategy, _args, _) do
        {:ok, Strategies.list_categories_for_strategy(strategy)}
    end

    def hazards_for_strategy(strategy, _args, _) do
        {:ok, Strategies.list_hazards_for_strategy(strategy)}
    end

    def scales_for_strategy(strategy, _args, _) do
        {:ok, Strategies.list_scales_for_strategy(strategy)}
    end

    def strategies_for_category(category, _args, _) do
        {:ok, Strategies.list_strategies_for_category(category)}
    end

    def strategies_for_hazard(hazard, _args, _) do
        {:ok, Strategies.list_strategies_for_hazard(hazard)}
    end

    def strategies_for_scale(scale, _args, _) do
        {:ok, Strategies.list_strategies_for_scale(scale)}
    end

end