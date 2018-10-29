module AdaptationStrategy.StrategyDetails exposing (..)


import ChipApi.Scalar as Scalar


type alias StrategyDetails =
    { description : Maybe String
    , currentlyPermittable : Maybe String
    , imagePath : Maybe String
    , categories : List Scalar.Id
    , hazards : List Scalar.Id
    , scales : List Scalar.Id
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


hasScale : Scalar.Id -> StrategyDetails -> Bool
hasScale id details =
    List.member id details.scales


hasBenefit : String -> StrategyDetails -> Bool
hasBenefit val details =
    List.member val details.benefits