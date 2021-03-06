module View.StrategyResults exposing (..)

import Message exposing (..)
import Element exposing (..)
import Element.Attributes as Attr exposing (..)
import Element.Events exposing (..)
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (Locale, usLocale)
import Graphics.Erosion exposing (erosionIcon, erosionIconConfig)
import Graphics.SeaLevelRise exposing (seaLevelRiseIcon, seaLevelRiseIconConfig)
import Graphics.StormSurge exposing (stormSurgeIcon, stormSurgeIconConfig)
import View.Helpers exposing (title, parseErrors, parseHttpError)
import Styles exposing (..)
import AdaptationStrategy.CoastalHazards as Hazards
import AdaptationStrategy.Impacts as Impacts
import AdaptationOutput exposing (..)


view : Result OutputError AdaptationOutput -> Element MainStyles Variations Msg
view result =
    column NoStyle
        [ height fill, width fill ]
        ( case result of
            Ok NotCalculated ->
                [ el NoStyle [ height fill ] empty, footerView ]

            Ok CalculatingOutput ->
                [ el NoStyle [ height fill ] empty, footerView ]

            Ok (OnlyNoAction output) ->
                [ 
                resultsMainContent output
                , footerView 
                ]

            Ok (ShowNoAction noActionOutput strategyOutput) ->
                [ toggleToStrategy ( noActionOutput, strategyOutput )
                , resultsHeader noActionOutput
                , resultsMainContent noActionOutput
                , footerView
                ]

            Ok (ShowStrategy noActionOutput strategyOutput) ->
                [ toggleToNoAction ( noActionOutput, strategyOutput )
                , resultsHeader strategyOutput
                , resultsMainContent strategyOutput
                , footerView
                ]

            Err (BadInput err) ->
                [ errorView
                    "Bad Input"
                    [ err ]
                , footerView 
                ]

            Err (DetailsGHttpError ghttpError) ->
                [ parseErrors ghttpError
                    |> List.head
                    |> Maybe.withDefault ("GraphQL Error", "Could not fetch Stratgy Details from GraphQL API")
                    |> (\(errTitle, errMsg) -> errorView errTitle [ errMsg ])
                , footerView
                ]

            Err (HexHttpError httpError) ->
                [ parseHttpError httpError
                    |> (\(errTitle, errMsg) -> errorView errTitle [ errMsg ])
                , footerView 
                ]

            Err (CalculationError err) ->
                [ errorView
                    "Failed to calculate output."
                    [ err ]
                , footerView 
                ]
        )
    

toggleToStrategy : ( OutputDetails, OutputDetails ) -> Element MainStyles Variations Msg
toggleToStrategy (( noActionOutput, strategyOutput ) as output) =
    row NoStyle [ height (px 35) ]
        [ el (ShowOutput OutputToggleLbl) 
            [ width (percent 35) ] <|
                el NoStyle [verticalCenter, center] (text "NO ACTION")
        , button (ShowOutput OutputToggleBtn)
            [ onClick <| ShowStrategyOutput output 
            , width (percent 65)
            ] <| 
            el NoStyle [] (text <| String.toUpper strategyOutput.name)
        ]


toggleToNoAction : ( OutputDetails, OutputDetails ) -> Element MainStyles Variations Msg
toggleToNoAction (( noActionOutput, strategyOutput ) as output) =
    row NoStyle [ height (px 35) ]
        [ button (ShowOutput OutputToggleBtn)
            [ onClick <| ShowNoActionOutput output 
            , width (percent 35)
            ] <| 
            el NoStyle [] (text "NO ACTION")
        , el (ShowOutput OutputToggleLbl)
            [ width (percent 65) ] <| 
                el NoStyle [verticalCenter, center] (text <| String.toUpper strategyOutput.name)
        ]


