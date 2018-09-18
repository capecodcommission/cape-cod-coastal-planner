module View.ZoneOfImpact exposing (..)

import Types exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick, onMouseDown, onMouseUp)
import Styles exposing (..)


view : { config | zoneOfImpact : ZoneOfImpact } -> Element MainStyles Variations Msg
view { zoneOfImpact } =
    modal Popup
        [ id "zone-of-impact-popup"
        , height (px 200)
        , width (px 200)
        ]
    <|
        column NoStyle
            [ onMouseDown DragZoneOfImpact
            , onMouseUp DropZoneOfImpact
            ]
            [ text "Hahahahahaha"
            ]



-- case zoneOfImpact.state of
--     PopupEnabled _ ->
--         modal Popup
--             [ id "zone-of-impact-popup"
--             , height (px 200)
--             , width (px 300)
--             ]
--         <|
--             column NoStyle
--                 []
--                 [ text "Hahahahahaha"
--                 ]
--     PopupDisabled ->
--         modal NoStyle [ id "zone-of-impact-popup" ] empty
--     PopupHidden _ ->
--         modal NoStyle [ id "zone-of-impact-popup" ] empty
