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
                            |> Result.andThen ((countHistoricalPlaces >> loseHistoricalPlacesNoNum) vulnerableToErosion)
                            |> Result.andThen ((sumPublicBldgValue >> losePublicBldgValue) vulnerableToErosion)
                            |> Result.andThen 
                                ( (sumPrivateLandAcreage 
                                    >> applyMultiplier privateLandMultiplier
                                    >> losePrivateLandValue)
                                vulnerableToErosion
                                )
                            |> Result.andThen ((sumPrivateBldgValue >> losePrivateBldgValue) vulnerableToErosion)
                            -- |> Result.andThen ((sumSaltMarshAcreage >> loseSaltMarshAcreage) vulnerableToErosion)
                            |> Result.andThen ((isRareSpeciesHabitatPresent >> loseRareSpeciesHabitat) vulnerableToErosion)
                            |> Result.andThen ((zoiAcreageImpact width >> loseBeachArea) zoneOfImpact)
                            |> Result.andThen ((sumRdTotMile >> loseRdTotMile) vulnerableToErosion)

                Accreting width ->
                    let
                        vulnerableToAccretion = withAccretion hexes
                    in
                        output
                            |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) vulnerableToAccretion
                            |> Result.andThen ((countHistoricalPlaces >> flagHistoricalPlacesAsPresent) vulnerableToAccretion)
                            |> Result.andThen ((isRareSpeciesHabitatPresent >> gainRareSpeciesHabitat) vulnerableToAccretion)
                            |> Result.andThen ((zoiAcreageImpact width >> gainBeachArea) zoneOfImpact)

                NoErosion -> 
                    output
                        |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) hexes
                        |> Result.andThen ((countHistoricalPlaces >> flagHistoricalPlacesAsPresent) hexes)

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
                            |> Result.andThen ((countHistoricalPlaces >> loseHistoricalPlacesNoNum) vulnerableToSLR)
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
                            |> Result.andThen ((sumSLRRdTotMile >> loseSLRRdTotMile) vulnerableToSLR)

                NoSeaRise ->
                    output
                        |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) hexes
                        |> Result.andThen ((countHistoricalPlaces >> flagHistoricalPlacesAsPresent) hexes)

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
                                |> Result.andThen ((countHistoricalPlaces >> flagHistoricalPlacesAsPresent) hexes)
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
                                |> Result.andThen ((sumStormSurgeRdTotMile >> loseStormSurgeRdTotMile) vulnerableToSS)

                    False ->
                        output
                            |> (countCriticalFacilities >> flagCriticalFacilitiesAsPresent) hexes
                            |> Result.andThen ((countHistoricalPlaces >> flagHistoricalPlacesAsPresent) hexes)

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
                ( Ok Strategies.Undevelopment, Eroding width ) ->
                    output
                        |> (getCriticalFacilityCount >> loseCriticalFacilities) noActionOutput
                        -- |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> setPublicBldgValueNoLongerPresent) noActionOutput)
                        -- |> Result.andThen ((.privateLandValue >> copyPrivateLandValue) noActionOutput)
                        -- |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> setPrivateBldgValueNoLongerPresent) noActionOutput)
                        
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> losePublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> losePrivateLandValue) noActionOutput)   
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> losePrivateBldgValue) noActionOutput)
                        -- |> Result.andThen
                        --     ( (.saltMarshChange
                        --         >> adjustAcreageResult
                        --             ( if hasSaltMarshAndRevetment hexes then
                        --                 Details.positiveAcreageImpact zoiTotal details
                        --               else
                        --                 0
                        --             )
                        --         >> setSaltMarshAcreage)
                        --       noActionOutput
                        --     )
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
                        |> Result.andThen ((getHistoricalPlaceCount >> loseHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> loseRdTotMile) noActionOutput)

                ( Ok Strategies.Undevelopment, Accreting width ) ->
                    output
                        |> (getCriticalFacilityCount >> loseCriticalFacilities) noActionOutput
                        -- |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> setPublicBldgValueNoLongerPresent) noActionOutput)
                        -- |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> setPrivateBldgValueNoLongerPresent) noActionOutput)
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> losePublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> losePrivateLandValue) noActionOutput)   
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> losePrivateBldgValue) noActionOutput)
                        
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
                        --     ( (.beachAreaChange
                        --         >> adjustAcreageResult
                        --             ( if hasRevetment hexes then 
                        --                 Details.positiveAcreageImpact (zoiTotal * undevelopmentBeachAreaMultiplier) details
                        --               else
                        --                 0
                        --             )
                        --         >> setBeachArea)
                        --       noActionOutput
                        --     )
                        
                        |> Result.andThen ((zoiAcreageImpact width >> gainBeachArea) zoneOfImpact)    
                        |> Result.andThen ((getHistoricalPlaceCount >> loseHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> loseRdTotMile) noActionOutput)

                ( Ok Strategies.Undevelopment, NoErosion ) ->
                    output
                        |> (getCriticalFacilityCount >> loseCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> losePublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> protectPrivateLandValue) noActionOutput)   
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> losePrivateBldgValue) noActionOutput)
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
                        |> Result.andThen ((getHistoricalPlaceCount >> loseHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> loseRdTotMile) noActionOutput)

                ( Ok Strategies.OpenSpaceProtection, Eroding width ) ->
                    output
                        
                        |> (zoiAcreageImpact width >> loseBeachArea) zoneOfImpact
                        -- |> (getCriticalFacilityCount >> loseCriticalFacilities) noActionOutput
                        -- |> Result.andThen ((.publicBuildingValue >> copyPublicBldgValue) noActionOutput)
                        -- |> Result.andThen ((.privateLandValue >> getMonetaryValue >> transferPrivateLandValue) noActionOutput)
                        -- |> Result.andThen ((.privateBuildingValue >> copyPrivateBldgValue) noActionOutput)
                        -- |> Result.andThen ((.saltMarshChange >> copySaltMarshAcreage) noActionOutput)
                        -- |> Result.andThen ((.rareSpeciesHabitat >> copyRareSpeciesHabitat) noActionOutput)
                        -- |> Result.andThen ((.beachAreaChange >> copyBeachArea) noActionOutput)
                        -- |> Result.andThen ((getHistoricalPlaceCount >> loseHistoricalPlaces) noActionOutput)
                        -- |> Result.andThen ((getRdTotMile >> loseRdTotMile) noActionOutput)

                ( Ok Strategies.OpenSpaceProtection, Accreting width ) ->
                    output
                        -- |> (.beachAreaChange >> copyBeachArea) noActionOutput
                        |> (zoiAcreageImpact width >> gainBeachArea) zoneOfImpact

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
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

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
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

                ( Ok Strategies.Revetment, Accreting _ ) ->
                    output
                        |> (getCriticalFacilityCount >> setCriticalFacilitiesUnchanged) noActionOutput
                        |> Result.andThen
                            ( (.beachAreaChange 
                                >> adjustAcreageResult (Details.negativeAcreageImpact zoiTotal details)
                                >> setBeachArea) 
                              noActionOutput
                            )
                        -- |> Result.andThen ((getHistoricalPlaceCount >> setHistoricalPlacesUnchanged) noActionOutput)

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
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

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
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

                ( Ok Strategies.BankStabilization, Accreting _ ) ->
                    output
                        |> (getCriticalFacilityCount >> setCriticalFacilitiesUnchanged) noActionOutput
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen ((.beachAreaChange >> copyBeachArea) noActionOutput)
                        -- |> Result.andThen ((getHistoricalPlaceCount >> setHistoricalPlacesUnchanged) noActionOutput)

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
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

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
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

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

                -- Managed Relocation & Retrofitting Assets
                ( Ok Strategies.ManagedRelocation, Eroding width ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> losePrivateLandValue) noActionOutput)   
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> loseRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen ((zoiAcreageImpact width >> loseBeachArea) zoneOfImpact)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

                ( Ok Strategies.ManagedRelocation, Accreting width ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen ((zoiAcreageImpact width >> gainBeachArea) zoneOfImpact)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

                ( Ok Strategies.ManagedRelocation, NoErosion ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)
                
                ( Ok Strategies.RetrofittingAssets, Eroding width ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> losePrivateLandValue) noActionOutput)   
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> loseRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen ((zoiAcreageImpact width >> loseBeachArea) zoneOfImpact)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

                ( Ok Strategies.RetrofittingAssets, Accreting width ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen ((zoiAcreageImpact width >> gainBeachArea) zoneOfImpact)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

                ( Ok Strategies.RetrofittingAssets, NoErosion ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)
                -- End of Managed Relocation & Retrofitting Assets
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
                        |> (getCriticalFacilityCount >> loseCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> losePublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> losePrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> losePrivateBldgValue) noActionOutput)                        
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
                        |> Result.andThen ((getHistoricalPlaceCount >> loseHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getSLRRdTotMile >> loseSLRRdTotMile) noActionOutput)

                ( Ok Strategies.Undevelopment, NoSeaRise ) ->
                    output
                        |> (getCriticalFacilityCount >> loseCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> losePublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> protectPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> losePrivateBldgValue) noActionOutput)
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
                        |> Result.andThen ((getHistoricalPlaceCount >> loseHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getSLRRdTotMile >> loseSLRRdTotMile) noActionOutput)

                ( Ok Strategies.OpenSpaceProtection, VulnSeaRise width ) ->
                    output
                        |> (zoiAcreageImpact width >> loseBeachArea) zoneOfImpact

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
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getSLRRdTotMile >> protectSLRRdTotMile) noActionOutput)

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
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getSLRRdTotMile >> protectSLRRdTotMile) noActionOutput)

                ( Ok Strategies.DuneCreation, NoSeaRise ) -> 
                    output
                        |> (.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput
                        |> Result.andThen (setBeachArea <| Details.positiveAcreageImpact zoiTotal details)

                -- Managed Relocation & Retrofitting Assets                
                ( Ok Strategies.ManagedRelocation, VulnSeaRise width ) ->
                    let
                        vulnerableToSLR = withSeaLevelRise hexes
                    in
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> losePrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput) 
                        |> Result.andThen ((sumSaltMarshAcreage >> loseSaltMarshAcreage) vulnerableToSLR)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> loseRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen ((zoiAcreageImpact width >> loseBeachArea) zoneOfImpact)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getSLRRdTotMile >> protectSLRRdTotMile) noActionOutput)

                ( Ok Strategies.ManagedRelocation, NoSeaRise ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getSLRRdTotMile >> protectSLRRdTotMile) noActionOutput)

                ( Ok Strategies.RetrofittingAssets, VulnSeaRise width ) ->
                    let
                        vulnerableToSLR = withSeaLevelRise hexes
                    in
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> losePrivateLandValue) noActionOutput)
                        |> Result.andThen ((sumSaltMarshAcreage >> loseSaltMarshAcreage) vulnerableToSLR)
                        |> Result.andThen ((.rareSpeciesHabitat >> getRareSpeciesPresence >> loseRareSpeciesHabitat) noActionOutput)
                        |> Result.andThen ((zoiAcreageImpact width >> loseBeachArea) zoneOfImpact)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

                ( Ok Strategies.RetrofittingAssets, NoSeaRise ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

                -- End of Managed Relocation & Retrofitting Assets

                
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
                        |> (getCriticalFacilityCount >> loseCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> losePublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> protectPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> losePrivateBldgValue) noActionOutput)                        
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
                        |> Result.andThen ((getHistoricalPlaceCount >> loseHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getStormSurgeRdTotMile >> loseStormSurgeRdTotMile) noActionOutput)
                
                ( Ok Strategies.Undevelopment, False ) ->
                    output
                        |> (getCriticalFacilityCount >> loseCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> losePublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateLandValue >> getMonetaryValue >> protectPrivateLandValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> losePrivateBldgValue) noActionOutput)                      
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
                        |> Result.andThen ((getHistoricalPlaceCount >> loseHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getStormSurgeRdTotMile >> loseStormSurgeRdTotMile) noActionOutput)

                ( Ok Strategies.OpenSpaceProtection, True ) ->
                    Ok output

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
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getStormSurgeRdTotMile >> protectStormSurgeRdTotMile) noActionOutput)

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
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getStormSurgeRdTotMile >> protectStormSurgeRdTotMile) noActionOutput)

                ( Ok Strategies.DuneCreation, False ) ->
                    output
                        |> (.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput
                        |> Result.andThen (setBeachArea <| Details.positiveAcreageImpact zoiTotal details)

                ( Ok Strategies.BankStabilization, True ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getStormSurgeRdTotMile >> protectStormSurgeRdTotMile) noActionOutput)

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
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getStormSurgeRdTotMile >> protectStormSurgeRdTotMile) noActionOutput)

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
                        |> Result.andThen ((getHistoricalPlaceCount >> setHistoricalPlacesUnchanged) noActionOutput)
                        |> Result.andThen ((getStormSurgeRdTotMile >> protectStormSurgeRdTotMile) noActionOutput)

                ( Ok Strategies.BeachNourishment, False ) ->
                    output
                        |> (.rareSpeciesHabitat >> getRareSpeciesPresence >> gainRareSpeciesHabitat) noActionOutput
                        |> Result.andThen (setBeachArea <| Details.positiveAcreageImpact zoiTotal details)

                -- Managed Relocation & Retrofitting Assets                
                ( Ok Strategies.ManagedRelocation, True ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getStormSurgeRdTotMile >> protectStormSurgeRdTotMile) noActionOutput)

                ( Ok Strategies.ManagedRelocation, False ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getStormSurgeRdTotMile >> protectStormSurgeRdTotMile) noActionOutput)

                ( Ok Strategies.RetrofittingAssets, True ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)


                ( Ok Strategies.RetrofittingAssets, False ) ->
                    output
                        |> (getCriticalFacilityCount >> protectCriticalFacilities) noActionOutput
                        |> Result.andThen ((.publicBuildingValue >> getMonetaryValue >> protectPublicBldgValue) noActionOutput)
                        |> Result.andThen ((.privateBuildingValue >> getMonetaryValue >> protectPrivateBldgValue) noActionOutput)
                        |> Result.andThen ((getHistoricalPlaceCount >> protectHistoricalPlaces) noActionOutput)
                        |> Result.andThen ((getRdTotMile >> protectRdTotMile) noActionOutput)

                -- End of Managed Relocation & Retrofitting Assets

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