resultsHeader : OutputDetails -> Element MainStyles Variations Msg
resultsHeader output =
    let
        scaleDisabled a = vary Disabled (not <| Impacts.hasScale a output.scales)
    in
    header (ShowOutput OutputHeader) [ height (px 60) ] <|
        column NoStyle [ height fill, width fill, paddingLeft 25, paddingRight 25, paddingTop 15, paddingBottom 10 ]
            [ row NoStyle 
                [ height (percent 45), width fill, spacingXY 15 0 ]
                [ el (ShowOutput OutputDivider) [ width (px 90), verticalCenter ] <|
                    paragraph NoStyle [] [ text "SELECTED STRATEGY" ]
                , h5 (Headings H5) [ verticalCenter ] <|
                    ( el NoStyle [] (text output.name)
                        |> within [ infoIconView output.description ]
                    )
                ]
            ]


resultsMainContent : OutputDetails -> Element MainStyles Variations Msg
resultsMainContent output =
    column NoStyle [ height fill ]
        [ scenarioGeneralInfoView output
        , column NoStyle [ paddingXY 20 0 ]
            [ h6 (ShowOutput OutputH6Bold) [] <| text "SCENARIO OUTPUTS"
            , paragraph (ShowOutput OutputSmallItalic) [] 
                [ text "All outputs are relative to the user"
                , text " taking no action within the planning area." 
                ]
            ]
        , if output.name == "No Action" 
            then
            row NoStyle [ paddingXY 40 20, spread, height fill ]
                [ monetaryResultView "Public Building" "Value" output.publicBuildingValue (Just "In the No Action scenario, Public Building Value represents the anticipated change in public building value due to sea level rise and erosion over the 40-year planning horizon, or the cost of damage due to a one-time storm surge event.")
                , monetaryResultView "Private Shoreline" "Land Value" output.privateLandValue (Just "In the No Action scenario, Private Shoreline Value represents the anticipated change in private shoreline land value due to sea level rise, erosion, or storm surge.")
                , monetaryResultView "Private Building" "Value" output.privateBuildingValue (Just "In the No Action scenario, Private Building Value represents the anticipated change in private shoreline building value (within 100 feet of the coast) due to sea level rise, erosion, or storm surge.")
                ] 
            else
            row NoStyle [ paddingXY 40 20, spread, height fill ]
                [ monetaryResultView "Public Building" "Value" output.publicBuildingValue (Just "Public Building Value is the anticipated gain or loss in municipally-owned buildings' value that occurs due to adaptation strategy implementation.")
                , monetaryResultView "Private Shoreline" "Land Value" output.privateLandValue (Just "Private Shoreline Land Value is the anticipated gain or loss in private shoreline land value that occurs due to adaptation strategy implementation.")
                , monetaryResultView "Private Building" "Value" output.privateBuildingValue (Just "Private Shoreline Building Value is the anticipated gain or loss in private shoreline building value (within 100 feet of the coast) that occurs due to adaptation strategy implementation.")
                ]
        , if output.name == "No Action" 
            then
            row NoStyle [ spread, height fill, width fill ]
                [ acreageResultView "Salt Marsh Change" output.saltMarshChange "SMNA"
                , acreageResultView "Beach Area Change" output.beachAreaChange "BNA"
                ]
            else
            row NoStyle [ spread, height fill, width fill ]
                [ acreageResultView "Salt Marsh Change" output.saltMarshChange "SM"
                , acreageResultView "Beach Area Change" output.beachAreaChange "B"
                ]
        , if output.name == "No Action" 
            then
            row NoStyle [ spread, height fill, width fill ]
                [ criticalFacilitiesView output.criticalFacilities "NA"
                , rareSpeciesHabitatView output.rareSpeciesHabitat "NA"
                ]
            else
            row NoStyle [ spread, height fill, width fill ]
                [ criticalFacilitiesView output.criticalFacilities "ST"
                , rareSpeciesHabitatView output.rareSpeciesHabitat "ST"
                ]
        ]


