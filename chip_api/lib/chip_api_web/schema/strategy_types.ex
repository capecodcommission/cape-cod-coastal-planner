defmodule ChipApiWeb.Schema.StrategyTypes do
    use Absinthe.Schema.Notation
    alias ChipApiWeb.Resolvers

    import_types ChipApi.Schema.CommonTypes

    @desc "Available queries for CHIP"
    object :strategies_queries do

        @desc "The list of adaptation strategies"
        field :adaptation_strategies, non_null(list_of(:adaptation_strategy)) do
            arg :filter, :strategy_filter
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Strategies.adaptation_strategies/3
        end

        @desc "The list of adaptation categories"
        field :adaptation_categories, non_null(list_of(:adaptation_category)) do
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Strategies.adaptation_categories/3
        end

        @desc "The list of coastal hazards"
        field :coastal_hazards, non_null(list_of(:coastal_hazard)) do
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Strategies.coastal_hazards/3
        end

        @desc "The list of geographic scales of impact"
        field :impact_scales, non_null(list_of(:impact_scale)) do
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Strategies.impact_scales/3
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
        
        @desc "The name of the strategy"
        field :name, non_null(:string)

        @desc "The description of the strategy"
        field :description, :string

        @desc "Denotes whether this strategy is currently available for planning"
        field :is_active, non_null(:boolean)

        @desc "The adaptation categories that are associated with the strategy"
        field :categories, list_of(:adaptation_category) do
            resolve &Resolvers.Strategies.categories_for_strategy/3
        end

        @desc "The coastal hazards that the strategy helps mitigate"
        field :hazards, list_of(:coastal_hazard) do
            resolve &Resolvers.Strategies.hazards_for_strategy/3
        end

        @desc "The geographic scales of impact the strategy can target"
        field :scales, list_of(:impact_scale) do
            resolve &Resolvers.Strategies.scales_for_strategy/3
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

        @desc "The impact is an integer representing the relative scale of impact. A larger number means a larger scale."
        field :impact, non_null(:integer)

        @desc "The adaptation strategies that are associated with the scale of impact."
        field :strategies, list_of(:adaptation_strategy) do
            resolve &Resolvers.Strategies.strategies_for_scale/3
        end
    end

end