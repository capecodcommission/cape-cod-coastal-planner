module AdaptationStrategy.StrategyDetails exposing (..)


import Set exposing (Set)
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


type alias Benefits = Set Benefit


type alias Advantage = String


type alias Advantages = Set Advantage


type alias Disadvantage = String


type alias Disadvantages = Set Disadvantage


hasCategory : Scalar.Id -> StrategyDetails -> Bool
hasCategory id details =
    List.member id details.categories 
        

hasHazard : Scalar.Id -> StrategyDetails -> Bool
hasHazard id details =
    List.member id details.hazards


hasScale : Scalar.Id -> StrategyDetails -> Bool
hasScale id details =
    List.member id details.scales