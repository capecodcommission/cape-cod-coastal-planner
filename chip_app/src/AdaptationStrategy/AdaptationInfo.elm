module AdaptationStrategy.AdaptationInfo exposing (..)


import Dict
import List.Zipper as Zipper exposing (Zipper)
import Maybe.Extra as MEx
import RemoteData as Remote
import AdaptationStrategy.StrategyDetails as Details exposing (..)
import AdaptationStrategy.Categories as Categories exposing (..)
import AdaptationStrategy.CoastalHazards as Hazards exposing (..)
import AdaptationStrategy.Strategies as Strategies exposing (..)
import ZipperHelpers as ZipHelp
import Types exposing (GqlData, ZoneOfImpact, getId)
import ChipApi.Scalar as Scalar



type alias AdaptationInfo =
    { benefits : Benefits
    , categories : Categories
    , hazards : CoastalHazards
    , strategies : Strategies
    }


currentHazard : Maybe AdaptationInfo -> Maybe CoastalHazard
currentHazard info =
    info
        |> Maybe.andThen .hazards
        |> Hazards.current


currentStrategy : Maybe AdaptationInfo -> Maybe Strategy
currentStrategy info =
    let
        strategies = info |> Maybe.map .strategies
    in
    info
        |> Maybe.andThen .hazards
        |> Hazards.currentStrategyId
        |> Maybe.map2 (\s i -> Strategies.get i s) strategies
        |> MEx.join


currentStrategyWithDetails : Maybe AdaptationInfo -> Maybe Strategy
currentStrategyWithDetails info =
    let
        strategy = currentStrategy info

        details = 
            strategy
                |> Maybe.map .details
                |> Maybe.andThen Remote.toMaybe
                |> MEx.join
    in
    case MEx.isJust details of
        True -> strategy
        False -> Nothing


currentStrategyDetails : Maybe AdaptationInfo -> Maybe (GqlData (Maybe StrategyDetails))
currentStrategyDetails info =
    info
        |> currentStrategy
        |> Maybe.map .details


getStrategies : GqlData AdaptationInfo -> Maybe Strategies
getStrategies data =
    data |> Remote.toMaybe |> Maybe.map .strategies


getStrategyById : Scalar.Id -> GqlData AdaptationInfo -> Maybe Strategy
getStrategyById id data =
    data
        |> getStrategies
        |> Maybe.andThen (Strategies.get id)


availableStrategies : GqlData AdaptationInfo -> Maybe (Zipper (Maybe Strategy))
availableStrategies data =
    let
        strategies = getStrategies data
    in
    data
        |> Remote.toMaybe
        |> Maybe.andThen .hazards
        |> Hazards.currentStrategyIds
        |> ZipHelp.tryMap 
            (\(Scalar.Id id) ->
                strategies 
                    |> Maybe.map (Dict.get id)
                    |> MEx.join
            )


isStrategyApplicableToZoneOfImpact : Maybe ZoneOfImpact -> GqlData AdaptationInfo -> Scalar.Id -> Bool
isStrategyApplicableToZoneOfImpact zoneOfImpact data id =
    data
        |> getStrategyById id
        |> Maybe.map2 Strategies.isApplicableToZoneOfImpact zoneOfImpact
        |> Maybe.withDefault False


getSelectedStrategyHtmlId : AdaptationInfo -> Maybe String
getSelectedStrategyHtmlId info =
    info.hazards
        |> Hazards.currentStrategyId
        |> Maybe.map (\(Scalar.Id id) -> "strategy-" ++ id)