defmodule ChipApiWeb.Resolvers.Strategies do
    alias ChipApi.Adaptation.Strategies

    def adaptation_strategies(_, args, _) do
        {:ok, Strategies.list_strategies()}
    end


    def adaptation_categories(_, args, _) do
        {:ok, Strategies.list_categories()}
    end

    
    def coastal_hazards(_, args, _) do
        {:ok, Strategies.list_hazards()}
    end


    def impact_scales(_, args, _) do
        {:ok, Strategies.list_scales()}
    end

    def categories_for_strategy(strategy, args, _) do
        query = Ecto.assoc(strategy, :adaptation_categories)
        {:ok, ChipApi.Repo.all(query)}
    end

    def hazards_for_strategy(strategy, args, _) do
        query = Ecto.assoc(strategy, :coastal_hazards)
        {:ok, ChipApi.Repo.all(query)}
    end

    def scales_for_strategy(strategy, args, _) do
        query = Ecto.assoc(strategy, :impact_scales)
        {:ok, ChipApi.Repo.all(query)}
    end

    def strategies_for_category(category, args, _) do
        query = Ecto.assoc(category, :adaptation_strategies)
        {:ok, ChipApi.Repo.all(query)}
    end

    def strategies_for_hazard(hazard, args, _) do
        query = Ecto.assoc(hazard, :adaptation_strategies)
        {:ok, ChipApi.Repo.all(query)}
    end

    def strategies_for_scale(scale, args, _) do
        query = Ecto.assoc(scale, :adaptation_strategies)
        {:ok, ChipApi.Repo.all(query)}
    end

end