{-| Count the number of historical places being impacted as lost
-}

loseHistoricalPlacesNoNum : Count -> OutputDetails -> Result OutputError OutputDetails
loseHistoricalPlacesNoNum hPlaces output =
    if hPlaces == 0 then
        Ok output
    else 
        abs hPlaces
            |> HistoricalPlacesLostNoNum
            |> \result -> Ok { output | historicalPlaces = result }
loseHistoricalPlaces : Count -> OutputDetails -> Result OutputError OutputDetails
loseHistoricalPlaces hPlaces output =
    if hPlaces == 0 then
        Ok output
    else 
        abs hPlaces
            |> HistoricalPlacesLost
            |> \result -> Ok { output | historicalPlaces = result }


{-| Protect historical places from No Action output 
-}
protectHistoricalPlaces : Count -> OutputDetails -> Result OutputError OutputDetails
protectHistoricalPlaces hPlaces output =
    if hPlaces == 0 then
        Ok output
    else
        abs hPlaces
            |> HistoricalPlacesProtected
            |> \result -> Ok { output | historicalPlaces = result }


setHistoricalPlacesUnchanged : Count -> OutputDetails -> Result OutputError OutputDetails
setHistoricalPlacesUnchanged hPlaces output =
    Ok { output | historicalPlaces = HistoricalPlacesUnchanged hPlaces }


