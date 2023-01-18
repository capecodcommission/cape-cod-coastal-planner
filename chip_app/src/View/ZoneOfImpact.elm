module View.ZoneOfImpact exposing (..)

import Types exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import View.Helpers exposing (title, adjustOnHeight)
import Styles exposing (..)



textLayoutSpacing : Device -> Float
textLayoutSpacing device =
    adjustOnHeight ( 25, 40 ) device


imageHeight : Device -> Float
imageHeight device =
    adjustOnHeight ( 150, 235 ) device


view : Device -> String -> ZoneOfImpact -> Element MainStyles Variations Msg
view device zoiPath zoi  =
    column NoStyle
        [ height fill, verticalSpread ]
        [ el NoStyle [ height fill, center, paddingXY 0 25 ] <| 
            decorativeImage NoStyle [ height (px <| imageHeight device), verticalCenter] { src = zoiPath }
            , textLayout (Zoi ZoiText)  
                [ height fill, verticalCenter, spacing <| textLayoutSpacing device , paddingXY 32 0 ]
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
            , column (Zoi ZoiStat) [ height fill, center, verticalCenter, spacingXY 0 5 ] 
                    [ el NoStyle [ alignBottom ] <|
                        text ("Selections: " ++ String.fromInt zoi.numSelected ++ " of 8")
                        , el NoStyle [ alignTop ] <|
                            text ("Shoreline Extent: " ++ String.fromInt zoi.beachLengths.total ++ " ft.")
                    ]
            , footer (Sidebar SidebarFooter) [ alignBottom, height (px 90) ] <|
                    row NoStyle
                        [ verticalCenter
                        , spread
                        , width fill
                        , height fill
                        , paddingXY 32 0
                        ]
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