scenarioGeneralInfoView : OutputDetails -> Element MainStyles Variations Msg
scenarioGeneralInfoView output =
    let
        renderDetails a b c d =
            row NoStyle [ spacingXY 8 0 ] <|
                case c of
                    Just cText ->
                        [ el (ShowOutput ScenarioLabel) [ verticalCenter ] (text a)
                        , el (ShowOutput ScenarioBold) [ verticalCenter ] (text b)
                        , el NoStyle [ verticalCenter ] (text cText)
                            |> within [ infoIconView d ]
                        ]

                    Nothing ->
                        [ el (ShowOutput ScenarioLabel) [ verticalCenter ] (text a)
                        , el (ShowOutput ScenarioBold) [ verticalCenter ] (text b)
                            |> within [ infoIconView d ]
                        ]
                
    in
    row NoStyle [ height (px 125), paddingXY 25 30 ]
        [ el (ShowOutput OutputDivider) [ width (px 180), height fill, paddingRight 10 ] <|
            row NoStyle [height fill, spacingXY 8 0]
                [ el NoStyle [ center, verticalCenter, height fill  ] <|
                    ( case Hazards.toTypeFromStr output.hazard of
                        Ok Hazards.Erosion ->
                            erosionIconConfig |> erosionIcon |> html 

                        Ok Hazards.SeaLevelRise ->
                            seaLevelRiseIconConfig |> seaLevelRiseIcon |> html

                        Ok Hazards.StormSurge ->
                            stormSurgeIconConfig |> stormSurgeIcon |> html

                        Err _ ->
                            empty
                    )
                , column NoStyle [ width fill, verticalCenter ]
                    [ el NoStyle [] <| paragraph (ShowOutput OutputAddresses) [] [ text "SCENARIO ADDRESSES" ]
                    , el NoStyle [] <| paragraph (ShowOutput OutputHazard) [] [ text output.hazard ]
                    ]
                ]
        , column NoStyle [ paddingLeft 15, spacingXY 0 4 ]
            [ renderDetails "LOCATION:" output.location (Just "area") Nothing
            , renderDetails "DURATION:" output.duration Nothing (Just "The Cape Cod Coastal Planner's planning horizon for sea level rise is 40 years, in alignment with the 2-feet of predicted sea level rise factored into the MA Municipal Vulnerability Planning Process. The horizon for erosion also reflects 40 years, using the long-term erosion rates calculated in the MA Shoreline Change project. Storm surge is considered a one-time, immediate-impact event.")
            , renderDetails "SCENARIO SIZE:" (toString output.scenarioSize) (Just "linear ft.") (Just "The size of the scenario is the length of shoreline selected by the user, with Zones of Impact ranging from 500 to 4,000 contiguous feet.")
            ]
        ]


monetaryResultView : String -> String -> MonetaryResult -> Maybe String -> Element MainStyles Variations Msg
monetaryResultView lblPart1 lblPart2 result infoText =
    let
        render a ( b, c ) d e f =
            column NoStyle [ spacing 5, verticalCenter ]
                [ el (ShowOutput OutputValue) [ center, f ] <| text a 
                , el (ShowOutput OutputValueLbl) [ center, f ] (text b)
                    |> within [ infoIconView infoText ]
                , h6 (ShowOutput OutputH6Bold) [ center ] <| text d
                , h6 (ShowOutput OutputH6Bold) [ center ] <| text e
                ]
    in
    case result of
        ValueUnchanged ->
            render "--" ("NO CHANGE", Just "...") lblPart1 lblPart2 (vary Secondary False)
            
        ValueNoLongerPresent ->
            render "--" ("NO LONGER PRESENT", Just "...") lblPart1 lblPart2 (vary Secondary False)

        ValueTransferred transfer ->
            render (abbreviateMonetaryValue transfer) ("TRANSFERRED", Just "...") lblPart1 lblPart2 (vary Tertiary True)

        ValueLoss lost ->
            render (abbreviateMonetaryValue lost) ("LOST", Just "...") lblPart1 lblPart2 (vary Secondary True)

        ValueProtected protected ->
            render (abbreviateMonetaryValue protected) ("PROTECTED", Just "...") lblPart1 lblPart2 (vary Tertiary True)