flagHistoricalPlacesAsPresent : Count -> OutputDetails -> Result OutputError OutputDetails
flagHistoricalPlacesAsPresent hPlaces output =
    if hPlaces == 0 then
        Ok output
    else
        abs hPlaces
            |> HistoricalPlacesPresent
            |> \result -> Ok { output | historicalPlaces = result }


relocateHistoricalPlaces : Count -> OutputDetails -> Result OutputError OutputDetails
relocateHistoricalPlaces hPlaces output =
    if hPlaces == 0 then
        Ok output
    else
        abs hPlaces
            |> HistoricalPlacesRelocated
            |> \result -> Ok { output | historicalPlaces = result }


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


--===================erosionRdTot================================
loseRdTotMile : Mile -> OutputDetails -> Result OutputError OutputDetails
loseRdTotMile mile output =
    if mile == 0 then
        Ok { output | rdTotMileChange = MileUnchanged }
    else
        Ok { output | rdTotMileChange = MileLost <| abs mile }


protectRdTotMile : Mile -> OutputDetails -> Result OutputError OutputDetails
protectRdTotMile mile output =
    if mile == 0 then
        Ok { output | rdTotMileChange = MileUnchanged }
    else
        Ok { output | rdTotMileChange = MileProtected <| abs mile }


-- setRdTotMileUnchanged : OutputDetails -> Result OutputError OutputDetails
-- setRdTotMileUnchanged output =
--     Ok { output | rdTotMileChange  = MileUnchanged }


