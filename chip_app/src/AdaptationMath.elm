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

-- THIS MULTIPLIER IS USED ONLY FOR LIVING SHORELINE SALT MARSH CHANGE
livingShorelineSaltMarshMultiplier : Float
livingShorelineSaltMarshMultiplier = 0.85

-- THIS MULTIPLIER IS USED ONLY FOR UNDEVELOPMENT BEACH AREA CHANGE
undevelopmentBeachAreaMultiplier : Float
undevelopmentBeachAreaMultiplier = 3.33

metersPerFoot : Float
metersPerFoot = 0.3048


acresPerSqMeter : Float
acresPerSqMeter = 0.000247105


{-| Calculate output for the selected Strategy. If the strategy selected is NoAction, it will only
    calculate information for that scenario. If the strategy selected is anything else, it will
    calculate information for both the NoAction scenario, as a baseline for comparison, and then
    also the information for the selected strategy.
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
        |> Result.andThen (applyDescription details)
        |> Result.andThen (applyScales details)
        |> Result.andThen (applyCost details)
        |> Result.andThen (applyLifespan details)
        |> Result.andThen (applyHazard hazard)
        |> Result.andThen (applyLocation location)
        |> Result.andThen (applyDuration hazard)
        |> Result.andThen (applyScenarioSize zoneOfImpact)

{-| Calculate output for the NoAction scenario given a default copy of the output.
-}
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
                    let
                        vulnerableToErosion = withErosion hexes
                    in
                        output
                            |> (countCriticalFacilities >> loseCriticalFacilities) vulnerableToErosion
                            |> Result.andThen ((sumPublicBldgValue >> losePublicBldgValue) vulnerableToErosion)
                            |> Result.andThen 
                                ( (sumPrivateLandAcreage 
                                    >> applyMultiplier privateLandMultiplier
                                    >> losePrivateLandValue)
                                vulnerableToErosion
                                )
                            |> Result.andThen ((sumPrivateBldgValue >> losePrivateBldgValue) vulnerableToErosion)
                            |> Result.andThen ((sumSaltMarshAcreage >> loseSaltMarshAcreage) vulnerableToErosion)
                            |> Result.andThen ((isRareSpeciesHabitatPresent >> loseRareSpeciesHabitat) vulnerableToErosion)
                            |> Result.andThen ((zoiAcreageImpact width >> loseBeachArea) zoneOfImpact)

                Accreting width ->
                    let
                        vulnerableToAccretion = withAccretion hexes
                    in
                        output
                            |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) vulnerableToAccretion
                            |> Result.andThen ((isRareSpeciesHabitatPresent >> gainRareSpeciesHabitat) vulnerableToAccretion)
                            |> Result.andThen ((zoiAcreageImpact width >> gainBeachArea) zoneOfImpact)

                NoErosion -> 
                    output
                        |> (countCriticalFacilities >> setCriticalFacilitiesUnchanged) hexes

        Ok Hazards.SeaLevelRise ->
            let
                avgSeaLevelRise = averageSeaLevelRise hexes
            in
            case avgSeaLevelRise of
                VulnSeaRise width ->
                    let
                        vulnerableToSLR = withSeaLevelRise hexes
                    in
                        output
                            |> (countCriticalFacilities >> loseCriticalFacilities) vulnerableToSLR
                            |> Result.andThen ((sumPublicBldgValue >> losePublicBldgValue) vulnerableToSLR)
                            |> Result.andThen
                                ( (sumPrivateLandAcreage 
                                    >> applyMultiplier privateLandMultiplier
                                    >> losePrivateLandValue)
                                vulnerableToSLR
                                )
                            |> Result.andThen ((sumPrivateBldgValue >> losePrivateBldgValue) vulnerableToSLR)
                            |> Result.andThen ((sumSaltMarshAcreage >> loseSaltMarshAcreage) vulnerableToSLR)
                            |> Result.andThen ((isRareSpeciesHabitatPresent >> loseRareSpeciesHabitat) vulnerableToSLR)
                            |> Result.andThen ((zoiAcreageImpact width >> loseBeachArea) zoneOfImpact)

                NoSeaRise ->
                    output
                        |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) hexes

        Ok Hazards.StormSurge ->
            let
                vulnerableToSurge = isVulnerableToStormSurge hexes
            in
            case vulnerableToSurge of
                True ->
                let
                    vulnerableToSS = withStormSurge hexes
                in
                    output
                        |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) hexes
                        |> Result.andThen
                            ( (sumPublicBldgValue
                                >> applyMultiplier stormSurgeBldgMultiplier
                                >> losePublicBldgValue)
                            vulnerableToSS
                            )
                        |> Result.andThen
                            ( (sumPrivateBldgValue
                                >> applyMultiplier stormSurgeBldgMultiplier
                                >> losePrivateBldgValue)
                              vulnerableToSS
                            )

                False ->
                    output
                        |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) hexes

        Err badHazard ->
            Err <| BadInput ("Cannot calculate output for unknown or invalid coastal hazard type: '" ++ badHazard ++ "'")
    