acreageResultView : String -> AcreageResult -> String -> Element MainStyles Variations Msg
acreageResultView lbl result metric =
    let
        render a ( b, c ) d e =
            column NoStyle [ spacing 5, width fill, verticalCenter ]
                [ h6 (ShowOutput OutputH6Bold) [ center ] <| text d
                , el (ShowOutput OutputValueLbl) [ center, e ] (text b)
                    |> within [ infoIconView c ]
                , el (ShowOutput OutputValue) [ center, e ] <| text a
                ]
    in
    case (result, metric) of
        (AcreageUnchanged, "SM") ->
            render "--" ( "NO CHANGE", Just "There is no change in salt marsh acres due to the strategy implementation or hazard." ) lbl (vary Secondary False)
        
        (AcreageUnchanged, "B") ->
            render "--" ( "NO CHANGE", Just "There is no change in beach acres to strategy implementation or hazard." ) lbl (vary Secondary False)

        (AcreageLost loss, "SM") ->
            render (abbreviateAcreageValue loss) ( "ACRES LOST", Just "Relative to No Action, there is an anticipated loss in salt marsh acres due to the hazard and/or loss related to strategy implementation." ) lbl (vary Secondary True)

        (AcreageLost loss, "B") ->
            render (abbreviateAcreageValue loss) ( "ACRES LOST", Just "Relative to No Action, there is an anticipated loss in beach acres due to strategy implementation and/or loss caused by the hazard." ) lbl (vary Secondary True)

        (AcreageGained gain, "SM") ->
            render (abbreviateAcreageValue gain) ( "ACRES GAINED", Just "Relative to No Action, there is an anticipated gain in salt marsh acres due to strategy implementation and/or avoiding loss caused by the hazard." ) lbl (vary Tertiary True)

        (AcreageGained gain, "B") ->
            render (abbreviateAcreageValue gain) ( "ACRES GAINED", Just "Relative to No Action, there is an anticipated gain in beach acres due to strategy implementation and/or avoiding loss caused by the hazard." ) lbl (vary Tertiary True)

        (AcreageUnchanged, "SMNA") ->
            render "--" ( "NO CHANGE", Just "There is no change in salt marsh acres due to the strategy implementation or hazard." ) lbl (vary Secondary False)
        
        (AcreageUnchanged, "BNA") ->
            render "--" ( "NO CHANGE", Just "There is no change in beach acres to strategy implementation or hazard." ) lbl (vary Secondary False)

        (AcreageLost loss, "SMNA") ->
            render (abbreviateAcreageValue loss) ( "ACRES LOST", Just "In the No Action scenario, there is an anticipated loss in salt marsh acres due to the hazard and/or loss related to strategy implementation." ) lbl (vary Secondary True)

        (AcreageLost loss, "BNA") ->
            render (abbreviateAcreageValue loss) ( "ACRES LOST", Just "In the No Action scenario, there is an anticipated loss in beach acres due to loss caused by the hazard." ) lbl (vary Secondary True)

        (AcreageGained gain, "SMNA") ->
            render (abbreviateAcreageValue gain) ( "ACRES GAINED", Just "In the No Action scenario, there is an anticipated gain in salt marsh acres due to avoiding loss caused by the hazard." ) lbl (vary Tertiary True)

        (AcreageGained gain, "BNA") ->
            render (abbreviateAcreageValue gain) ( "ACRES GAINED", Just "In the No Action scenario, there is an anticipated gain in beach acres due to avoiding loss caused by the hazard." ) lbl (vary Tertiary True)
        (_, _) ->
            render "--" ( "NO CHANGE", Just "..." ) lbl (vary Secondary False)


