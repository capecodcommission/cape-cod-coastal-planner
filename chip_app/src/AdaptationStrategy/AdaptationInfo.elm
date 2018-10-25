module AdaptationStrategy.AdaptationInfo exposing (..)


import Maybe.Extra as MEx
import RemoteData as Remote
import AdaptationStrategy.StrategyDetails as Details exposing (..)
import AdaptationStrategy.Categories as Categories exposing (..)
import AdaptationStrategy.CoastalHazards as Hazards exposing (..)
import AdaptationStrategy.Strategies as Strategies exposing (..)
import Types exposing (GqlData, ZoneOfImpact)



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


-- applicableStrategies : ZoneOfImpact -> GqlData AdaptationInfo -> Maybe ApplicableStrategies
-- applicableStrategies zoneOfImpact data =
--     let
--         strategies = data |> Remote.toMaybe |> Maybe.map .strategies
--     in
--     data
--         |> Remote.toMaybe
--         |> Maybe.andThen .hazards
--         |> Maybe.map .strategyIds
--         |> Maybe.map 


-- toApplicableStrategy : ZoneOfImpact -> Strategies -> Scalar.Id -> Maybe ApplicableStrategy
-- toApplicableStrategy zoneOfImpact strategies (Scalar.Id id) =
--     strategies
--         |> Dict.get id
--         |> Maybe.map 
--             (\strategy ->
--                 strategy
--                     |> isStrategyApplicable zoneOfImpact
--                     |> ApplicableStrategy strategy.id strategy.name
--             )


-- isStrategyApplicable : ZoneOfImpact -> Strategy -> Bool
-- isStrategyApplicable { placementMajorities } { placement } =
--     case placement of
--         Just "anywhere" ->
--             True

--         Just "undeveloped_only" ->
--             placementMajorities.majorityUndeveloped

--         Just "coastal_bank_only" ->
--             placementMajorities.majorityCoastalBank

--         Just "anywhere_but_salt_marsh" ->
--             not placementMajorities.majoritySaltMarsh

--         Just _ ->
--             False

--         Nothing ->
--             True