{-| Calculate Strategy Output given a default copy of output and already calculated 
    output for NoAction.

    If an output category is intended to have no impact due to the strategy or hazard, 
    you can rely on the default value.

    If an output category relies on anything previously calcultated for NoAction, 
    then you need to set it on the strategy's output, even if that means it's just 
    copying it over from NoAction.
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
                ( Ok Strategies.Undevelopment, Eroding _ ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> setPublicBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> copyPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> setPrivateBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen
                            ( (.saltMarshChange
                                >> adjustAcreageResult
                                    ( if hasSaltMarshAndRevetment hexes then
                                        Details.positiveAcreageImpact zoiTotal details
                                      else
                                        0
                                    )
                                >> setSaltMarshAcreage)
                              noActionOutput
                            )
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen
                            ( (.beachAreaChange
                                >> adjustAcreageResult
                                    ( if hasRevetment hexes then
                                        Details.positiveAcreageImpact (zoiTotal * undevelopmentBeachAreaMultiplier) details
                                      else
                                        0
                                    )
                                >> setBeachArea)
                              noActionOutput
                            )

                ( Ok Strategies.Undevelopment, Accreting _ ) ->
                    output
                        |> (getCriticalFacilityCount >> relocateCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> setPublicBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> setPrivateBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen
                            ( setSaltMarshAcreage <|
                                ( if hasSaltMarshAndRevetment hexes then
                                    Details.positiveAcreageImpact zoiTotal details
                                  else
                                    0
                                )
                            )
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen
                            ( (.beachAreaChange
                                >> adjustAcreageResult
                                    ( if hasRevetment hexes then 
                                        Details.positiveAcreageImpact (zoiTotal * undevelopmentBeachAreaMultiplier) details
                                      else
                                        0
                                    )
                                >> setBeachArea)
                              noActionOutput
                            )

                ( Ok Strategies.Undevelopment, NoErosion ) ->
                    output
                        |> (getCriticalFacilityCount >> relocateCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> setPublicBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> setPrivateBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen
                            ( setSaltMarshAcreage <|
                                ( if hasSaltMarshAndRevetment hexes then
                                    Details.positiveAcreageImpact zoiTotal details
                                  else
                                    0
                                )
                            )
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen
                            ( setBeachArea <|
                                ( if hasRevetment hexes then 
                                    Details.positiveAcreageImpact (zoiTotal * undevelopmentBeachAreaMultiplier) details
                                  else
                                    0
                                )
                            )

                ( Ok Strategies.OpenSpaceProtection, Eroding _ ) ->
                    output
                        |> (getCriticalFacilityCount >> loseCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> copyPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> transferPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> copyPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((.saltMarshChange >> copySaltMarshAcreage) noActionOutput)
                        |> Result.andThen ((.rareSpeciesHabitat >> copyRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen ((.beachAreaChange >> copyBeachArea) noActionOutput)

                ( Ok Strategies.OpenSpaceProtection, Accreting _ ) ->
                    output
                        |> (.beachAreaChange >> copyBeachArea) noActionOutput

                ( Ok Strategies.OpenSpaceProtection, NoErosion ) ->
                    Ok output

                ( Ok Strategies.SaltMarshRestoration, Eroding _ ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> protectPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen 
                            ( (.saltMarshChange
                                >> adjustAcreageResult (Details.positiveAcreageImpact zoiTotal details)
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

                ( Ok Strategies.SaltMarshRestoration, Accreting _ ) ->
                    output
                        |> (setSaltMarshAcreage <| Details.positiveAcreageImpact zoiTotal details)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen
                            ( (.beachAreaChange
                                >> adjustAcreageResult (Details.negativeAcreageImpact zoiTotal details)
                                >> setBeachArea)
                              noActionOutput
                            )

                ( Ok Strategies.SaltMarshRestoration, NoErosion ) ->
                    output
                        |> (setSaltMarshAcreage <| Details.positiveAcreageImpact zoiTotal details)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen (setBeachArea <| Details.negativeAcreageImpact zoiTotal details)

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
                        |> setSaltMarshAcreage (Details.positiveAcreageImpact (zoiTotal * livingShorelineSaltMarshMultiplier) details)
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
                ( Ok Strategies.Undevelopment, VulnSeaRise _ ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> setPublicBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> copyPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> setPrivateBldgValueNoLongerPresent) noActionOutput)                        |> Result.andThen
                            ( (.saltMarshChange
                                >> adjustAcreageResult
                                    ( if hasSaltMarshAndRevetment hexes then
                                        Details.positiveAcreageImpact zoiTotal details
                                      else
                                        0
                                    )
                                >> setSaltMarshAcreage)
                              noActionOutput
                            )
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen
                            ( (.beachAreaChange
                                >> adjustAcreageResult
                                    ( if hasRevetment hexes then 
                                        Details.positiveAcreageImpact (zoiTotal * undevelopmentBeachAreaMultiplier) details
                                      else
                                        0
                                    )
                                >> setBeachArea)
                              noActionOutput
                            )

                ( Ok Strategies.Undevelopment, NoSeaRise ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> setPublicBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> setPrivateBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen
                            ( setSaltMarshAcreage <|
                                ( if hasSaltMarshAndRevetment hexes then
                                    Details.positiveAcreageImpact zoiTotal details
                                  else
                                    0
                                )
                            )
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen 
                            ( setBeachArea <|
                                ( if hasRevetment hexes then 
                                    Details.positiveAcreageImpact (zoiTotal * undevelopmentBeachAreaMultiplier) details
                                  else
                                    0
                                )
                            )

                ( Ok Strategies.OpenSpaceProtection, VulnSeaRise _ ) ->
                    Ok noActionOutput

                ( Ok Strategies.OpenSpaceProtection, NoSeaRise ) ->
                    Ok output

                ( Ok Strategies.SaltMarshRestoration, VulnSeaRise _ ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> protectPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen
                            ( (.saltMarshChange
                                >> adjustAcreageResult (Details.positiveAcreageImpact zoiTotal details)
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

                ( Ok Strategies.SaltMarshRestoration, NoSeaRise ) ->
                    output
                        |> (setSaltMarshAcreage <| Details.positiveAcreageImpact zoiTotal details)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen (setBeachArea <| Details.negativeAcreageImpact zoiTotal details)

                ( Ok Strategies.DuneCreation, VulnSeaRise _ ) ->
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

                ( Ok Strategies.DuneCreation, NoSeaRise ) -> 
                    output
                        |> (.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput
                        |> Result.andThen (setBeachArea <| Details.positiveAcreageImpact zoiTotal details)

                ( Ok _, _ ) ->
                    Err <| BadInput "Cannot calculate output for unknown or invalid strategy type"

                ( Err badStrategy, _ ) ->
                    Err <| BadInput ("Cannot calculate output for unknown or invalid strategy type: '" ++ badStrategy ++ "'")

        Ok Hazards.StormSurge ->
            let
                vulnerableToSurge = isVulnerableToStormSurge hexes
            in
            case ( Strategies.toType strategy, vulnerableToSurge ) of
                ( Ok Strategies.Undevelopment, True ) ->
                    output
                    -- TODO: REMOVED SALT MARSH AND BEACH AREA CHANGE MATH FOR STORM SURGE
                    -- - UNDEVELOPMENT - STILL FUZZY ON THIS - THIS NEEDS TO BE CONFIRMED
                        |> (getCriticalFacilityCount >> relocateCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> setPublicBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> setPrivateBldgValueNoLongerPresent) noActionOutput)
                        -- |> Result.andThen
                        --     ( setSaltMarshAcreage <|
                        --         ( if hasSaltMarshAndRevetment hexes then
                        --             Details.positiveAcreageImpact zoiTotal details
                        --           else
                        --             0
                        --         )
                        --     )
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        -- |> Result.andThen 
                        --     ( setBeachArea <|
                        --         ( if hasRevetment hexes then 
                        --             Details.positiveAcreageImpact (zoiTotal * undevelopmentBeachAreaMultiplier) details
                        --           else
                        --             0
                        --         )
                        --     )
                
                ( Ok Strategies.Undevelopment, False ) ->
                    output
                        |> (getCriticalFacilityCount >> relocateCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> setPublicBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> setPrivateBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen
                            ( setSaltMarshAcreage <|
                                ( if hasSaltMarshAndRevetment hexes then
                                    Details.positiveAcreageImpact zoiTotal details
                                  else
                                    0
                                )
                            )
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen 
                            ( setBeachArea <|
                                ( if hasRevetment hexes then 
                                    Details.positiveAcreageImpact (zoiTotal * undevelopmentBeachAreaMultiplier) details
                                  else
                                    0
                                )
                            )

                ( Ok Strategies.OpenSpaceProtection, True ) ->
                    output
                        |> (.publicBuildingValue >> copyPublicBldgValue) noActionOutput
                        |> Result.andThen ((.privateBuildingValue >> copyPrivateBldgValue) noActionOutput)

                ( Ok Strategies.OpenSpaceProtection, False ) ->
                    Ok output

                ( Ok Strategies.SaltMarshRestoration, True ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen (setSaltMarshAcreage <| Details.positiveAcreageImpact zoiTotal details)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen (setBeachArea <| Details.negativeAcreageImpact zoiTotal details)

                ( Ok Strategies.SaltMarshRestoration, False ) ->
                    output
                        |> (setSaltMarshAcreage <| Details.positiveAcreageImpact zoiTotal details)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen (setBeachArea <| Details.negativeAcreageImpact zoiTotal details)

                ( Ok Strategies.DuneCreation, True ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen (setBeachArea <| Details.positiveAcreageImpact zoiTotal details)

                ( Ok Strategies.DuneCreation, False ) ->
                    output
                        |> (.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput
                        |> Result.andThen (setBeachArea <| Details.positiveAcreageImpact zoiTotal details)

                ( Ok Strategies.BankStabilization, True ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)

                ( Ok Strategies.BankStabilization, False ) ->
                    Ok output

                ( Ok Strategies.LivingShoreline, True ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen (setSaltMarshAcreage <| Details.positiveAcreageImpact (zoiTotal * livingShorelineSaltMarshMultiplier) details)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen (setBeachArea <| Details.negativeAcreageImpact zoiTotal details)

                ( Ok Strategies.LivingShoreline, False ) ->
                    output
                        |> setSaltMarshAcreage (Details.positiveAcreageImpact (zoiTotal * livingShorelineSaltMarshMultiplier) details)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen (setBeachArea <| Details.negativeAcreageImpact zoiTotal details)

                ( Ok Strategies.BeachNourishment, True ) ->
                    output
                        |> (getCriticalFacilityCount >> setCriticalFacilitiesUnchanged) noActionOutput
                            |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> setPublicBldgValueUnchanged) noActionOutput)
                            |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> setPrivateBldgValueUnchanged) noActionOutput)
                            |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                            |> Result.andThen (setBeachArea <| Details.positiveAcreageImpact zoiTotal details)

                ( Ok Strategies.BeachNourishment, False ) ->
                    output
                        |> (.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput
                        |> Result.andThen (setBeachArea <| Details.positiveAcreageImpact zoiTotal details)

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


applyDescription : StrategyDetails -> OutputDetails -> Result OutputError OutputDetails
applyDescription { description } output =
    Ok { output | description = description }


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


relocateCriticalFacilities : Count -> OutputDetails -> Result OutputError OutputDetails
relocateCriticalFacilities facilities output =
    if facilities == 0 then
        Ok output
    else
        abs facilities
            |> FacilitiesRelocated
            |> \result -> Ok { output | criticalFacilities = result }


copyPublicBldgValue : MonetaryResult -> OutputDetails -> Result OutputError OutputDetails
copyPublicBldgValue result output =
    Ok { output | publicBuildingValue = result }


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


setPublicBldgValueUnchanged : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
setPublicBldgValueUnchanged value output =
    Ok { output | publicBuildingValue = ValueUnchanged }


setPublicBldgValueNoLongerPresent : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
setPublicBldgValueNoLongerPresent value output =
    if value == 0 then
        Ok { output | publicBuildingValue = ValueUnchanged }
    else
        Ok { output | publicBuildingValue = ValueNoLongerPresent }


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


transferPrivateLandValue : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
transferPrivateLandValue value output =
    if value == 0 then
        Ok { output | privateLandValue = ValueUnchanged }
    else
        Ok { output | privateLandValue = ValueTransferred <| abs value }


setPrivateLandValueUnchanged : OutputDetails -> Result OutputError OutputDetails
setPrivateLandValueUnchanged output =
    Ok { output | privateLandValue = ValueUnchanged }


copyPrivateLandValue : MonetaryResult -> OutputDetails -> Result OutputError OutputDetails
copyPrivateLandValue result output =
    Ok { output | privateLandValue = result }


setPrivateBldgValueNoLongerPresent : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
setPrivateBldgValueNoLongerPresent value output =
    if value == 0 then
        Ok { output | privateBuildingValue = ValueUnchanged }
    else
        Ok { output | privateBuildingValue = ValueNoLongerPresent }


copyPrivateBldgValue : MonetaryResult -> OutputDetails -> Result OutputError OutputDetails
copyPrivateBldgValue result output =    
    Ok { output | privateBuildingValue = result }


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


setPrivateBldgValueUnchanged : MonetaryValue -> OutputDetails -> Result OutputError OutputDetails
setPrivateBldgValueUnchanged value output =
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
        Ok { output | saltMarshChange = AcreageGained <| abs acreage }
    else if acreage < 0 then
        Ok { output | saltMarshChange = AcreageLost <| abs acreage }
    else
        Ok { output | saltMarshChange = AcreageUnchanged }


loseBeachArea : Acreage -> OutputDetails -> Result OutputError OutputDetails
loseBeachArea acreage output =
    if acreage == 0 then
        Ok { output | beachAreaChange = AcreageUnchanged }
    else
        Ok { output | beachAreaChange = AcreageLost <| abs acreage }


gainBeachArea : Acreage -> OutputDetails -> Result OutputError OutputDetails
gainBeachArea acreage output =
    if acreage == 0 then
        Ok { output | beachAreaChange = AcreageUnchanged }
    else
        Ok { output | beachAreaChange = AcreageGained <| abs acreage }


setBeachAreaUnchanged : OutputDetails -> Result OutputError OutputDetails
setBeachAreaUnchanged output =
    Ok { output | beachAreaChange = AcreageUnchanged }


setBeachArea : Acreage -> OutputDetails -> Result OutputError OutputDetails
setBeachArea acreage output =
    if acreage > 0 then
        Ok { output | beachAreaChange = AcreageGained <| abs acreage }
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


copyRareSpeciesHabitat : RareSpeciesHabitat -> OutputDetails -> Result OutputError OutputDetails
copyRareSpeciesHabitat habitat output =
    Ok { output | rareSpeciesHabitat = habitat }



-- {-| WARNING! Uncommenting this code does not mean it can then just be plugged back in and have it work
--     I'm leaving it here as a loose guide to the programmer of one way to implement the algorithm for NPV

--     Calculate the net present value (NPV) for selected shoreline

--     Beach types include National Seashore, Town Beach, and Other Public Beach
-- -}
-- calculateBeachValue : AdaptationHexes -> ZoneOfImpact -> OutputDetails -> Result OutputError OutputDetails
-- calculateBeachValue hexes zoneOfImpact output =
--     let
--         cashFlow = annualChangeBeachValue hexes zoneOfImpact
--     in
--     List.range 1 npvConstants.numPeriods
--         |> List.foldl (netPresentValue cashFlow) 0.0
--         |> monetaryValueToResult
--         |> \result -> Ok { output | beachValue = result }


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