-- flagRdTotMileAsPresent : Mile -> OutputDetails -> Result OutputError OutputDetails
-- flagRdTotMileAsPresent mile output =
--     if mile == 0 then
--         Ok { output | rdTotMileChange = MileUnchanged }
--     else
--         Ok { output | rdTotMileChange = MilePresent <| abs mile }


-- relocateRdTotMile : Mile -> OutputDetails -> Result OutputError OutputDetails
-- relocateRdTotMile mile output =
--     if mile == 0 then
--         Ok { output | rdTotMileChange = MileUnchanged }
--     else
--         Ok { output | rdTotMileChange = MileRelocated <| abs mile }


-- setRdTotMile : Mile -> OutputDetails -> Result OutputError OutputDetails
-- setRdTotMile mile output =
--     if mile > 0 then
--         Ok { output | rdTotMileChange = MileLost <| abs mile }
--     else if mile < 0 then
--         Ok { output | rdTotMileChange = MileLost <| abs mile }
--     else
--         Ok { output | rdTotMileChange = MileUnchanged }


-- copyRdTotMile : MileResult -> OutputDetails -> Result OutputError OutputDetails
-- copyRdTotMile result output =
--     Ok { output | rdTotMileChange = result }

--==================================================================


--===================stormSurgeRdTot================================
loseStormSurgeRdTotMile : Mile -> OutputDetails -> Result OutputError OutputDetails
loseStormSurgeRdTotMile mile output =
    if mile == 0 then
        Ok { output | stormSurgeRdTotMileChange = MileUnchanged }
    else
        Ok { output | stormSurgeRdTotMileChange = MileLost <| abs mile }


