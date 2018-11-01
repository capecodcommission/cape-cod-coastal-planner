module AdaptationMath exposing (..)


import AdaptationStrategy.CoastalHazards exposing (CoastalHazard)
import AdaptationStrategy.Strategies exposing (Strategy)
import AdaptationStrategy.StrategyDetails exposing (StrategyDetails)
import AdaptationStrategy.Impacts exposing (..)
import AdaptationHexes as Hexes exposing (..)
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
    -> ( Strategy, StrategyDetails )
    -> ( Strategy, StrategyDetails )
    -> Result OutputError AdaptationOutput
calculate 
    hexResponse 
    location 
    zoneOfImpact 
    hazard 
    noActionInfo 
    ((strategy, details) as strategyInfo) =
    case hexResponse of
        NotAsked -> 
            Ok NotCalculated

        Loading -> 
            Ok CalculatingOutput

        Failure err ->
            Err <| HexHttpError err

        Success hexes ->
            let
                noActionOutput : Result OutputError OutputDetails
                noActionOutput = 
                    defaultOutput
                        |> applyBasicInfo hexes location zoneOfImpact hazard noActionInfo
                        |> Result.andThen (calculateNoActionOutput hexes zoneOfImpact hazard)
            in
            case String.toLower strategy.name of
                "no action" ->
                    noActionOutput
                        |> Result.map OnlyNoAction

                name ->
                    noActionOutput
                        |> Result.andThen (calculateStrategyOutput hexes zoneOfImpact hazard strategyInfo defaultOutput)
                        |> Result.andThen (applyBasicInfo hexes location zoneOfImpact hazard strategyInfo)
                        |> Result.map2 WithStrategy noActionOutput

            
applyBasicInfo : 
    AdaptationHexes
    -> ShorelineExtent 
    -> ZoneOfImpact 
    -> CoastalHazard 
    -> ( Strategy, StrategyDetails )
    -> OutputDetails 
    -> Result OutputError OutputDetails
applyBasicInfo hexes location zoneOfImpact hazard ( strategy, details ) output =
    output
        |> applyName strategy
        |> Result.andThen (applyScales details)
        |> Result.andThen (applyCost details)
        |> Result.andThen (applyLifespan details)
        |> Result.andThen (applyHazard hazard)
        |> Result.andThen (applyLocation location)
        |> Result.andThen (applyDuration hazard)
        |> Result.andThen (applyScenarioSize zoneOfImpact)


calculateNoActionOutput : 
    AdaptationHexes 
    -> ZoneOfImpact 
    -> CoastalHazard
    -> OutputDetails
    -> Result OutputError OutputDetails
calculateNoActionOutput hexes zoneOfImpact hazard output =
    case String.toLower hazard.name of
        "erosion" ->
            let
                avgErosion = averageErosion hexes
            in
            case avgErosion of
                Eroding width ->
                    output
                        |> (countCriticalFacilities >> loseCriticalFacilities) hexes
                        |> Result.andThen ((sumPublicBldgValue >> losePublicBldgValue) hexes)
                        |> Result.andThen 
                            ( (sumPrivateLandAcreage 
                                >> applyMultiplier privateLandMultiplier
                                >> losePrivateLandValue)
                              hexes
                            )
                        |> Result.andThen ((sumPrivateBldgValue >> losePrivateBldgValue) hexes)
                        |> Result.andThen ((sumSaltMarshAcreage >> loseSaltMarshAcreage) hexes)
                        |> Result.andThen ((isRareSpeciesHabitatPresent >> loseRareSpeciesHabitat) hexes)
                        |> Result.andThen (loseBeachArea zoneOfImpact width)

                Accreting width ->
                    output
                        |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) hexes
                        |> Result.andThen ((isRareSpeciesHabitatPresent >> gainRareSpeciesHabitat) hexes)
                        |> Result.andThen (gainBeachArea zoneOfImpact width)


                NoErosion -> 
                    output
                        |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) hexes

        "sea level rise" ->
            let
                avgSeaLevelRise = averageSeaLevelRise hexes
            in
            case avgSeaLevelRise of
                VulnSeaRise width ->
                    output
                        |> (countCriticalFacilities >> loseCriticalFacilities) hexes
                        |> Result.andThen ((sumPublicBldgValue >> losePublicBldgValue) hexes)
                        |> Result.andThen
                            ( (sumPrivateLandAcreage 
                                >> applyMultiplier privateLandMultiplier
                                >> losePrivateLandValue)
                            hexes
                            )
                        |> Result.andThen ((sumPrivateBldgValue >> losePrivateBldgValue) hexes)
                        |> Result.andThen ((sumSaltMarshAcreage >> loseSaltMarshAcreage) hexes)
                        |> Result.andThen ((isRareSpeciesHabitatPresent >> loseRareSpeciesHabitat) hexes)
                        |> Result.andThen (loseBeachArea zoneOfImpact width)

                NoSeaRise ->
                    output
                        |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) hexes

        "storm surge" ->
            let
                vulnerableToSurge = isVulnerableToStormSurge hexes
            in
            case vulnerableToSurge of
                True ->
                    output
                        |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) hexes
                        |> Result.andThen 
                            ( (sumPublicBldgValue
                                >> applyMultiplier stormSurgeBldgMultiplier
                                >> losePublicBldgValue)
                            hexes
                            )
                        |> Result.andThen
                            ( (sumPrivateBldgValue
                                >> applyMultiplier stormSurgeBldgMultiplier
                                >> losePrivateBldgValue)
                            hexes
                            )

                False ->
                    output
                        |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) hexes

        badHazard ->
            Err <| BadInput ("Cannot calculate output for unknown or invalid coastal hazard type: '" ++ badHazard ++ "'")
    


