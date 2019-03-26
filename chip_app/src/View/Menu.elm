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
  column MenuContainer
    [verticalCenter, paddingXY 10 10, spacing 10, alignRight]
    [ textLayout MenuContainer [spacing 10, alignRight]
      [ button MenuContainer
            [ onClick ToggleIntro ] <| Element.text "About"
      , hairline (PL Line)
      , button MenuContainer
            [ onClick ToggleResources ] <| Element.text "Resources"
      , hairline (PL Line)
      , button MenuContainer
            [ onClick ToggleMethods ] <| Element.text "Methods"
      ]
    ]