protectStormSurgeRdTotMile : Mile -> OutputDetails -> Result OutputError OutputDetails
protectStormSurgeRdTotMile mile output =
    if mile == 0 then
        Ok { output | stormSurgeRdTotMileChange = MileUnchanged }
    else
        Ok { output | stormSurgeRdTotMileChange = MileProtected <| abs mile }


-- setStormSurgeRdTotMileUnchanged : Mile -> OutputDetails -> Result OutputError OutputDetails
-- setStormSurgeRdTotMileUnchanged mile output =
--     Ok { output | stormSurgeRdTotMileChange  = MileUnchanged }


-- flagStormSurgeRdTotMileAsPresent : Mile -> OutputDetails -> Result OutputError OutputDetails
-- flagStormSurgeRdTotMileAsPresent mile output =
--     if mile == 0 then
--         Ok { output | stormSurgeRdTotMileChange = MileUnchanged }
--     else
--         Ok { output | stormSurgeRdTotMileChange = MilePresent <| abs mile }


-- relocateStormSurgeRdTotMile : Mile -> OutputDetails -> Result OutputError OutputDetails
-- relocateStormSurgeRdTotMile mile output =
--     if mile == 0 then
--         Ok { output | stormSurgeRdTotMileChange = MileUnchanged }
--     else
--         Ok { output | stormSurgeRdTotMileChange = MileRelocated <| abs mile }