criticalFacilitiesView : CriticalFacilities -> String -> Element MainStyles Variations Msg
criticalFacilitiesView facilities strat =
    let
        render a b c d =
            column (ShowOutput OutputValueBox)
                [ moveRight 15
                , height (px 58)
                , width (px 58) 
                , center
                , verticalCenter
                , c
                ]
                [ el NoStyle [] <| text a
                , el NoStyle [] <| b
                ] |> within [ infoIconView (Just d) ]
    in
    row NoStyle [ height fill, width fill, center, verticalCenter ]
        [ column (ShowOutput OutputDivider) [ spacing 5, paddingRight 15 ]
            [ el (ShowOutput OutputH6Bold) [ alignRight ] <| text "Critical"
            , el (ShowOutput OutputH6Bold) [ alignRight ] <| text "Facilities"
            ]
        , ( case (facilities, strat) of
            (FacilitiesUnchanged num, "NA") ->
                render 
                    "--" empty (vary Secondary False) "Critical facilities are identified by towns through their hazard mitigation planning process, and indicate facilities where even a slight chance of flooding is too great a threat (e.g. police stations and hospitals)."

            (FacilitiesUnchanged num, "ST") ->
                render 
                    "--" empty (vary Secondary False) "Critical facilities are identified by towns through their hazard mitigation planning process, and indicate facilities where even a slight chance of flooding is too great a threat (e.g. police stations and hospitals)."

            (FacilitiesLost num, "NA") ->
                render (toString num) (text "LOST") (vary Secondary True) "Critical facilities threatened by coastal hazards are impacted in a No Action scenario."
            
            (FacilitiesLost num, "ST") ->
                render (toString num) (text "LOST") (vary Secondary True) "Critical facilities threatened by coastal hazards are impacted in a No Action scenario due to strategy implementation."

            (FacilitiesProtected num, "NA") ->
                render (toString num) (text "PROT.") (vary Tertiary True) "Critical facilities with anticipated hazard-induced impacts in a No Action scenario are now protected due to strategy implementation."

            (FacilitiesProtected num, "ST") ->
                render (toString num) (text "PROT.") (vary Tertiary True) "Critical facilities with anticipated hazard-induced impacts in a No Action scenario are now protected due to strategy implementation."    

            (FacilitiesPresent num, "NA") ->
                render (toString num) empty (vary Secondary False) "Critical facilities are identified by towns through their hazard mitigation planning process, and indicate facilities where even a slight chance of flooding is too great a threat (e.g. police stations and hospitals)."

            (FacilitiesPresent num, "ST") ->
                render (toString num) empty (vary Secondary False) "Critical facilities are identified by towns through their hazard mitigation planning process, and indicate facilities where even a slight chance of flooding is too great a threat (e.g. police stations and hospitals)."

            (FacilitiesRelocated num, "NA") ->
                render (toString num) (text "RELOC.") (vary Tertiary True) "Critical facilities are identified by towns through their hazard mitigation planning process, and indicate facilities where even a slight chance of flooding is too great a threat (e.g. police stations and hospitals)."

            (FacilitiesRelocated num, "ST") ->
                render (toString num) (text "RELOC.") (vary Tertiary True) "Critical facilities are identified by towns through their hazard mitigation planning process, and indicate facilities where even a slight chance of flooding is too great a threat (e.g. police stations and hospitals)."

            (_, _) ->
                render (toString 0) (text "...") (vary Secondary True) "..."
          )
        ]


