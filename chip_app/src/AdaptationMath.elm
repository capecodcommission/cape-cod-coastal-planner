module AdaptationMath exposing (..)


import AdaptationStrategy.CoastalHazards as Hazards exposing (CoastalHazard)
import AdaptationStrategy.Strategies as Strategies exposing (Strategy)
import AdaptationStrategy.StrategyDetails as Details exposing (StrategyDetails)
import AdaptationStrategy.Impacts exposing (..)
import AdaptationHexes as Hexes exposing (..)
import AdaptationOutput exposing (..)
import ShorelineLocation exposing (..)
import RemoteData as Remote exposing (WebData, RemoteData(..))
import Types exposing (..)


privateLandMultiplier : Float
privateLandMultiplier = 3360699


stormSurgeBldgMultiplier : Float
stormSurgeBldgMultiplier = 0.21


livingShorelineSaltMarshMultiplier : Float
livingShorelineSaltMarshMultiplier = 0.85


metersPerFoot : Float
metersPerFoot = 0.3048


acresPerSqMeter : Float
acresPerSqMeter = 0.000247105


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
                        |> Result.map2 ShowStrategy noActionOutput

            
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
    case Hazards.toType hazard of
        Ok Hazards.Erosion ->
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

        Ok Hazards.SeaLevelRise ->
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

        Ok Hazards.StormSurge ->
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

        Err badHazard ->
            Err <| BadInput ("Cannot calculate output for unknown or invalid coastal hazard type: '" ++ badHazard ++ "'")
    


{-| Calculate Strategy Output given a default copy of output and already calculated output for NoAction.

    If an output category is intended to have no impact due to the strategy or hazard, you can rely on the default value.

    If an output category relies on anything previously calcultated for NoAction, then you need to set it on the
    strategy's output, even if that means it's just copying it over from NoAction.
-}
calculateStrategyOutput : 
    AdaptationHexes 
    -> ZoneOfImpact 
    -> CoastalHazard
    -> (Strategy, StrategyDetails)
    -> OutputDetails
    -> OutputDetails
    -> Result OutputError OutputDetails
