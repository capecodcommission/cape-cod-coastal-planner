module View.PlanningLayers exposing (..)

import Animation
import View.ToggleButton as Toggle exposing (..)
import Types exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import View.Helpers exposing (title, adjustOnHeight, renderAnimation)
import Styles exposing (..)
import ShorelineLocation as SL


textLayoutSpacing : Device -> Float
textLayoutSpacing device =
    adjustOnHeight ( 25, 40 ) device


imageHeight : Device -> Float
imageHeight device =
    adjustOnHeight ( 150, 235 ) device


view :  
    { config 
        | leftSidebarFx: Animation.State
        , leftSidebarToggleFx: Animation.State
        , slrFx : Animation.State
        , slrToggleFx : Animation.State
        , glpFx : Animation.State
        , glpToggleFx: Animation.State
    } 
    -> Device 
    -> Paths 
    -> Element MainStyles Variations Msg
view config device paths =
  column NoStyle
    [ height fill, verticalSpread ]
    [ subsection device "General Planning Layers" paths.downArrow config.glpToggleFx ToggleGLPSection
    , subsection device "Sea Level Rise" paths.downArrow config.slrToggleFx ToggleSLRSection
    , subsection device "Coastal Erosion" paths.downArrow config.leftSidebarToggleFx ToggleLeftSidebar
    , subsection device "Flooding" paths.downArrow config.leftSidebarToggleFx ToggleLeftSidebar
    , subsection device "Storms" paths.downArrow config.leftSidebarToggleFx ToggleLeftSidebar
    , subsection device "Vulnerability Ribbon" paths.downArrow config.leftSidebarToggleFx ToggleLeftSidebar
    ]

headerView : String -> Element MainStyles Variations Msg
headerView titleText =
    header (Sidebar SidebarHeader) 
        [ height (px 72), width fill ] <| 
            h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text titleText)
     

buttonView : String -> Animation.State -> Msg -> Element MainStyles Variations Msg
buttonView togglePath fx func =
    el (Sidebar SidebarLeftToggle) 
        [ height (px 72), width (px 70), onClick func ] <| 
            decorativeImage NoStyle 
                ( renderAnimation fx
                    [height (px 72), width (px 70)]
                )
                { src = togglePath } 
    

subsection : Device ->  String -> String -> Animation.State -> Msg -> Element MainStyles Variations Msg
subsection device titletext image fx func =
    column NoStyle
        [height fill, verticalSpread]
        [ row NoStyle 
            [ verticalCenter, spread, width fill, height fill, paddingXY 32 15 ]
            [ headerView titletext 
            , buttonView image fx func
            ] 
        ]