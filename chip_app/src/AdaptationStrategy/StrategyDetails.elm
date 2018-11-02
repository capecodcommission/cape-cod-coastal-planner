module AdaptationStrategy.StrategyDetails exposing (..)


import AdaptationStrategy.Impacts exposing (..)
import ChipApi.Scalar as Scalar


type alias StrategyDetails =
    { description : Maybe String
    , currentlyPermittable : Maybe String
    , beachWidthImpactM : Maybe Float
    , imagePath : Maybe String
    , categories : List Scalar.Id
    , hazards : List Scalar.Id
    , scales : List ImpactScale
    , lifeSpans : List ImpactLifeSpan
    , costs : List ImpactCost
    , benefits : Benefits
    , advantages : Advantages
    , disadvantages : Disadvantages
    }


type alias Benefit = String


type alias Benefits = List Benefit


type alias Advantage = String


type alias Advantages = List Advantage


type alias Disadvantage = String


type alias Disadvantages = List Disadvantage


hasCategory : Scalar.Id -> StrategyDetails -> Bool
hasCategory id details =
    List.member id details.categories 
        

hasHazard : Scalar.Id -> StrategyDetails -> Bool
hasHazard id details =
    List.member id details.hazards


hasBenefit : String -> StrategyDetails -> Bool
hasBenefit val details =
    List.member val details.benefits


acreageImpact : Float -> StrategyDetails -> Float
acreageImpact length details =
    details.beachWidthImpactM
        |> Maybe.map (\width -> abs <| width * length)
        |> Maybe.withDefault 0.0