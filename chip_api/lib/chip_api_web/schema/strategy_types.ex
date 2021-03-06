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

        @desc "Details for an individual adaptation strategy matched on id"
        field :adaptation_strategy, :adaptation_strategy do
            @desc "The ID of the adaptation strategy"
            arg :id, non_null(:id)
            resolve &Resolvers.Strategies.adaptation_strategy/3
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

        @desc "A coastal hazard matched on id"
        field :coastal_hazard, :coastal_hazard do
            @desc "The ID of the coastal hazard"
            arg :id, non_null(:id)
            resolve &Resolvers.Strategies.coastal_hazard/3
        end

        @desc "The list of geographic scales of impact"
        field :impact_scales, non_null(list_of(non_null(:impact_scale))) do
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Strategies.impact_scales/3
        end

        @desc "The list of cost range categories"
        field :impact_costs, non_null(list_of(non_null(:impact_cost))) do
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Strategies.impact_costs/3
        end

        @desc "The list of life span categories"
        field :impact_life_spans, non_null(list_of(non_null(:impact_life_span))) do
            arg :order, type: :sort_order, default_value: :asc
            resolve &Resolvers.Strategies.impact_life_spans/3
        end

    end

    @desc "Filtering options for adaptation strategies"
    input_object :strategy_filter do

        @desc "Matching a name"
        field :name, :string

        @desc "Is currently available for planning or not"
        field :is_active, :boolean

        @desc "Is applicable to the given coastal hazard"
        field :hazard_id, :id
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
        
        @desc "Description of valid placement the strategy can be used in"
        field :strategy_placement, :string

        @desc "The impact in meters on beach width this strategy generally has"
        field :beach_width_impact_m, :float

        @desc "Applicability description"
        field :applicability, :string

        @desc "The adaptation categories that are associated with the strategy"
        field :categories, non_null(list_of(non_null(:adaptation_category))) do
            resolve &Resolvers.Strategies.categories_for_strategy/3
        end

        @desc "The adaptation benefits that are associated with the strategy"
        field :benefits, non_null(list_of(non_null(:adaptation_benefit))) do
            resolve &Resolvers.Strategies.benefits_for_strategy/3
        end

        @desc "The coastal hazards that the strategy helps mitigate"
        field :hazards, non_null(list_of(non_null(:coastal_hazard))) do
            resolve &Resolvers.Strategies.hazards_for_strategy/3
        end

        @desc "The advantages that are associated with the strategy"
        field :advantages, non_null(list_of(non_null(:adaptation_advantages))) do
            resolve &Resolvers.Strategies.advantages_for_strategy/3
        end

        @desc "The disadvantages that are associated with the strategy"
        field :disadvantages, non_null(list_of(non_null(:adaptation_disadvantages))) do
            resolve &Resolvers.Strategies.disadvantages_for_strategy/3
        end

        @desc "The geographic scales of impact the strategy can target"
        field :scales, non_null(list_of(non_null(:impact_scale))) do
            resolve &Resolvers.Strategies.scales_for_strategy/3
        end

        @desc "The ordinal cost category as it pertains to cost per length of the strategy"
        field :costs, non_null(list_of(non_null(:impact_cost))) do
            resolve &Resolvers.Strategies.costs_for_strategy/3
        end

        @desc "The ordinal life span category of the strategy"
        field :life_spans, non_null(list_of(non_null(:impact_life_span))) do
            resolve &Resolvers.Strategies.life_spans_for_strategy/3
        end

        @desc "The server path to an image of the adaptation strategy"
        field :image_path, :string do
            resolve &Resolvers.Strategies.strategy_image_path/3
        end
    end


    @desc "An adaptation category"
    object :adaptation_category do

        @desc "The ID of the category"
        field :id, non_null(:id)
        
        @desc "The name of the category"
        field :name, non_null(:string)

        @desc "The description of the category"
        field :description, :string

        @desc "The server path to an image of the adaptation category when it is applicable"
        field :image_path_active, :string do
            resolve &Resolvers.Strategies.category_active_image_path/3
        end

        @desc "The server path to an image of the adapation category when it is inapplicable"
        field :image_path_inactive, :string do
            resolve &Resolvers.Strategies.category_inactive_image_path/3
        end

        @desc "The adaptation strategies that are associated with the category"
        field :strategies, non_null(list_of(non_null(:adaptation_strategy))) do
            resolve &Resolvers.Strategies.strategies_for_category/3
        end
    end

    @desc "An adaptation benefit"
    object :adaptation_benefit do

        @desc "The ID of the benefit"
        field :id, non_null(:id)
        
        @desc "The name of the benefit"
        field :name, non_null(:string)

        @desc "The adaptation strategies that are associated with the benefit"
        field :strategies, non_null(list_of(non_null(:adaptation_strategy))) do
            resolve &Resolvers.Strategies.strategies_for_benefit/3
        end
    end

    @desc "An adaptation advantage"
    object :adaptation_advantages do
        
        @desc "The name of the advantage"
        field :name, non_null(:string)

    end

    @desc "An adaptation disadvantage"
    object :adaptation_disadvantages do
        
        @desc "The name of the disadvantage"
        field :name, non_null(:string)

    end

    @desc "A coastal hazard"
    object :coastal_hazard do

        @desc "The ID of the hazard"
        field :id, non_null(:id)
        
        @desc "The name of the hazard"
        field :name, non_null(:string)

        @desc "The description of the hazard"
        field :description, :string

        @desc "The duration of the hazard"
        field :duration, non_null(:string)

        @desc "The adaptation strategies that are associated with the hazard"
        field :strategies, non_null(list_of(non_null(:adaptation_strategy))) do
            @desc "Is currently available for planning or not"
            arg :is_active, :boolean
            resolve &Resolvers.Strategies.strategies_for_hazard/3
        end
    end

    @desc "A geographic scale of impact"
    object :impact_scale do

        @desc "The ID of the scale of impact"
        field :id, non_null(:id)

        @desc "The name of the scale of impact"        
        field :name, non_null(:string)

        @desc "The description of the scale of impact"
        field :description, :string

        @desc "The impact is an integer representing the relative scale of impact. A larger number means a larger scale"
        field :impact, non_null(:integer)

        @desc "The adaptation strategies that are associated with the scale of impact"
        field :strategies, non_null(list_of(non_null(:adaptation_strategy))) do
            resolve &Resolvers.Strategies.strategies_for_scale/3
        end
    end

    @desc "An ordinal cost category as it pertains to cost per length"
    object :impact_cost do

        @desc "The name of the cost category described qualitatively"        
        field :name, non_null(:string)

        @desc "The name of the cost category described quantitatively"
        field :name_linear_foot, :string

        @desc "The description of the cost category"
        field :description, :string

        @desc "The cost is an integer representing the relative scale of cost category. A larger number means a larger cost"
        field :cost, non_null(:integer)

        @desc "The adaptation strategies that are associated with the cost category"
        field :strategies, non_null(list_of(non_null(:adaptation_strategy))) do
            resolve &Resolvers.Strategies.strategies_for_cost_range/3
        end
    end

    @desc "An ordinal life span category"
    object :impact_life_span do

        @desc "The name of the life span category described qualitatively"        
        field :name, non_null(:string)

        @desc "The description of the life span category"
        field :description, :string

        @desc "The life span is an integer representing the relative scale of life span category. A larger number means a longer life span"
        field :life_span, non_null(:integer)

        @desc "The adaptation strategies that are associated with the life span category"
        field :strategies, non_null(list_of(non_null(:adaptation_strategy))) do
            resolve &Resolvers.Strategies.strategies_for_life_span_range/3
        end
    end
end