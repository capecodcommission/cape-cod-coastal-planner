module View.BaselineInfo exposing (..)

import Dict exposing (Dict)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Element.Input as Input exposing (..)
import RemoteData exposing (RemoteData(..))
import Graphqelm.Http exposing (Error(..))
import String.Extra as SEx
import Message exposing (..)
import Types exposing (..)
import Styles exposing (..)
import View.Helpers exposing (..)


type alias BaselineInformation =
    Dict String BaselineInfo


view : String -> GqlData (Maybe BaselineInfo) -> Element MainStyles Variations Msg
view closePath response =
    case response of
        NotAsked ->
            button (Baseline BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , onClick GetBaselineInfo
                , title "Baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"

        Loading ->
            button (Baseline BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , title "Loading baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"

        Success (Just info) ->
            column NoStyle
                []
                [ button (Baseline BaselineInfoBtn)
                    [ height (px 42)
                    , width (px 42)
                    , title "Baseline information for the selected Shoreline Location"
                    ]
                  <|
                    Element.text "i"
                , modal (Baseline BaselineInfoModalBg)
                    [ height fill
                    , width fill
                    , padding 10
                    ]
                  <|
                    el (Baseline BaselineInfoModal)
                        [ width (px 900)
                        , height (px 700)
                        , center
                        , verticalCenter
                        ]
                    <|
                        column NoStyle
                            []
                            [ header (Baseline BaselineInfoHeader)
                                [ width fill, height (px 225) ]
                              <|
                                (column (Baseline BaselineInfoHeader)
                                    [ alignBottom
                                    , height fill
                                    , width fill
                                    , paddingXY 40 10
                                    , spacingXY 0 5
                                    ]
                                    [ h6 (Headings H6) [ width fill ] <| Element.text "BASELINE LOCATION INFORMATION"
                                    , h1 (Headings H3) [ width fill, height (px 65) ] <| Element.text info.name
                                    ]
                                    |> within
                                        [ image CloseIcon
                                            [ alignRight
                                            , moveDown 15
                                            , moveLeft 15
                                            , title "Close baseline information"
                                            , onClick CloseBaselineInfo
                                            ]
                                            { src = closePath, caption = "Close Modal" }
                                        ]
                                )
                            ]
                ]

        Success Nothing ->
            button (Baseline BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , title "Baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"

        Failure err ->
            button (Baseline BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , title "Baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"
