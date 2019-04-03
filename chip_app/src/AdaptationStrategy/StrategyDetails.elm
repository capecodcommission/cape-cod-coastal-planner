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
    , applicability : Maybe String
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


positiveAcreageImpact : Float -> StrategyDetails -> Float
positiveAcreageImpact length details =
    details.beachWidthImpactM
        |> Maybe.map (\width -> abs <| width * length)
        |> Maybe.map (\sqMeters -> sqMeters * acresPerSqMeter)
        |> Maybe.withDefault 0.0


negativeAcreageImpact : Float -> StrategyDetails -> Float
negativeAcreageImpact length details =
    -(positiveAcreageImpact length details)


acresPerSqMeter : Float
acresPerSqMeter = 0.000247105