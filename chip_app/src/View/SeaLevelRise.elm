module View.SeaLevelRise exposing (..)

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


view :
  { config
        | slrOpenness : Openness
        , slrToggleFx : Animation.State
        , critFacClicked : Openness
        , slrFx : Animation.State
        , drClicked : Openness
        , slr2ftClicked : Openness
        , slr1ftClicked : Openness
    } 
    -> Device 
    -> Paths 
    -> String 
    -> Msg 
    -> Element MainStyles Variations Msg
view config device paths titleText func =
  column NoStyle
    [paddingXY 0 0]
    [ row CloseIcon 
      [ verticalCenter, spread, width fill, paddingXY 32 32, onClick func ]
      [ headerView titleText 
      , buttonView paths.downArrow config.slrToggleFx 
      ] 
    , row NoStyle 
        ( renderAnimation config.slrFx 
          [width fill, paddingXY 32 0]
        ) 
        ( 
          [ case config.slrOpenness of 
              Open -> 
                slrDetails config paths 
              Closed ->
                (el NoStyle [] empty )
          ] 
        ) 
    ]

headerView : String -> Element MainStyles Variations Msg
headerView titleText =
    header (Sidebar SidebarHeader) 
        [ height (px 60), width fill ] <| 
            h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text titleText)
     

buttonView : String -> Animation.State -> Element MainStyles Variations Msg
buttonView togglePath fx =
    el (Sidebar SidebarLeftToggle) 
        [ height (px 60), width (px 70)] <| 
            decorativeImage NoStyle 
                ( renderAnimation fx
                    [height (px 60), width (px 70)]
                )
                { src = togglePath } 

slrDetails :
    { config
        | critFacClicked : Openness
        , slrFx : Animation.State
        , drClicked : Openness
        , slr2ftClicked : Openness
        , slr1ftClicked : Openness
    } 
    -> Paths 
    -> Element MainStyles Variations Msg
slrDetails config paths =
    textLayout NoStyle
        [ verticalCenter, spacing 10, paddingXY 32 0 ]
        [ paragraph NoStyle [] 
            [ text "Toggle map layers related to the potential effects of Sea Level Rise" ]
        , hairline (PL Line)
        , paragraph CloseIcon 
            [] 
            [ decorativeImage
                NoStyle
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Sea Level Rise"
            ]
        , paragraph CloseIcon [ paddingXY 32 0 ]
            [ el 
                ( case config.slr1ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSLRLayer "1") ] <| text " 1ft -"
            , el 
                ( case config.slr2ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSLRLayer "2") ] <| text " 2ft -"
            , el NoStyle [] <| text " 3ft -"
            , el NoStyle [] <| text " 4ft -"
            , el NoStyle [] <| text " 5ft -"
            , el NoStyle [] <| text " 6ft"
            ]
        , hairline (PL Line)
        , paragraph CloseIcon [onClick ToggleDR] 
            [ decorativeImage 
                ( case config.drClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Disconnected Roads"
            ]
        , paragraph CloseIcon [onClick ToggleCritFac] 
            [ decorativeImage
                ( case config.critFacClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed ->
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Critical Facilities"
            ]
        ]