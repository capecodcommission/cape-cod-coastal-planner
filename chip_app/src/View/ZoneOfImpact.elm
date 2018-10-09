module View.ZoneOfImpact exposing (..)

import Types exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Styles exposing (..)


view : ZoneOfImpact -> Element MainStyles Variations Msg
view zoi =
    column NoStyle
        []
        [ (el (Zoi ZoiHeader) [ height (px 72), width fill ] <| 
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
        , textLayout (Zoi ZoiText) [ spacing 35, paddingXY 15 40 ] <|
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
                , el (Zoi ZoiCallout) [] <| text "  any one of the five segments"
                , text " to the" 
                , el (Zoi ZoiCallout) [] <| text " immediate left or right"
                , text " of the existing selection." ]
            ]
        , row NoStyle
            [ spread, padding 25 ]
            [ button NoStyle [ onClick CancelZoneOfImpactSelection ] <| text "cancel"
            , button NoStyle [ onClick PickStrategy ] <| text "add strategy"
            ]
        ]
