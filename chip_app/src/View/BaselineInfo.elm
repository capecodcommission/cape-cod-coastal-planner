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


view : GqlData (Maybe BaselineInfo) -> Element MainStyles Variations Msg
view response =
    case response of
        NotAsked ->
            button (Header BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , onClick GetBaselineInfo
                , title "Baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"

        Loading ->
            button (Header BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , title "Loading baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"

        Success (Just info) ->
            button (Header BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , title "Baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"

        Success Nothing ->
            button (Header BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , title "Baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"

        Failure err ->
            button (Header BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , title "Baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"
