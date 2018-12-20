module View.Slosh exposing (..)

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
        | sloshClicked : Openness
        , sloshFx : Animation.State
        , sloshToggleFx : Animation.State
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
      [ verticalCenter, spread, width fill, paddingXY 10 20, onClick func ]
      [ headerView titleText 
      , buttonView config.sloshClicked paths.trianglePath config.sloshToggleFx
      ] 
    , row NoStyle 
        ( renderAnimation config.sloshFx 
          [width fill, paddingXY 0 0]
        ) 
        ( 
          [ case config.sloshClicked of 
              Open -> 
                sloshLegend paths 
              Closed ->
                (el NoStyle [] empty )
          ] 
        ) 
    ]

headerView : String -> Element MainStyles Variations Msg
headerView titleText =
    header (Sidebar SidebarHeader) 
        [ height (px 45), width fill ] <| 
            h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text titleText)
     

buttonView : Openness -> String -> Animation.State -> Element MainStyles Variations Msg
buttonView sloshClicked togglePath fx =
    el (Sidebar SidebarLeftToggle) 
        [ height (px 45), width (px 45)] <| 
            decorativeImage NoStyle
                ( renderAnimation fx
                    [height (px 35), width (px 35), moveDown 5]
                )
                { src = togglePath } 

sloshLegend : Paths -> Element MainStyles Variations Msg
sloshLegend paths =
    textLayout 
        (Zoi ZoiText) 
        [ verticalCenter, spacing 5, paddingXY 32 0 ]
        [ paragraph 
            NoStyle 
            []
            [ decorativeImage
                (PL CAT1)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , text "CAT1   "
            , decorativeImage
                (PL CAT2)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , text "CAT2   "
            , decorativeImage
                (PL CAT3)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , text "CAT3    "
            , decorativeImage
                (PL CAT4)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , text "CAT4"
            ]
        ]