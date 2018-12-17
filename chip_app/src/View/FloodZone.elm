module View.FloodZone exposing (..)

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
        | fzClicked : Openness
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
      , buttonView config.fzClicked paths.trianglePath 
      ] 
    
    ]

headerView : String -> Element MainStyles Variations Msg
headerView titleText =
    header (Sidebar SidebarHeader) 
        [ height (px 45), width fill ] <| 
            h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text titleText)
     

buttonView : Openness -> String -> Element MainStyles Variations Msg
buttonView fzClicked togglePath =
    el (Sidebar SidebarLeftToggle) 
        [ height (px 45), width (px 45)] <| 
            decorativeImage 
                ( case fzClicked of 
                    Open -> 
                      (PL Clicked)
                    Closed -> 
                      (NoStyle)

                )
                [ height (px 35), width (px 35), moveDown 5]
                { src = togglePath } 