rareSpeciesHabitatView : RareSpeciesHabitat -> String -> Element MainStyles Variations Msg
rareSpeciesHabitatView habitat strat =
    let
        render a b c =
            column (ShowOutput OutputValueBox) 
                [ moveRight 15
                , height (px 58)
                , width (px 58) 
                , center
                , verticalCenter
                , b
                ] 
                [ el NoStyle [] <| text a ] |> within [ infoIconView (Just c) ]
    in
    row NoStyle [ height fill, width fill, center, verticalCenter ]
        [ column (ShowOutput OutputDivider) [ spacing 5, paddingRight 15 ]
            [ el (ShowOutput OutputH6Bold) [ alignRight ] <| text "Rare Species"
            , el (ShowOutput OutputH6Bold) [ alignRight ] <| text "Habitat"
            ]
        , ( case (habitat, strat) of
            (HabitatUnchanged, "ST") ->
                render "--" (vary Secondary False) "Rare Species Habitat is protected under Massachusetts law, and provides habitat to plant or animal species listed as Endangered, Threatened, or Special Concern. This output indicates if Rare Species Habitat may be gained or maintained (check sign) or negatively impacted (minus sign) once a strategy is implemented. "

            (HabitatLost, "ST") ->
                render "LOSS" (vary Secondary True) "Relative to No Action, there is an anticipated loss in Rare Species Habitat due to strategy implementation and/or loss caused by the hazard."

            (HabitatGained, "ST") ->
                render "GAIN" (vary Tertiary True) "Relative to No Action, there is an anticipated gain in Rare Species Habitat due to strategy implementation and/or avoiding loss caused by the hazard."
            
            (HabitatUnchanged, "NA") ->
                render "--" (vary Secondary False) "Rare Species Habitat is protected under Massachusetts law, and provides habitat to plant or animal species listed as Endangered, Threatened, or Special Concern. This output indicates if Rare Species Habitat may be gained or maintained (check sign) or negatively impacted (minus sign) once a strategy is implemented. "

            (HabitatLost, "NA") ->
                render "LOSS" (vary Secondary True) "In the No Action scenario, there is an anticipated loss in Rare Species Habitat due to loss caused by the hazard."

            (HabitatGained, "NA") ->
                render "GAIN" (vary Tertiary True) "In the No Action scenario, there is an anticipated gain in Rare Species Habitat due to avoiding loss caused by the hazard."

            (_, _) ->
                render "Test" (vary Secondary True) "..."
          )
        ]


errorView : String -> List String -> Element MainStyles Variations Msg
errorView errTitle errMsgs =
    el NoStyle [ height fill, verticalCenter ] <|
        el NoStyle [ verticalCenter, paddingXY 15 0 ] <|
            textLayout NoStyle []
                [ paragraph NoStyle [] 
                    [ text <| "Error: " ++ errTitle ]
                , paragraph NoStyle []
                    (errMsgs |> List.intersperse " " |> List.map text)
                ]


footerView : Element MainStyles Variations Msg
footerView =
    footer (Sidebar SidebarFooter) [ alignBottom, height (px 90) ] <|
        row NoStyle
            [ spread, verticalCenter, width fill, height fill, paddingXY 32 0 ]
            [ button ActionButton
                [ onClick PickStrategy
                , width (px 175)
                , height (px 42)
                , title "Back to strategy selection"
                ] <| text "back"
            ]
    

infoIconView : Maybe String -> Element MainStyles Variations Msg
infoIconView maybeHelpText =
    case maybeHelpText of
        Just helpText ->
            circle 6 (ShowOutput OutputInfoIcon) 
                [ title helpText, alignRight, moveRight 18 ] <| 
                    el NoStyle [verticalCenter, center] (text "i")

        Nothing ->
            empty        


abbreviateAcreageValue : Float -> String
abbreviateAcreageValue num =
    format usLocale num


abbreviateMonetaryValue : Float -> String
abbreviateMonetaryValue =
    formatMonetaryValue monetaryAbbreviations


monetaryAbbreviations : List String
monetaryAbbreviations =
    [ "", "K", "M", "B" ]


formatMonetaryValue : List String -> Float -> String
formatMonetaryValue abbrs num =
    let
        result = abs num / 1000.0

        fmt abbr n = format (Locale 1 "," "." "$" abbr "$" abbr) n
    in
    case abbrs of
        [] ->
            "--"

        head :: [] ->
            if result < 1.0 then
                fmt head num
            else
                fmt head result

        head :: tail ->
            if result < 1.0 then
                fmt head num
            else
                formatMonetaryValue tail result


    