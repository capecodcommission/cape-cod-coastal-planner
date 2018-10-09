module View.ZoneOfImpact exposing (..)

import Types exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import View.Helpers exposing (title)
import Styles exposing (..)


view : ZoneOfImpact -> Element MainStyles Variations Msg
view zoi =
    column NoStyle
        [ height fill ]
        [ (header (Zoi ZoiHeader) [ height (px 72), width fill ] <| 
            h5 (Headings H5) [ center, verticalCenter ] (text "ZONE OF IMPACT")
          ) |> onLeft
            [ el (Zoi ZoiToggle) [ height (px 72), width (px 70) ] <| 
                el NoStyle 
                    [ center
                    , verticalCenter
                    , height fill
                    , width fill
                    , moveRight 36
                    ] <| text "T"
            ]
        , el NoStyle [ center, paddingTop 15 ] <|
            text ("# selections: " ++ toString zoi.numSelected ++ " of 8")
        , textLayout (Zoi ZoiText) 
            [ spacing 35, paddingXY 15 40, height fill ] <|
            [ paragraph NoStyle [] 
                [ text "Each selection on the vulnerability ribbon consists of"
                , el (Zoi ZoiCallout) [] <| text " five 100 ft. segments"
                , text " for a total of 500 ft. per selection." ]
            , paragraph NoStyle [] 
                [ text "You may make up to "
                , el (Zoi ZoiCallout) [] <| text " eight contiguous selections"
                , text " for a maximum planning area of 4000 ft." 
                ]
            , paragraph NoStyle [] 
                [ text "A contiguous selection may be made by selecting "
                , el (Zoi ZoiCallout) [] <| text " any one of the five segments"
                , text " to the" 
                , el (Zoi ZoiCallout) [] <| text " immediate left or right"
                , text " of the existing selection." ]
            ]
        , footer SidebarFooter [ alignBottom, height (px 90) ] <|
            row NoStyle
                [ center, verticalCenter, spacingXY 20 0, width fill, height fill ]
                [ button ActionButton 
                    [ onClick PickStrategy 
                    , width (px 175)
                    , height (px 42)
                    , title "Apply an adaptation strategy to the zone of impact"
                    ] <| text "add strategy"
                , button CancelButton 
                    [ onClick CancelZoneOfImpactSelection 
                    , width (px 175)
                    , height (px 42)
                    , title "Clear zone of impact"
                    ] <| text "cancel"
                ]
        ]
