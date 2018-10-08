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
        [ h5 (Headings H5) [ center, paddingTop 20 ] <| text "ZONE OF IMPACT"
        , el NoStyle [ center, paddingTop 15 ] <|
            text ("# selections: " ++ toString zoi.numSelected ++ " of 8")
        , textLayout NoStyle [ spacing 35, paddingXY 15 40 ] <|
            [ paragraph NoStyle [] [ text "Each selection on the vulnerability ribbon consists of five 100 ft. segments for a total of 500 ft. per selection." ]
            , paragraph NoStyle [] [ text "You may make up to eight contiguous selections for a maximum planning area of 4000 ft." ]
            , paragraph NoStyle [] [ text "A contiguous selection may be made by selecting any one of the five segments to the immediate left or right of the existing selection." ]
            ]
        , row NoStyle
            [ spread, padding 25 ]
            [ button NoStyle [ onClick CancelZoneOfImpactSelection ] <| text "cancel"
            , button NoStyle [ onClick PickStrategy ] <| text "add strategy"
            ]
        ]
