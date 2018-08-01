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


-- type alias BaselineInfoModal =
--     { data : BaselineInfoDict
--     , modal :
--     }


view : Element MainStyles Variations Msg
view =
    button (Header BaselineInfoBtn)
        [ height (px 42)
        , width (px 42)
        , onClick GetBaselineInfo
        ]
    <|
        Element.text "i"
