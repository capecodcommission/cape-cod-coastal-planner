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
                [ resultsHeader output
                , resultsMainContent output
                , footerView 
                ]

            Ok (WithStrategy noActionOutput strategyOutput) ->
                [ resultsHeader strategyOutput
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
    


resultsHeader : OutputDetails -> Element MainStyles Variations Msg
resultsHeader output =
    header (ShowOutput OutputHeader) [ height (px 125) ] <|
        column NoStyle [ height fill, paddingLeft 25, paddingRight 25, paddingTop 15, paddingBottom 10 ]
            [ row NoStyle [ height (percent 45), width fill, spacingXY 15 0 ]
                [ el (ShowOutput OutputDivider) [ width (px 90), verticalCenter ] <|
                    paragraph NoStyle [] [ text "SELECTED STRATEGY" ]
                , h5 (Headings H5) [ verticalCenter ] <|
                    el NoStyle [] <| text output.name
                ]
            , row NoStyle [ height (percent 55), width fill, spread, alignBottom ]
                [ column NoStyle [center ]
                    [ el (ShowOutput OutputImpact) 
                        [ paddingXY 4 2, minWidth (px 115) ] <| text output.cost.name
                    , el NoStyle [ moveDown 3 ] <| text "COST"
                    ]
                , column NoStyle [center]
                    [ el (ShowOutput OutputImpact) 
                        [ paddingXY 4 2, minWidth (px 115) ] <| text output.lifespan.name
                    , el NoStyle [ moveDown 3 ] <| text "LIFESPAN"
                    ]
                , column NoStyle [center]
                    [ column NoStyle []
                        [ row NoStyle []
                            [ el (ShowOutput OutputMultiImpact) 
                                [ paddingRight 4 ] <| text "Site"
                            , el (ShowOutput OutputMultiImpact) 
                                [ paddingLeft 4, vary Secondary True ] <| text "Neighborhood"
                            ]
                        , row NoStyle []
                            [ el (ShowOutput OutputMultiImpact) 
                                [ paddingRight 4, vary Tertiary True ] <| text "Community"
                            , el (ShowOutput OutputMultiImpact) 
                                [ paddingLeft 4, vary Quaternary True ] <| text "Region"
                            ]
                        ]
                    , el NoStyle [ moveDown 3 ] <| text "SCALE"
                    ]
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
        , row NoStyle [ paddingXY 40 20, spread, height fill ]
            [ monetaryResultView "Public Building" "Value" output.publicBuildingValue
            , monetaryResultView "Private Shoreline" "Land Value" output.privateLandValue
            , monetaryResultView "Private Shoreline" "Building Value" output.privateBuildingValue
            ]
        , row NoStyle [ paddingXY 40 20, width fill, height fill ]
            [ acreageResultView "Salt Marsh Change" output.saltMarshChange
            , acreageResultView "Beach Area Change" output.beachAreaChange
            ]
        , row NoStyle [spread, height fill, width fill]
            [ criticalFacilitiesView output.criticalFacilities
            , rareSpeciesHabitatView output.rareSpeciesHabitat
            ]
        ]


scenarioGeneralInfoView : OutputDetails -> Element MainStyles Variations Msg
scenarioGeneralInfoView output =
    let
        renderDetails a b c =
            row NoStyle [ spacingXY 8 0 ]
                [ el (ShowOutput ScenarioLabel) [ verticalCenter ] <| text a
                , el (ShowOutput ScenarioBold) [ verticalCenter ] <| text b
                , el NoStyle [ verticalCenter ] <| text c
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
            [ renderDetails "LOCATION:" output.location "area"
            , renderDetails "DURATION:" output.duration ""
            , renderDetails "SCENARIO SIZE:" (toString output.scenarioSize) "linear ft."
            ]
        ]


monetaryResultView : String -> String -> MonetaryResult -> Element MainStyles Variations Msg
monetaryResultView lblPart1 lblPart2 result =
    let
        render a b c d e =
            column NoStyle [ spacing 5, verticalCenter ]
                [ el (ShowOutput OutputValue) [ center, e ] <| text a 
                , el (ShowOutput OutputValueLbl) [ center, e ] <| text b
                , h6 (ShowOutput OutputH6Bold) [ center ] <| text c
                , h6 (ShowOutput OutputH6Bold) [ center ] <| text d
                ]
    in
    case result of
        ValueUnchanged ->
            render "--" "NO CHANGE" lblPart1 lblPart2 (vary Secondary False)

        ValueLoss lost ->
            render (abbreviateMonetaryValue lost) "LOST" lblPart1 lblPart2 (vary Secondary True)

        ValueProtected protected ->
            render (abbreviateMonetaryValue protected) "PROTECTED" lblPart1 lblPart2 (vary Tertiary True)


acreageResultView : String -> AcreageResult -> Element MainStyles Variations Msg
acreageResultView lbl result =
    let
        render a b c d =
            column NoStyle [ spacing 5, width fill, verticalCenter ]
                [ h6 (ShowOutput OutputH6Bold) [ center ] <| text c
                , el (ShowOutput OutputValueLbl) [ center, d ] <| text b
                , el (ShowOutput OutputValue) [ center, d ] <| text a
                ]
    in
    case result of
        AcreageUnchanged ->
            render "--" "NO CHANGE" lbl (vary Secondary False)

        AcreageLost loss ->
            render (abbreviateAcreageValue loss) "ACRES LOST" lbl (vary Secondary True)

        AcreageGained gain ->
            render (abbreviateAcreageValue gain) "ACRES GAINED" lbl (vary Tertiary True)


criticalFacilitiesView : CriticalFacilities -> Element MainStyles Variations Msg
criticalFacilitiesView facilities =
    let
        render a b c =
            column (ShowOutput OutputValueBox)
                [ moveRight 15
                , height (px 58)
                , width (px 58) 
                , center
                , verticalCenter
                , c
                ]
                [ el NoStyle [] <| text a
                , el NoStyle [] <| text b
                ]
    in
    row NoStyle [ height fill, width fill, center, verticalCenter ]
        [ column (ShowOutput OutputDivider) [ spacing 5, paddingRight 15 ]
            [ el (ShowOutput OutputH6Bold) [ alignRight ] <| text "Critical"
            , el (ShowOutput OutputH6Bold) [ alignRight ] <| text "Facilities"
            ]
        , case facilities of
            FacilitiesUnchanged _ ->
                render "--" "" (vary Secondary False)

            FacilitiesLost num ->
                render (toString num) "LOST" (vary Secondary True)

            FacilitiesProtected num ->
                render (toString num) "PROT." (vary Tertiary True)

            FacilitiesPresent num ->
                render (toString num) "" (vary Secondary False)

            FacilitiesRelocated num ->
                render (toString num) "RELOC." (vary Tertiary True)
        ]


rareSpeciesHabitatView : RareSpeciesHabitat -> Element MainStyles Variations Msg
rareSpeciesHabitatView habitat =
    let
        render a b =
            column (ShowOutput OutputValueBox) 
                [ moveRight 15
                , height (px 58)
                , width (px 58) 
                , center
                , verticalCenter
                , b
                ] 
                [ el NoStyle [] <| text a ]
    in
    row NoStyle [ height fill, width fill, center, verticalCenter ]
        [ column (ShowOutput OutputDivider) [ spacing 5, paddingRight 15 ]
            [ el (ShowOutput OutputH6Bold) [ alignRight ] <| text "Rare Species"
            , el (ShowOutput OutputH6Bold) [ alignRight ] <| text "Habitat"
            ]
        , case habitat of
            HabitatUnchanged ->
                render "--" (vary Secondary False)

            HabitatLost ->
                render "LOSS" (vary Secondary True)

            HabitatGained ->
                render "GAIN" (vary Tertiary True)
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
            , button CancelButton
                [ onClick CancelPickStrategy
                , width (px 175) 
                , height (px 42)
                , title "Clear strategy selection"
                ] <| text "clear"
            ]
    

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


    