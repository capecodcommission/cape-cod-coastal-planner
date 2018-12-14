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
      , buttonView config.sloshClicked paths.downArrow 
      ] 
    
    ]

headerView : String -> Element MainStyles Variations Msg
headerView titleText =
    header (Sidebar SidebarHeader) 
        [ height (px 60), width fill ] <| 
            h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text titleText)
     

buttonView : Openness -> String -> Element MainStyles Variations Msg
buttonView sloshClicked togglePath =
    el (Sidebar SidebarLeftToggle) 
        [ height (px 60), width (px 70)] <| 
            decorativeImage 
                ( case sloshClicked of 
                    Open -> 
                      (PL Clicked)
                    Closed -> 
                      (NoStyle)

                )
                [ height (px 60), width (px 70)]
                { src = togglePath } 