calculateStrategyOutput hexes zoneOfImpact hazard (strategy, details) output noActionOutput =
    let
        zoiTotal = zoiTotalMeters zoneOfImpact
    in
    case Hazards.toType hazard of
        Ok Hazards.Erosion ->
            let
                avgErosion = averageErosion hexes
            in
            case (Strategies.toType strategy, avgErosion) of
                ( Ok Strategies.Revetment, Eroding _ ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> protectPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((.saltMarshChange >> copySaltMarshAcreage) noActionOutput)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> loseRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen 
                            ( (.beachAreaChange 
                                >> adjustAcreageResult (Details.negativeAcreageImpact zoiTotal details)
                                >> setBeachArea) 
                              noActionOutput
                            )

                ( Ok Strategies.Revetment, Accreting _ ) ->
                    output
                        |> (getCriticalFacilityCount >> setCriticalFacilitiesUnchanged) noActionOutput
                        |> Result.andThen
                            ( (.beachAreaChange 
                                >> adjustAcreageResult (Details.negativeAcreageImpact zoiTotal details)
                                >> setBeachArea) 
                              noActionOutput
                            )

                ( Ok Strategies.Revetment, NoErosion ) ->
                    output
                        |> (.rareSpeciesHabitat >> getRareSpeciesPresence >> loseRareSpeciesHabitat) noActionOutput
                        |> Result.andThen
                            (setBeachArea <| Details.negativeAcreageImpact zoiTotal details)

                ( Ok Strategies.DuneCreation, Eroding _ ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> protectPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((.saltMarshChange >> copySaltMarshAcreage) noActionOutput)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen
                            ( (.beachAreaChange
                                >> adjustAcreageResult (Details.positiveAcreageImpact zoiTotal details)
                                >> setBeachArea)
                              noActionOutput
                            )

                ( Ok Strategies.DuneCreation, Accreting _ ) ->
                    output
                        |> (.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput
                        |> Result.andThen
                            ( (.beachAreaChange
                                >> adjustAcreageResult (Details.positiveAcreageImpact zoiTotal details)
                                >> setBeachArea)
                              noActionOutput
                            )

                ( Ok Strategies.DuneCreation, NoErosion ) ->
                    output
                        |> (.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput
                        |> Result.andThen
                            (setBeachArea <| Details.positiveAcreageImpact zoiTotal details)

                ( Ok Strategies.BankStabilization, Eroding _ ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> protectPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((.saltMarshChange >> copySaltMarshAcreage) noActionOutput)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> loseRareSpeciesHabitat) noActionOutput)

                ( Ok Strategies.BankStabilization, Accreting _ ) ->
                    output
                        |> (getCriticalFacilityCount >> setCriticalFacilitiesUnchanged) noActionOutput
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen ((.beachAreaChange >> copyBeachArea) noActionOutput)

                ( Ok Strategies.BankStabilization, NoErosion ) ->
                    Ok output

                ( Ok Strategies.LivingShoreline, Eroding _ ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> protectPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen 
                            ( (.saltMarshChange
                                >> adjustAcreageResult (Details.positiveAcreageImpact (zoiTotal * livingShorelineSaltMarshMultiplier) details)
                                >> setSaltMarshAcreage)
                              noActionOutput
                            )
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen
                            ( (.beachAreaChange
                                >> adjustAcreageResult (Details.negativeAcreageImpact zoiTotal details) 
                                >> setBeachArea)
                              noActionOutput
                            )

                ( Ok Strategies.LivingShoreline, Accreting _ ) ->
                    output
                        |> (.saltMarshChange
                                >> adjustAcreageResult (Details.positiveAcreageImpact (zoiTotal * livingShorelineSaltMarshMultiplier) details)
                                >> setSaltMarshAcreage)
                              noActionOutput
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen
                            ( (.beachAreaChange
                                >> adjustAcreageResult (Details.negativeAcreageImpact zoiTotal details) 
                                >> setBeachArea)
                              noActionOutput
                            )

                ( Ok Strategies.LivingShoreline, NoErosion ) ->
                    output
                        |> setSaltMarshAcreage (Details.positiveAcreageImpact (zoiTotal * livingShorelineSaltMarshMultiplier) details)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen (setBeachArea <| Details.negativeAcreageImpact zoiTotal details)

                ( Ok Strategies.BeachNourishment, Eroding _ ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> protectPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((.saltMarshChange >> copySaltMarshAcreage) noActionOutput)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen
                            ( (.beachAreaChange
                                >> adjustAcreageResult (Details.positiveAcreageImpact zoiTotal details)
                                >> setBeachArea)
                              noActionOutput
                            )

                ( Ok Strategies.BeachNourishment, Accreting _ ) ->
                    output
                        |> (.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput
                        |> Result.andThen
                            ( (.beachAreaChange
                                >> adjustAcreageResult (Details.positiveAcreageImpact zoiTotal details)
                                >> setBeachArea)
                              noActionOutput
                            )

                ( Ok Strategies.BeachNourishment, NoErosion ) ->
                    output
                        |> (.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput
                        |> Result.andThen (setBeachArea <| Details.positiveAcreageImpact zoiTotal details)

                ( Ok _, _) ->
                    Err <| BadInput "Cannot calculate output for unknown or invalid strategy type"

                ( Err badStrategy, _ ) ->
                    Err <| BadInput ("Cannot calculate output for unknown or invalid strategy type: '" ++ badStrategy ++ "'")


        Ok Hazards.SeaLevelRise ->
            let
                avgSeaLevelRise = averageSeaLevelRise hexes
            in
            case ( Strategies.toType strategy, avgSeaLevelRise ) of
                ( Ok _, _ ) ->
                    Err <| BadInput "Cannot calculate output for unknown or invalid strategy type"

                ( Err badStrategy, _ ) ->
                    Err <| BadInput ("Cannot calculate output for unknown or invalid strategy type: '" ++ badStrategy ++ "'")

        Ok Hazards.StormSurge ->
            let
                vulnerableToSurge = isVulnerableToStormSurge hexes
            in
            case ( Strategies.toType strategy, vulnerableToSurge ) of
                ( Ok _, _ ) ->
                    Err <| BadInput "Cannot calculate output for unknown or invalid strategy type"

                ( Err badStrategy, _ ) ->
                    Err <| BadInput ("Cannot calculate output for unknown or invalid strategy type: '" ++ badStrategy ++ "'")
    
        Err badHazard ->
            Err <| BadInput ("Cannot calculate output for unknown or invalid coastal hazard type: '" ++ badHazard ++ "'")






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
    Ok { output | scales = details.scales }


{-| Apply the relative cost of strategy implementation
-}
applyCost : StrategyDetails -> OutputDetails -> Result OutputError OutputDetails
applyCost details output =
    case List.head details.costs of
        Just cost ->
            Ok { output | cost = cost }

        Nothing ->
            Ok { output | cost = ImpactCost "Err" -1 Nothing }


{-| Apply the expected lifespan of a strategy implementation
-}
applyLifespan : StrategyDetails -> OutputDetails -> Result OutputError OutputDetails
applyLifespan details output =
    case List.head details.lifeSpans of
        Just lifespan ->
            Ok { output | lifespan = lifespan }

        Nothing ->
            Ok { output | lifespan = ImpactLifeSpan "Err" -1 Nothing}
    


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
    Ok { output | duration = hazard.duration }


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


setCriticalFacilitiesUnchanged : Count -> OutputDetails -> Result OutputError OutputDetails
setCriticalFacilitiesUnchanged facilities output =
    Ok { output | criticalFacilities = FacilitiesUnchanged facilities }


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


protectPublicBldgValue : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
protectPublicBldgValue value output =
    if value == 0 then
        Ok { output | publicBuildingValue = ValueUnchanged }
    else
        Ok { output | publicBuildingValue = ValueProtected <| abs value }


setPublicBldgValueUnchanged : OutputDetails -> Result OutputError OutputDetails
setPublicBldgValueUnchanged output =
    Ok { output | publicBuildingValue = ValueUnchanged }


losePrivateLandValue : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
losePrivateLandValue value output =
    if value == 0 then
        Ok { output | privateLandValue = ValueUnchanged }
    else
        Ok { output | privateLandValue = ValueLoss <| abs value }


protectPrivateLandValue : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
protectPrivateLandValue value output =
    if value == 0 then
        Ok { output | privateLandValue = ValueUnchanged }
    else
        Ok { output | privateLandValue = ValueProtected <| abs value }


setPrivateLandValueUnchanged : OutputDetails -> Result OutputError OutputDetails
setPrivateLandValueUnchanged output =
    Ok { output | privateLandValue = ValueUnchanged }


losePrivateBldgValue : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
losePrivateBldgValue value output =
    if value == 0 then
        Ok { output | privateBuildingValue = ValueUnchanged }
    else
        Ok { output | privateBuildingValue = ValueLoss <| abs value }


protectPrivateBldgValue : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
protectPrivateBldgValue value output =
    if value == 0 then
        Ok { output | privateBuildingValue = ValueUnchanged }
    else
        Ok { output | privateBuildingValue = ValueProtected <| abs value }


setPrivateBldgValueUnchanged : OutputDetails -> Result OutputError OutputDetails
setPrivateBldgValueUnchanged output =
    Ok { output | privateBuildingValue = ValueUnchanged }


loseSaltMarshAcreage : Acreage -> OutputDetails -> Result OutputError OutputDetails
loseSaltMarshAcreage acreage output =
    if acreage == 0 then
        Ok { output | saltMarshChange = AcreageUnchanged }
    else
        Ok { output | saltMarshChange = AcreageLost <| abs acreage}


copySaltMarshAcreage : AcreageResult -> OutputDetails -> Result OutputError OutputDetails
copySaltMarshAcreage result output =
    Ok { output | saltMarshChange = result }


setSaltMarshAcreageUnchanged : OutputDetails -> Result OutputError OutputDetails
setSaltMarshAcreageUnchanged output =
    Ok { output | saltMarshChange = AcreageUnchanged }


setSaltMarshAcreage : Acreage -> OutputDetails -> Result OutputError OutputDetails
setSaltMarshAcreage acreage output =
    if acreage > 0 then
        Ok { output | saltMarshChange = AcreageGained acreage }
    else if acreage < 0 then
        Ok { output | saltMarshChange = AcreageLost <| abs acreage }
    else
        Ok { output | saltMarshChange = AcreageUnchanged }


-- Should be rewritten to be more compositional like the other functions
loseBeachArea : ZoneOfImpact -> ImpactWidth -> OutputDetails -> Result OutputError OutputDetails
loseBeachArea zoi avgWidth output =
    case zoiTotalMeters zoi * avgWidth of
        0 ->
            Ok { output | beachAreaChange = AcreageUnchanged }
        acreage ->
            Ok { output | beachAreaChange = AcreageLost <| abs acreage * acresPerSqMeter }


-- Should be rewritten to be more compositional like the other functions
gainBeachArea : ZoneOfImpact -> ImpactWidth -> OutputDetails -> Result OutputError OutputDetails
gainBeachArea zoi avgWidth output =
    case zoiTotalMeters zoi * avgWidth of
        0 ->
            Ok { output | beachAreaChange = AcreageUnchanged }
        acreage ->
            Ok { output | beachAreaChange = AcreageGained <| abs acreage * acresPerSqMeter }


setBeachAreaUnchanged : OutputDetails -> Result OutputError OutputDetails
setBeachAreaUnchanged output =
    Ok { output | beachAreaChange = AcreageUnchanged }


setBeachArea : Acreage -> OutputDetails -> Result OutputError OutputDetails
setBeachArea acreage output =
    if acreage > 0 then
        Ok { output | beachAreaChange = AcreageGained acreage }
    else if acreage < 0 then
        Ok { output | beachAreaChange = AcreageLost <| abs acreage }
    else
        Ok { output | beachAreaChange = AcreageUnchanged }


copyBeachArea : AcreageResult -> OutputDetails -> Result OutputError OutputDetails
copyBeachArea result output =
    Ok { output | beachAreaChange = result }


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


setRareSpeciesHabitatUnchanged : OutputDetails -> Result OutputError OutputDetails
setRareSpeciesHabitatUnchanged output =
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