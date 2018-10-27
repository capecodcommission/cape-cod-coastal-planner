module AdaptationMath exposing (..)


import AdaptationStrategy.CoastalHazards exposing (CoastalHazard)
import AdaptationStrategy.Strategies exposing (Strategy)
import AdaptationStrategy.StrategyDetails exposing (StrategyDetails)
import AdaptationStrategy.Impacts exposing (..)
import AdaptationHexes as Hexes exposing (AdaptationHexes, MonetaryValue)
import AdaptationOutput exposing (..)
import ShorelineLocation exposing (..)
import RemoteData as Remote exposing (WebData, RemoteData(..))
import Types exposing (..)


privateLandMultiplier : Float
privateLandMultiplier = 3360699


saltMarshMultiplier : Float
saltMarshMultiplier = 22.53


sqMetersPerAcre : Float
sqMetersPerAcre = 4046.86


type alias NpvConstants = 
    { discountRate : Float
    , periodicRate : Float
    , numPeriods : Int
    , natSeashore : Float
    , townBeach : Float
    , otherBeach : Float
    , unknownRate : Float -- this constant was given without description of its origin, so it's unkown!
    }


npvConstants : NpvConstants
npvConstants =  
    { discountRate = 0.7
    , periodicRate = 0.00565 -- (1 + 0.7) ^ 1/12
    , numPeriods = 480 -- 40 * 12
    , natSeashore = 70.28
    , townBeach = 238.88
    , otherBeach = 29.68
    , unknownRate = 1.07
    }


{-| Need to know the current hazard and the current strategy.

-}
calculate : 
    WebData AdaptationHexes 
    -> ShorelineExtent 
    -> ZoneOfImpact 
    -> CoastalHazard
    -> Strategy
    -> StrategyDetails
    -> AdaptationOutput
calculate hexResponse location zoneOfImpact hazard strategy details =
    case hexResponse of
        NotAsked -> 
            NotCalculated

        Loading -> 
            CalculatingOutput

        Failure err ->
            HexHttpError err

        Success hexes ->
            let
                noActionOutput = calculateNoAction hexes location zoneOfImpact hazard strategy details
            in
            case String.toLower strategy.name of
                "no action" ->
                    OnlyNoAction noActionOutput

                _ ->
                    WithStrategy noActionOutput noActionOutput

calculateNoAction : 
    AdaptationHexes 
    -> ShorelineExtent 
    -> ZoneOfImpact 
    -> CoastalHazard
    -> Strategy
    -> StrategyDetails
    -> OutputDetails
calculateNoAction hexes location zoneOfImpact hazard strategy details =
    defaultOutput
        |> applyName strategy
        |> applyScales details
        |> applyCost details
        |> applyLifespan details
        |> applyHazard hazard
        |> applyLocation location
        |> applyDuration hazard
        |> applyScenarioSize zoneOfImpact
        |> countCriticalFacilities hexes
        |> calculatePublicBuildingValue hexes
        |> calculatePrivateLandValue hexes
        |> calculatePrivateBuildingValue hexes
        |> calculateSaltMarshChangeAndValue hexes
        |> calculateBeachValue hexes zoneOfImpact
        |> calculateRareSpeciesHabitat hexes


applyName : Strategy -> OutputDetails -> OutputDetails
applyName { name } output =
    { output | name = name }


applyScales : StrategyDetails -> OutputDetails -> OutputDetails
applyScales details output =
    { output | scales = [] }


applyCost : StrategyDetails -> OutputDetails -> OutputDetails
applyCost details output =
    { output | cost = Nothing }


applyLifespan : StrategyDetails -> OutputDetails -> OutputDetails
applyLifespan details output =
    { output | lifespan = Nothing }


applyHazard : CoastalHazard -> OutputDetails -> OutputDetails
applyHazard hazard output =
    { output | hazard = hazard.name }


applyLocation : ShorelineExtent -> OutputDetails -> OutputDetails
applyLocation location output =
    { output | location = location.name }


applyDuration : CoastalHazard -> OutputDetails -> OutputDetails
applyDuration hazard output =
    { output | duration = "TBD" }


