module View.PlanningLayers exposing (..)

import Types exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import View.Helpers exposing (title, adjustOnHeight)
import Styles exposing (..)
import ShorelineLocation as SL


textLayoutSpacing : Device -> Float
textLayoutSpacing device =
    adjustOnHeight ( 25, 40 ) device


imageHeight : Device -> Float
imageHeight device =
    adjustOnHeight ( 150, 235 ) device


view : Device -> Paths -> Element MainStyles Variations Msg
view device paths =
  column NoStyle
    [ height fill, verticalSpread ]
    [ row NoStyle 
        [ verticalCenter, spread, width fill, height fill, paddingXY 32 15 ]
        [ header (Sidebar SidebarHeader) 
            [ height (px 72), width fill ] 
            <| h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text "General Planning Layers")
        , decorativeImage (Sidebar SidebarLeftToggle) 
            [ center, verticalCenter, height (px 72) ] 
            { src = paths.downArrow }   
        ]
    , row NoStyle 
        [ verticalCenter, spread, width fill, height fill, paddingXY 32 15 ]
        [ header (Sidebar SidebarHeader) 
            [ height (px 72), width fill ] 
            <| h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text "Sea Level Rise")
        , decorativeImage (Sidebar SidebarLeftToggle) 
            [ center, verticalCenter, height (px 72) ] 
            { src = paths.downArrow }   
        ]
    , row NoStyle 
        [ verticalCenter, spread, width fill, height fill, paddingXY 32 15 ]
        [ header (Sidebar SidebarHeader) 
            [ height (px 72), width fill ] 
            <| h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text "Coastal Erosion")
        , decorativeImage (Sidebar SidebarLeftToggle) 
            [ center, verticalCenter, height (px 72) ] 
            { src = paths.downArrow }   
        ]
    , row NoStyle 
        [ verticalCenter, spread, width fill, height fill, paddingXY 32 15 ]
        [ header (Sidebar SidebarHeader) 
            [ height (px 72), width fill ] 
            <| h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text "Flooding")
        , decorativeImage (Sidebar SidebarLeftToggle) 
            [ center, verticalCenter, height (px 72) ] 
            { src = paths.downArrow }   
        ]
    , row NoStyle 
        [ verticalCenter, spread, width fill, height fill, paddingXY 32 15 ]
        [ header (Sidebar SidebarHeader) 
            [ height (px 72), width fill ] 
            <| h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text "Storms")
        , decorativeImage (Sidebar SidebarLeftToggle) 
            [ center, verticalCenter, height (px 72) ] 
            { src = paths.downArrow }   
        ]
    , row NoStyle 
        [ verticalCenter, spread, width fill, height fill, paddingXY 32 15 ]
        [ header (Sidebar SidebarHeader) 
            [ height (px 72), width fill ] <| 
                h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text "Vulnerability Ribbon")
        , decorativeImage (Sidebar SidebarLeftToggle) 
            [ center, verticalCenter, height (px 72) ] 
            { src = paths.downArrow }   
        ]
    ]
