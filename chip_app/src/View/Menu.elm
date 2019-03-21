module View.Menu exposing (..)

import Dict exposing (Dict)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import RemoteData exposing (RemoteData(..))
import Message exposing (..)
import Types exposing (..)
import ShorelineLocation as SL
import Styles exposing (..)
import View.ModalImage as ModalImage
import View.Helpers exposing (..)
import Animation



view : 
  { config 
      | shorelineSelected : Openness
      , paths : Paths
      , menuFX : Animation.State
      , vulnRibbonClicked : Openness
  } 
  -> Element MainStyles Variations Msg
view model =
  column NoStyle
    [ height fill, width fill, inlineStyle [("pointer-events","none")], alignRight ]
    [ el NoStyle 
      ( renderAnimation model.menuFX
          [ height fill
          ]
      )
      ( siteMenu model.paths model.vulnRibbonClicked ) 
    ]

siteMenu : Paths -> Openness -> Element MainStyles Variations Msg
siteMenu paths vulnClicked = 
  column (Sidebar SidebarContainer)
    [verticalCenter, paddingXY 10 10, spacing 10, alignRight]
    [ textLayout (Zoi ZoiText) [spacing 10, alignRight]
      [ Element.text "About"
      , hairline (PL Line)
      , Element.text "Resources"
      , hairline (PL Line)
      , Element.text "Methods"
      ]
    ]