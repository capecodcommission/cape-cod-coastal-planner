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


sqMetersPerAcre : Float
sqMetersPerAcre = 4046.86


metersPerFoot : Float
metersPerFoot = 0.3048


stormSurgeBldgMultiplier : Float
stormSurgeBldgMultiplier = 0.21


{-| Need to know the current hazard and the current strategy.

-}
calculate : 
    WebData AdaptationHexes 
    -> ShorelineExtent 
    -> ZoneOfImpact 
    -> CoastalHazard
    -> Strategy
    -> StrategyDetails
    -> Result OutputError AdaptationOutput
calculate hexResponse location zoneOfImpact hazard strategy details =
    case hexResponse of
        NotAsked -> 
            Ok NotCalculated

        Loading -> 
            Ok CalculatingOutput

        Failure err ->
            Err <| HexHttpError err

        Success hexes ->
            let
                basicOutput = 
                    defaultOutput
                        |> applyBasicInfo hexes location zoneOfImpact hazard strategy details

                noActionOutput = 
                    basicOutput
                        |> Result.andThen (calculateNoAction hexes zoneOfImpact hazard)
            in
            noActionOutput
                |> Result.andThen
                    (\output ->
                        case String.toLower strategy.name of
                            "no action" ->
                                Ok <| OnlyNoAction output

                            name ->
                                -- let
                                --     strategyOutput = calculateStrategy hexes location zoneOfImpact hazard strategy details
                                -- in
                                Ok <| WithStrategy output output        
                    )

            
applyBasicInfo : 
    AdaptationHexes
    -> ShorelineExtent 
    -> ZoneOfImpact 
    -> CoastalHazard 
    -> Strategy 
    -> StrategyDetails 
    -> OutputDetails 
    -> Result OutputError OutputDetails
applyBasicInfo hexes location zoneOfImpact hazard strategy details output =
    output
        |> applyName strategy
        |> Result.andThen (applyScales details)
        |> Result.andThen (applyCost details)
        |> Result.andThen (applyLifespan details)
        |> Result.andThen (applyHazard hazard)
        |> Result.andThen (applyLocation location)
        |> Result.andThen (applyDuration hazard)
        |> Result.andThen (applyScenarioSize zoneOfImpact)



calculateNoAction : 
    AdaptationHexes 
    -> ZoneOfImpact 
    -> CoastalHazard
    -> OutputDetails
    -> Result OutputError OutputDetails
calculateNoAction hexes zoneOfImpact hazard output =
    case String.toLower hazard.name of
        "erosion" ->
            output
                |> countCriticalFacilities hexes
                |> Result.andThen (calculatePublicBuildingValue Nothing hexes)
                |> Result.andThen (calculatePrivateLandValue hexes)
                |> Result.andThen (calculatePrivateBuildingValue Nothing hexes)
                |> Result.andThen (calculateSaltMarshChange hexes)
                --|> Result.andThen (calculateBeachWidthChange hexes zoneOfImpact)
                |> Result.andThen (calculateRareSpeciesHabitat hexes)

        "sea level rise" ->
            output
                |> countCriticalFacilities hexes
                |> Result.andThen (calculatePublicBuildingValue Nothing hexes)
                |> Result.andThen (calculatePrivateLandValue hexes)
                |> Result.andThen (calculatePrivateBuildingValue Nothing hexes)
                |> Result.andThen (calculateSaltMarshChange hexes)
                |> Result.andThen (calculateRareSpeciesHabitat hexes)

        "storm surge" ->
            output
                |> flagCriticalFacilitiesPresence hexes
                |> Result.andThen (calculatePublicBuildingValue (Just stormSurgeBldgMultiplier) hexes)
                |> Result.andThen (calculatePrivateBuildingValue (Just stormSurgeBldgMultiplier) hexes)

        badHazard ->
            Err <| BadInput ("Cannot calculate output for unknown or invalid coastal hazard type: " ++ badHazard)
    




