module View.ZoneOfImpact exposing (..)

import Types exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Styles exposing (..)


view : { config | zoneOfImpact : PopupState } -> Element MainStyles Variations Msg
view config =
    case config.zoneOfImpact of
        PopupEnabled ->
            modal Popup
                [ id "ZoneOfImpactPopup"
                , height (px 200)
                , width (px 300)
                ]
            <|
                column NoStyle
                    []
                    [ text "Hahahahahaha"
                    ]

        PopupDisabled ->
            empty

        PopupHidden ->
            empty