-- setStormSurgeRdTotMile : Mile -> OutputDetails -> Result OutputError OutputDetails
-- setStormSurgeRdTotMile mile output =
--     if mile > 0 then
--         Ok { output | stormSurgeRdTotMileChange = MileLost <| abs mile }
--     else if mile < 0 then
--         Ok { output | stormSurgeRdTotMileChange = MileLost <| abs mile }
--     else
--         Ok { output | stormSurgeRdTotMileChange = MileUnchanged }


-- copyStormSurgeRdTotMile : MileResult -> OutputDetails -> Result OutputError OutputDetails
-- copyStormSurgeRdTotMile result output =
--     Ok { output | stormSurgeRdTotMileChange = result }

--======================================================


--===================sLRRdTot================================
loseSLRRdTotMile : Mile -> OutputDetails -> Result OutputError OutputDetails
loseSLRRdTotMile mile output =
    if mile == 0 then
        Ok { output | sLRRdTotMileChange = MileUnchanged }
    else
        Ok { output | sLRRdTotMileChange = MileLost <| abs mile }


protectSLRRdTotMile : Mile -> OutputDetails -> Result OutputError OutputDetails
protectSLRRdTotMile mile output =
    if mile == 0 then
        Ok { output | sLRRdTotMileChange = MileUnchanged }
    else
        Ok { output | sLRRdTotMileChange = MileProtected <| abs mile }
-- protectHistoricalPlaces : Count -> OutputDetails -> Result OutputError OutputDetails
-- protectHistoricalPlaces hPlaces output =
--     if hPlaces == 0 then
--         Ok output
--     else
--         abs hPlaces
--             |> HistoricalPlacesProtected
--             |> \result -> Ok { output | historicalPlaces = result }


-- setSLRRdTotMileUnchanged : OutputDetails -> Result OutputError OutputDetails
-- setSLRRdTotMileUnchanged output =
--     Ok { output | sLRRdTotMileChange  = MileUnchanged }


-- flagSLRRdTotMileAsPresent : Mile -> OutputDetails -> Result OutputError OutputDetails
-- flagSLRRdTotMileAsPresent mile output =
--     if mile == 0 then
--         Ok { output | sLRRdTotMileChange = MileUnchanged }
--     else
--         Ok { output | sLRRdTotMileChange = MilePresent <| abs mile }


-- relocateSLRRdTotMile : Mile -> OutputDetails -> Result OutputError OutputDetails
-- relocateSLRRdTotMile mile output =
--     if mile == 0 then
--         Ok { output | sLRRdTotMileChange = MileUnchanged }
--     else
--         Ok { output | sLRRdTotMileChange = MileRelocated <| abs mile }


-- setSLRRdTotMile : Mile -> OutputDetails -> Result OutputError OutputDetails
-- setSLRRdTotMile mile output =
--     if mile > 0 then
--         Ok { output | sLRRdTotMileChange = MileLost <| abs mile }
--     else if mile < 0 then
--         Ok { output | sLRRdTotMileChange = MileLost <| abs mile }
--     else
--         Ok { output | sLRRdTotMileChange = MileUnchanged }


-- copySLRRdTotMile : MileResult -> OutputDetails -> Result OutputError OutputDetails
-- copySLRRdTotMile result output =
--     Ok { output | sLRRdTotMileChange = result }

--======================================================

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