applyScenarioSize : ZoneOfImpact -> OutputDetails -> OutputDetails
applyScenarioSize zoneOfImpact output =
    { output | scenarioSize = zoneOfImpact.beachLengths.total }


countCriticalFacilities : AdaptationHexes -> OutputDetails -> OutputDetails
countCriticalFacilities hexes output =
    hexes
        |> List.foldl (\hex acc -> acc - hex.numCriticalFacilities ) 0
        |> countToCriticalFacilities
        |> \result -> { output | criticalFacilities = result }


calculatePublicBuildingValue : AdaptationHexes -> OutputDetails -> OutputDetails
calculatePublicBuildingValue hexes output =
    hexes
        |> List.foldl (\hex acc -> hex.privateBldgValue + acc ) 0
        |> monetaryValueToResult
        |> \result -> { output | privateBuildingValue = result }


calculatePrivateLandValue : AdaptationHexes -> OutputDetails -> OutputDetails
calculatePrivateLandValue hexes output =
    hexes
        |> List.foldl (\hex acc -> hex.shorelinePrivateAcres + acc ) 0
        |> (\acreage -> acreage * privateLandMultiplier * -1)
        |> monetaryValueToResult
        |> \result -> { output | privateLandValue = result }


calculatePrivateBuildingValue : AdaptationHexes -> OutputDetails -> OutputDetails
calculatePrivateBuildingValue hexes output =
    hexes
        |> List.foldl (\hex acc -> acc - hex.privateBldgValue) 0
        |> monetaryValueToResult
        |> \result -> { output | privateBuildingValue = result }


calculateSaltMarshChangeAndValue : AdaptationHexes -> OutputDetails -> OutputDetails
calculateSaltMarshChangeAndValue hexes output =
    let
        acreage = 
            hexes 
                |> List.foldl (\hex acc -> hex.saltMarshAcres + acc ) 0
                |> (*) -1

        value =
            acreage * sqMetersPerAcre * saltMarshMultiplier |> monetaryValueToResult
    in
    { output 
        | saltMarshChange = acreageToAcreageResult acreage
        , saltMarshValue = value 
    }


calculateRareSpeciesHabitat : AdaptationHexes -> OutputDetails -> OutputDetails
calculateRareSpeciesHabitat hexes output =
    hexes
        |> List.map .rareSpecies
        |> List.member True
        |> \result -> 
            if result then
                { output | rareSpeciesHabitat = HabitatLost }
            else
                { output | rareSpeciesHabitat = HabitatUnchanged }


calculateBeachValue : AdaptationHexes -> ZoneOfImpact -> OutputDetails -> OutputDetails
calculateBeachValue hexes zoneOfImpact output =
    let
        cashFlow = (annualChangeBeachValue hexes zoneOfImpact) / 12
    in
    List.range 1 npvConstants.numPeriods
        |> List.foldl (netPresentValue cashFlow) 0.0
        |> monetaryValueToResult
        |> \result -> { output | beachValue = result }


annualChangeBeachValue : AdaptationHexes -> ZoneOfImpact -> Float
annualChangeBeachValue hexes zoneOfImpact =
    let
        meanChange = 
            hexes
                |> List.foldl (\hex acc -> (Hexes.erosionImpactToFloat hex.erosion) + acc)  0.0
                |> (\result -> result / (toFloat <| List.length hexes))

        annualChangeNatSeashore =
            npvConstants.unknownRate * meanChange * npvConstants.natSeashore * (toFloat zoneOfImpact.beachLengths.nationalSeashore)

        annualChangeTownBeach =
            npvConstants.unknownRate * meanChange * npvConstants.townBeach * (toFloat zoneOfImpact.beachLengths.townBeach)

        annualChangeOtherBeach =
            npvConstants.unknownRate * meanChange * npvConstants.otherBeach * (toFloat zoneOfImpact.beachLengths.otherPublic)
    in
        annualChangeNatSeashore + annualChangeTownBeach + annualChangeOtherBeach
    

netPresentValue : Float -> Int -> Float -> Float
netPresentValue cashFlow period acc =
    cashFlow / ((1 + npvConstants.periodicRate) ^ toFloat period) + acc