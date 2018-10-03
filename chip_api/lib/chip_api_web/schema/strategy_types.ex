defmodule ChipApiWeb.Schema.StrategyTypes do
    use Absinthe.Schema.Notation
    alias ChipApiWeb.Resolvers

    @desc "Available queries for strategy-related types"
    object :strategies_queries do

        @desc "The list of adaptation strategies"
        field :adaptation_strategies, non_null(list_of(non_null(:adaptation_strategy))) do
            arg :filter, :strategy_filter
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Strategies.adaptation_strategies/3
        end

        @desc "The list of adaptation categories"
        field :adaptation_categories, non_null(list_of(non_null(:adaptation_category))) do
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Strategies.adaptation_categories/3
        end

        @desc "The list of adaptation benefits"
        field :adaptation_benefits, non_null(list_of(non_null(:adaptation_benefit))) do
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Strategies.adaptation_benefits/3
        end

        @desc "The list of coastal hazards"
        field :coastal_hazards, non_null(list_of(non_null(:coastal_hazard))) do
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Strategies.coastal_hazards/3
        end

        @desc "The list of geographic scales of impact"
        field :impact_scales, non_null(list_of(non_null(:impact_scale))) do
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Strategies.impact_scales/3
        end

        @desc "The list of valid placements for strategies"
        field :placements, non_null(list_of(non_null(:strategy_placement))) do
            resolve &Resolvers.Strategies.strategy_placements/3
        end
    end

    @desc "Filtering options for adaptation strategies"
    input_object :strategy_filter do

        @desc "Matching a name"
        field :name, :string

        @desc "Is currently available for planning or not"
        field :is_active, :boolean
    end

    @desc "An adaptation strategy"
    object :adaptation_strategy do

        @desc "The ID of the strategy"
        field :id, non_null(:id)
        
        @desc "The name of the strategy"
        field :name, non_null(:string)

        @desc "The description of the strategy"
        field :description, :string

        @desc "The currently permittable status of the strategy"
        field :currently_permittable, :string

        @desc "Denotes whether this strategy is currently available for planning"
        field :is_active, non_null(:boolean)

        @desc "The adaptation categories that are associated with the strategy"
        field :categories, list_of(:adaptation_category) do
            resolve &Resolvers.Strategies.categories_for_strategy/3
        end

        @desc "The adaptation benefits that are associated with the strategy"
        field :benefits, list_of(:adaptation_benefit) do
            resolve &Resolvers.Strategies.benefits_for_strategy/3
        end

        @desc "The coastal hazards that the strategy helps mitigate"
        field :hazards, list_of(:coastal_hazard) do
            resolve &Resolvers.Strategies.hazards_for_strategy/3
        end

        # TODO This API response will crash the app.  I think I am missing something RE the 1:M association
        @desc "The advantages that are associated with the strategy"
        field :advantages, list_of(:adaptation_advantages) do
            resolve &Resolvers.Strategies.advantages_for_strategy/3
        end

        # TODO This API response will crash the app.  I think I am missing something RE the 1:M association
        @desc "The disadvantages that are associated with the strategy"
        field :disadvantages, list_of(:adaptation_disadvantages) do
            resolve &Resolvers.Strategies.disadvantages_for_strategy/3
        end

        @desc "The geographic scales of impact the strategy can target"
        field :scales, list_of(:impact_scale) do
            resolve &Resolvers.Strategies.scales_for_strategy/3
        end

        @desc "The list of valid placements the strategies can be used in"
        field :placements, list_of(:strategy_placement) do
            resolve &Resolvers.Strategies.placements_for_strategy/3
        end

        @desc "The server path to an image of the adaptation strategy"
        field :image_path, :string do
            resolve &Resolvers.Strategies.image_path/3
        end
    end


    @desc "An adaptation category"
    object :adaptation_category do
        
        @desc "The name of the category"
        field :name, non_null(:string)

        @desc "The description of the category"
        field :description, :string

        @desc "The adaptation strategies that are associated with the category"
        field :strategies, list_of(:adaptation_strategy) do
            resolve &Resolvers.Strategies.strategies_for_category/3
        end
    end

    @desc "An adaptation benefit"
    object :adaptation_benefit do
        
        @desc "The name of the benefit"
        field :name, non_null(:string)

        @desc "The adaptation strategies that are associated with the benefit"
        field :strategies, list_of(:adaptation_strategy) do
            resolve &Resolvers.Strategies.strategies_for_benefit/3
        end
    end

    # TODO Advantage
    @desc "An adaptation advantage"
    object :adaptation_advantages do
        
        @desc "The name of the advantage"
        field :name, non_null(:string)

    end

    # TODO Disadvantage
    @desc "An adaptation disadvantage"
    object :adaptation_disadvantages do
        
        @desc "The name of the disadvantage"
        field :name, non_null(:string)

    end

    @desc "A coastal hazard"
    object :coastal_hazard do
        
        @desc "The name of the hazard"
        field :name, non_null(:string)

        @desc "The description of the hazard"
        field :description, :string

        @desc "The adaptation strategies that are associated with the hazard"
        field :strategies, list_of(:adaptation_strategy) do
            resolve &Resolvers.Strategies.strategies_for_hazard/3
        end
    end

    @desc "A geographic scale of impact"
    object :impact_scale do

        @desc "The name of the scale of impact"        
        field :name, non_null(:string)

        @desc "The description of the scale of impact"
        field :description, :string

        @desc "The impact is an integer representing the relative scale of impact. A larger number means a larger scale"
        field :impact, non_null(:integer)

        @desc "The adaptation strategies that are associated with the scale of impact"
        field :strategies, list_of(:adaptation_strategy) do
            resolve &Resolvers.Strategies.strategies_for_scale/3
        end
    end

    @desc "A land characteristic used to determine where a strategy is allowed to be placed"
    object :strategy_placement do
        
        @desc "The name of the placement"
        field :name, non_null(:string)

        @desc "The adaptation strategies that are associated with the placement"
        field :strategies, list_of(:adaptation_strategy) do
            resolve &Resolvers.Strategies.strategies_for_placement/3
        end
    end
end