calculateStrategyOutput : 
    AdaptationHexes 
    -> ZoneOfImpact 
    -> CoastalHazard
    -> (Strategy, StrategyDetails)
    -> OutputDetails
    -> OutputDetails
    -> Result OutputError OutputDetails
calculateStrategyOutput hexes zoneOfImpact hazard (strategy, details) output noActionOutput =
    case String.toLower strategy.name of
        "revetment" ->
            output
                |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput

        badStrategy ->
            Err <| BadInput ("Cannot calculate output for unknown or invalid strategy type: '" ++ badStrategy ++ "'")




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


applyMultiplier : Float -> Float -> Float
applyMultiplier multiplier value =
    multiplier * value


{-| Count the number of critical facilites being impacted as lost
-}
loseCriticalFacilities : Count -> OutputDetails -> Result OutputError OutputDetails
loseCriticalFacilities facilities output =
    if facilities == 0 then
        Ok output
    else 
        abs facilities
            |> FacilitiesLost
            |> \result -> Ok { output | criticalFacilities = result }


{-| Protect critical facilities from No Action output 
-}
protectCriticalFacilities : Count -> OutputDetails -> Result OutputError OutputDetails
protectCriticalFacilities facilities output =
    if facilities == 0 then
        Ok output
    else
        abs facilities
            |> FacilitiesProtected
            |> \result -> Ok { output | criticalFacilities = result }


flagCriticalFacilitiesAsPresent : Count -> OutputDetails -> Result OutputError OutputDetails
flagCriticalFacilitiesAsPresent facilities output =
    if facilities == 0 then
        Ok output
    else
        abs facilities
            |> FacilitiesPresent
            |> \result -> Ok { output | criticalFacilities = result }


losePublicBldgValue : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
losePublicBldgValue value output =
    if value == 0 then
        Ok { output | publicBuildingValue = ValueUnchanged }
    else
        Ok { output | publicBuildingValue = ValueLoss <| abs value }

losePrivateLandValue : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
losePrivateLandValue value output =
    if value == 0 then
        Ok { output | privateLandValue = ValueUnchanged }
    else
        Ok { output | privateLandValue = ValueLoss <| abs value }


losePrivateBldgValue : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
losePrivateBldgValue value output =
    if value == 0 then
        Ok { output | privateBuildingValue = ValueUnchanged }
    else
        Ok { output | privateBuildingValue = ValueLoss <| abs value }


loseSaltMarshAcreage : Acreage -> OutputDetails -> Result OutputError OutputDetails
loseSaltMarshAcreage acreage output =
    if acreage == 0 then
        Ok { output | saltMarshChange = AcreageUnchanged }
    else
        Ok { output | saltMarshChange = AcreageLost <| abs acreage}


loseBeachArea : ZoneOfImpact -> ImpactWidth -> OutputDetails -> Result OutputError OutputDetails
loseBeachArea { beachLengths } avgWidth output =
    case toFloat beachLengths.total * avgWidth of
        0 ->
            Ok { output | beachAreaChange = AcreageUnchanged }
        acreage ->
            Ok { output | beachAreaChange = AcreageLost <| abs acreage }


gainBeachArea : ZoneOfImpact -> ImpactWidth -> OutputDetails -> Result OutputError OutputDetails
gainBeachArea { beachLengths } avgWidth output =
    case toFloat beachLengths.total * avgWidth of
        0 ->
            Ok { output | beachAreaChange = AcreageUnchanged }
        acreage ->
            Ok { output | beachAreaChange = AcreageGained <| abs acreage }


calculateBeachWidthChangeForSeaLevelRise : AdaptationHexes -> ZoneOfImpact -> OutputDetails -> Result OutputError OutputDetails
calculateBeachWidthChangeForSeaLevelRise hexes zoneOfImpact output =
    let
        hexesWithSLR = hexes |> List.filter (\hex -> hex.seaLevelRise /= NoSeaRise)
    in
    hexesWithSLR
        |> List.foldl (\hex acc -> (Hexes.seaLevelRiseToFloat hex.seaLevelRise) + acc)  0.0
        |> (\result -> result / (toFloat <| List.length hexesWithSLR) * (toFloat zoneOfImpact.beachLengths.total) * -1)
        |> acreageToAcreageResult
        |> \result -> { output | beachAreaChange = result }
        |> Ok


gainRareSpeciesHabitat : Bool -> OutputDetails -> Result OutputError OutputDetails
gainRareSpeciesHabitat isPresent output =
    if isPresent then
        Ok { output | rareSpeciesHabitat = HabitatGained }
    else
        Ok { output | rareSpeciesHabitat = HabitatUnchanged }


loseRareSpeciesHabitat : Bool -> OutputDetails -> Result OutputError OutputDetails
loseRareSpeciesHabitat isPresent output =
    if isPresent then
        Ok { output | rareSpeciesHabitat = HabitatLost }
    else
        Ok { output | rareSpeciesHabitat = HabitatUnchanged }


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