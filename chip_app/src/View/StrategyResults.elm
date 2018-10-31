module View.StrategyResults exposing (..)

import Message exposing (..)
import Element exposing (..)
import Element.Attributes as Attr exposing (..)
import Element.Events exposing (..)
import View.Helpers exposing (title, parseErrors, parseHttpError)
import Styles exposing (..)
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
                [ el NoStyle [] empty, footerView ]

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

            Err (CalculationError errs) ->
                [ errorView
                    "Failed to calculate output."
                    errs
                , footerView 
                ]
        )
    


resultsHeader : OutputDetails -> Element MainStyles Variations Msg
resultsHeader output =
    header (ShowOutput OutputHeader) [ height (px 125) ] <|
        column NoStyle [ paddingXY 25 15 ]
            [ row NoStyle [ height (percent 50), width fill, spacing 15 ]
                [ el (ShowOutput OutputDivider) [ width (px 90) ] <|
                    paragraph NoStyle [] [ text "SELECTED STRATEGY" ]
                , h5 (Headings H5) [] <|
                    el NoStyle [] <| text output.name
                ]
            , row NoStyle [ height (percent 50), width fill ]
                [ empty ]
            ]


resultsMainContent : OutputDetails -> Element MainStyles Variations Msg
resultsMainContent output =
    column NoStyle [ height fill, spacing 20 ]
        [ scenarioGeneralInfoView output
        , column NoStyle [ paddingXY 20 0 ]
            [ h6 (Headings H6) [] <| text "SCENARIO OUTPUTS"
            , paragraph (ShowOutput OutputSmallItalic) [] 
                [ text "All outputs are relative to the user"
                , text " taking no action within the planning area." 
                ]
            ]
        , row NoStyle [ paddingXY 40 20, spread ]
            [ monetaryResultView "Public Building" "Value" output.publicBuildingValue
            , monetaryResultView "Private Shoreline" "Land Value" output.privateLandValue
            , monetaryResultView "Private Shoreline" "Building Value" output.privateBuildingValue
            ]
        , column NoStyle [paddingXY 20 0 ]
            [ h6 (Headings H6) [] <| text "Salt Marsh"
            , case output.saltMarshChange of
                AcreageUnchanged ->
                    el NoStyle [] <|
                        paragraph NoStyle [] 
                            [ text "Acreage unchanged" ]

                AcreageLost lost ->
                    el NoStyle [] <|
                        paragraph NoStyle []
                            [ text "Acreage lost: "
                            , text <| toString <| abs lost
                            ]

                AcreageGained gained ->
                    el NoStyle [] <|
                        paragraph NoStyle []
                            [ text "Acreage gained: "
                            , text <| toString gained
                            ]
            ]
        , column NoStyle [paddingXY 20 0]
            [ h6 (Headings H6) [] <| text "Beach Width"
            , case output.beachAreaChange of
                AcreageUnchanged ->
                    el NoStyle [] <|
                        paragraph NoStyle [] 
                            [ text "Acreage unchanged" ]

                AcreageLost lost ->
                    el NoStyle [] <|
                        paragraph NoStyle []
                            [ text "Acreage lost: "
                            , text <| toString <| abs lost
                            ]

                AcreageGained gained ->
                    el NoStyle [] <|
                        paragraph NoStyle []
                            [ text "Acreage gained: "
                            , text <| toString gained
                            ]
            ]
        ]


scenarioGeneralInfoView : OutputDetails -> Element MainStyles Variations Msg
scenarioGeneralInfoView output =
    let
        renderDetails a b c =
            row NoStyle [ spacingXY 8 0 ]
                [ el NoStyle [] <| text a
                , el NoStyle [] <| text b
                , el NoStyle [] <| text c
                ]
    in
    
    row NoStyle [ height (px 125), paddingXY 25 30 ]
        [ el (ShowOutput OutputDivider) [ width (px 180) ] <|
            row NoStyle [ spacingXY 20 0 ]
                [ circle 30 (AddStrategies StrategiesDetailsCategoryCircle) [ center, verticalCenter ] empty
                , column NoStyle []
                    [ paragraph NoStyle [] [ text "SCENARIO ADDRESSES" ]
                    , el NoStyle [] <| text output.hazard
                    ]
                ]
        , column NoStyle [ paddingXY 15 0, spacingXY 0 4 ]
            [ renderDetails "LOCATION:" output.location "area"
            , renderDetails "DURATION:" output.duration ""
            , renderDetails "SCENARIO SIZE:" (toString output.scenarioSize) "linear feet"
            ]
        ]


monetaryResultView : String -> String -> MonetaryResult -> Element MainStyles Variations Msg
monetaryResultView lblPart1 lblPart2 result =
    let
        render a b c d =
            column NoStyle [ spacing 5 ]
                [ el NoStyle [ center ] <| text a 
                , el NoStyle [ center ] <| text b
                , h6 (Headings H6) [ center ] <| text c
                , h6 (Headings H6) [ center ] <| text d
                ]
    in
    case result of
        ValueUnchanged ->
            render "--" "NO CHANGE" lblPart1 lblPart2

        ValueLoss lost ->
            render (toString <| abs lost) "LOST" lblPart1 lblPart2

        ValueProtected protected ->
            render (toString protected) "PROTECTED" lblPart1 lblPart2


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
    