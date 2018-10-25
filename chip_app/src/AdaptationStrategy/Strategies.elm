module AdaptationStrategy.Strategies exposing (..)


import List.Zipper as Zipper exposing (Zipper)
import Dict exposing (Dict)
import ChipApi.Scalar as Scalar
import Types exposing (GqlData, getId)
import AdaptationStrategy.StrategyDetails exposing (..)


type alias Strategies =
    Dict String Strategy


type alias Strategy =
    { id : Scalar.Id
    , name : String
    , placement : Maybe Placement
    , details : GqlData (Maybe StrategyDetails)
    }


type alias Placement = String


fromList : List Strategy -> Strategies
fromList list =
    list
        |> List.map (\s -> (getId s.id, s))
        |> Dict.fromList


get : Scalar.Id -> Strategies -> Maybe Strategy
get (Scalar.Id id) strategies =
    Dict.get id strategies


updateStrategyDetails : Scalar.Id -> GqlData (Maybe StrategyDetails) -> Strategies -> Strategies
updateStrategyDetails (Scalar.Id id) data strategies = 
    strategies
        |> Dict.get id
        |> Maybe.map (\s -> { s | details = data })
        |> Maybe.map (\s -> Dict.insert id s strategies)
        |> Maybe.withDefault strategies