{-| Apply the selected Strategy name to the output results
-}
applyName : Strategy -> OutputDetails -> Result OutputError OutputDetails
applyName { name } output =
    Ok { output | name = name }


{-| Apply the range of scales of impact to the output results
    
    Site -> Neighborhood -> Community -> Region
-}
applyScales : StrategyDetails -> OutputDetails -> Result OutputError OutputDetails
applyScales details output =
    Ok { output | scales = [] }


{-| Apply the relative cost of strategy implementation
-}
applyCost : StrategyDetails -> OutputDetails -> Result OutputError OutputDetails
applyCost details output =
    Ok { output | cost = Nothing }


{-| Apply the expected lifespan of a strategy implementation
-}
applyLifespan : StrategyDetails -> OutputDetails -> Result OutputError OutputDetails
applyLifespan details output =
    Ok { output | lifespan = Nothing }


{-| Apply the coastal hazard that the scenario addresses

    Erosion - Storm Surge - Sea Level Rise
-}
applyHazard : CoastalHazard -> OutputDetails -> Result OutputError OutputDetails
applyHazard hazard output =
    Ok { output | hazard = hazard.name }


{-| Apply the shoreline location that the plan is being assessed in
-}
applyLocation : ShorelineExtent -> OutputDetails -> Result OutputError OutputDetails
applyLocation location output =
    Ok { output | location = location.name }

{-| Apply the expected duration of a scenario

    40 years or 1-time event
-}
applyDuration : CoastalHazard -> OutputDetails -> Result OutputError OutputDetails
applyDuration hazard output =
    Ok { output | duration = "TBD" }


{-| Apply the scenario size. IE: the length of coast line selected

    Measured in feet
-}
applyScenarioSize : ZoneOfImpact -> OutputDetails -> Result OutputError OutputDetails
applyScenarioSize zoneOfImpact output =
    Ok { output | scenarioSize = zoneOfImpact.beachLengths.total }


{-| Count the number of critical facilites being impacted
-}
countCriticalFacilities : AdaptationHexes -> OutputDetails -> Result OutputError OutputDetails
countCriticalFacilities hexes output =
    hexes
        |> List.foldl (\hex acc -> acc - hex.numCriticalFacilities ) 0
        |> countToCriticalFacilities
        |> \result -> { output | criticalFacilities = result }
        |> Ok


flagCriticalFacilitiesPresence : AdaptationHexes -> OutputDetails -> Result OutputError OutputDetails
flagCriticalFacilitiesPresence hexes output =
    hexes
        |> List.any (\hex -> hex.numCriticalFacilities > 0)
        |> boolToCriticalFacilities
        |> \result -> { output | criticalFacilities = result }
        |> Ok


{-| Calculate the change in public building value
-}
calculatePublicBuildingValue : Maybe Float -> AdaptationHexes -> OutputDetails -> Result OutputError OutputDetails
calculatePublicBuildingValue maybeMultiplier hexes output =
    let
        multiplier = maybeMultiplier |> Maybe.withDefault 1.0
    in
    hexes
        |> List.foldl (\hex acc -> hex.privateBldgValue + acc ) 0
        |> (\value -> value * multiplier)
        |> monetaryValueToResult
        |> \result -> { output | privateBuildingValue = result }
        |> Ok


{-| Calculate the change in private land value
-}
calculatePrivateLandValue : AdaptationHexes -> OutputDetails -> Result OutputError OutputDetails
calculatePrivateLandValue hexes output =
    hexes
        |> List.foldl (\hex acc -> hex.shorelinePrivateAcres + acc ) 0
        |> (\acreage -> acreage * privateLandMultiplier * -1)
        |> monetaryValueToResult
        |> \result -> { output | privateLandValue = result }
        |> Ok


