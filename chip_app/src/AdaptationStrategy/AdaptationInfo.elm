module AdaptationStrategy.AdaptationInfo exposing (..)


import Maybe.Extra as MEx
import RemoteData as Remote
import AdaptationStrategy.StrategyDetails as Details exposing (..)
import AdaptationStrategy.Categories as Categories exposing (..)
import AdaptationStrategy.CoastalHazards as Hazards exposing (..)
import AdaptationStrategy.Strategies as Strategies exposing (..)
import Types exposing (GqlData)



type alias AdaptationInfo =
    { benefits : Benefits
    , categories : Categories
    , hazards : CoastalHazards
    , strategies : Strategies
    }


currentHazard : GqlData AdaptationInfo -> Maybe CoastalHazard
currentHazard data =
    data
        |> Remote.toMaybe
        |> Maybe.andThen .hazards
        |> Hazards.current


currentStrategy : GqlData AdaptationInfo -> Maybe Strategy
currentStrategy data =
    let
        strategies = data |> Remote.toMaybe |> Maybe.map .strategies
    in
    data
        |> Remote.toMaybe
        |> Maybe.andThen .hazards
        |> Hazards.currentStrategyId
        |> Maybe.map2 (\s i -> Strategies.get i s) strategies
        |> MEx.join


