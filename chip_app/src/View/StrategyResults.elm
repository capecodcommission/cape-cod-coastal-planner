module View.StrategyResults exposing (..)

import Message exposing (..)
import Element exposing (..)
import Element.Attributes as Attr exposing (..)
import Element.Events exposing (..)
import View.Helpers exposing (title, parseHttpError)
import Styles exposing (..)
import AdaptationOutput exposing (AdaptationOutput(..))


view : AdaptationOutput -> Element MainStyles Variations Msg
view output =
    column NoStyle
        [ height fill, width fill ]
        ( case output of 
            CalculatingOutput ->
                [ el NoStyle [ height fill ] empty, errorFooterView ]
            
            BadInput ->
                [ errorView
                    "Missing essential calculation input."
                    [ "Please try selecting a strategy again." ]
                , errorFooterView 
                ]

            HexHttpError httpError ->
                [ parseHttpError httpError
                    |> (\(errTitle, errMsg) -> errorView errTitle [ errMsg ])
                , errorFooterView 
                ]

            CalculationError errs ->
                [ errorView
                    "Failed to calculate output."
                    errs
                , errorFooterView 
                ]

            OnlyNoAction noActionDetails ->
                [ el NoStyle [] empty ]

            WithStrategy noActionDetails strategyDetails ->
                [ el NoStyle [] empty ]

            _ ->
                [ errorView
                    "Unknown error occurred."
                    [ "Please try selecting a strategy again." ]
                , errorFooterView 
                ]
        )


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


errorFooterView : Element MainStyles Variations Msg
errorFooterView =
    footer (Sidebar SidebarFooter) [ alignBottom, height (px 90) ] <|
        row NoStyle
            [ center, verticalCenter, spacingXY 20 0, width fill, height fill ]
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
    