{-| Calculate the change in private building value
-}
calculatePrivateBuildingValue : Maybe Float -> AdaptationHexes -> OutputDetails -> Result OutputError OutputDetails
calculatePrivateBuildingValue maybeMultiplier hexes output =
    let
        multiplier = maybeMultiplier |> Maybe.withDefault 1
    in
    hexes
        |> List.foldl (\hex acc -> acc - hex.privateBldgValue) 0
        |> (\value -> value * multiplier)
        |> monetaryValueToResult
        |> \result -> { output | privateBuildingValue = result }
        |> Ok


{-| Calculate the change in both acreage and value for salt marsh area
-}
calculateSaltMarshChange : AdaptationHexes -> OutputDetails -> Result OutputError OutputDetails
calculateSaltMarshChange hexes output =
    hexes 
        |> List.foldl (\hex acc -> hex.saltMarshAcres + acc ) 0
        |> (*) -1
        |> acreageToAcreageResult
        |> \result -> { output | saltMarshChange = result }
        |> Ok


-- calculateBeachWidthChangeForErosion : AdaptationHexes -> ZoneOfImpact -> OutputDetails -> Result OutputError OutputDetails
-- calculateBeachWidthChangeForErosion hexes zoneOfImpact output =
--     hexes
--         |> List.foldl (\hex acc -> (Hexes.erosionImpactToFloat hex.erosion) + acc)  0.0
--         |> (\result -> result / (toFloat <| List.length hexes))


{-| Calculate whether there is an impact to rare species habitat
-}
calculateRareSpeciesHabitat : AdaptationHexes -> OutputDetails -> Result OutputError OutputDetails
calculateRareSpeciesHabitat hexes output =
    hexes
        |> List.map .rareSpecies
        |> List.member True
        |> (\result -> 
            if result == True then
                { output | rareSpeciesHabitat = HabitatLost }
            else
                { output | rareSpeciesHabitat = HabitatUnchanged }
            )
        |> Ok


-- {-| Calculate the net present value (NPV) for selected shoreline

--     Beach types include National Seashore, Town Beach, and Other Public Beach
-- -}
-- -- calculateBeachValue : AdaptationHexes -> ZoneOfImpact -> OutputDetails -> Result OutputError OutputDetails
-- calculateBeachValue hexes zoneOfImpact output =
--     let
--         cashFlow = annualChangeBeachValue hexes zoneOfImpact
--     in
--     List.range 1 npvConstants.numPeriods
--         |> List.foldl (netPresentValue cashFlow) 0.0
--         |> monetaryValueToResult
--         |> \result -> { output | beachValue = result }
--         |> Ok


-- annualChangeBeachValue : AdaptationHexes -> ZoneOfImpact -> Float
-- annualChangeBeachValue hexes zoneOfImpact =
--     let
--         meanChange = 
--             hexes
--                 |> List.foldl (\hex acc -> (Hexes.erosionImpactToFloat hex.erosion) + acc)  0.0
--                 |> (\result -> result / (toFloat <| List.length hexes))

--         annualChangeNatSeashore =
--             npvConstants.beachValue * meanChange * npvConstants.natSeashore * (metersPerFoot * toFloat zoneOfImpact.beachLengths.nationalSeashore)

--         annualChangeTownBeach =
--             npvConstants.beachValue * meanChange * npvConstants.townBeach * (metersPerFoot * toFloat zoneOfImpact.beachLengths.townBeach)

--         annualChangeOtherBeach =
--             npvConstants.beachValue * meanChange * npvConstants.otherBeach * (metersPerFoot * toFloat zoneOfImpact.beachLengths.otherPublic)
--     in
--         annualChangeNatSeashore + annualChangeTownBeach + annualChangeOtherBeach
    

-- netPresentValue : Float -> Int -> Float -> Float
-- netPresentValue cashFlow period acc =
--     cashFlow / ((1 + npvConstants.discountRate) ^ toFloat period) + acc