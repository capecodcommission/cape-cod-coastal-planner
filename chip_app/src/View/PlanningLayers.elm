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
        | leftSidebarFx : Animation.State
        , leftSidebarToggleFx : Animation.State
        , slrFx : Animation.State
        , slrToggleFx : Animation.State
        , glpFx : Animation.State
        , glpToggleFx : Animation.State
        , slrOpenness : Openness
        , glpOpenness : Openness
        , ceToggleFx : Animation.State
        , ceOpenness : Openness
        , critFacClicked : Openness
    } 
    -> Device 
    -> Paths 
    -> Element MainStyles Variations Msg
view config device paths =
  column NoStyle
    [ height fill, verticalSpread ]
    [ sectionGLP device "General Planning Layers" paths.downArrow config.glpToggleFx ToggleGLPSection config.glpOpenness
    , sectionSLR device "Sea Level Rise" paths.downArrow config.slrToggleFx ToggleSLRSection config.slrOpenness config.critFacClicked
    , sectionCE device "Coastal Erosion" paths.downArrow config.ceToggleFx ToggleCESection config.ceOpenness
    -- , subsection device "Flooding" paths.downArrow config.leftSidebarToggleFx ToggleLeftSidebar
    -- , subsection device "Storms" paths.downArrow config.leftSidebarToggleFx ToggleLeftSidebar
    -- , subsection device "Vulnerability Ribbon" paths.downArrow config.leftSidebarToggleFx ToggleLeftSidebar
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

sectionSLR : Device ->  String -> String -> Animation.State -> Msg -> Openness -> Openness -> Element MainStyles Variations Msg
sectionSLR device titletext image fx func open cfClicked  =
    column NoStyle
        [height fill, verticalSpread]
        [ row NoStyle 
            [ verticalCenter, spread, width fill, height fill, paddingXY 32 0 ]
            [ headerView titletext 
            , buttonView image fx func
            ] 
        , row NoStyle
            [ width fill, paddingXY 32 0]
            [ case open of 
                Open -> 
                    textLayout NoStyle
                        [ verticalCenter, spacing 10, paddingXY 64 0 ]
                        [ paragraph NoStyle [] 
                            [ text "Toggle map layers related to the potential effects of Sea Level Rise" ]
                        , hairline (PL Line)
                        , paragraph NoStyle [] 
                            [ decorativeImage NoStyle [height (px 20), width (px 20), moveDown 5, spacing 5] {src = image}
                            , text "Sea Level Rise"
                            ]
                        , paragraph NoStyle [paddingXY 32 0]
                            [ el NoStyle [] <| text "1ft -"
                            , el NoStyle [] <| text " 2ft -"
                            , el NoStyle [] <| text " 3ft -"
                            , el NoStyle [] <| text " 4ft -"
                            , el NoStyle [] <| text " 5ft -"
                            , el NoStyle [] <| text " 6ft"
                            ]
                        , hairline (PL Line)
                        , paragraph NoStyle [] 
                            [ decorativeImage NoStyle [height (px 20), width (px 20), moveDown 5, spacing 5] {src = image}
                            , text "Disconnected Roads"
                            ]
                        , paragraph CloseIcon [onClick ToggleCritFac] 
                            [ decorativeImage
                                ( case cfClicked of 
                                    Open -> 
                                        (PL Clicked)
                                    Closed ->
                                        (NoStyle)
                                ) 
                                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                                {src = image}
                            , text "Critical Facilities"
                            ]
                        ]
                Closed ->
                    (el NoStyle [] empty )
            ]  
        ]

sectionGLP : Device ->  String -> String -> Animation.State -> Msg -> Openness -> Element MainStyles Variations Msg
sectionGLP device titletext image fx func open =
    column NoStyle
        [height fill, verticalSpread]
        [ row NoStyle 
            [ verticalCenter, spread, width fill, height fill, paddingXY 32 15 ]
            [ headerView titletext 
            , buttonView image fx func
            ] 
        , case open of 
            Open -> 
                row NoStyle
                    [verticalCenter, spread, width fill, height fill, paddingXY 32 0]
                    [ text "hello world GLP"

                    ]
            Closed ->
                (el NoStyle [] empty )
        ]

sectionCE : Device ->  String -> String -> Animation.State -> Msg -> Openness -> Element MainStyles Variations Msg
sectionCE device titletext image fx func open =
    column NoStyle
        [height fill, verticalSpread]
        [ row NoStyle 
            [ verticalCenter, spread, width fill, height fill, paddingXY 32 15 ]
            [ headerView titletext 
            , buttonView image fx func
            ] 
        , case open of 
            Open -> 
                row NoStyle
                    [verticalCenter, spread, width fill, height fill, paddingXY 32 0]
                    [ text "hello world CE"

                    ]
            Closed ->
                (el NoStyle [] empty )
        ]