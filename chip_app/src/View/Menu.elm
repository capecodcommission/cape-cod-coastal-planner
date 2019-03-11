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
    [ height fill, width fill, inlineStyle [("pointer-events","none")] ]
    [ el NoStyle 
      -- [height fill, width (percent 15)]
      ( renderAnimation model.menuFX
          [ height fill
          , width (percent 15)
          ]
      )
      ( centerRibbon model.paths model.vulnRibbonClicked ) 
    ]




centerRibbon : Paths -> Openness -> Element MainStyles Variations Msg
centerRibbon paths vulnClicked = 
  row (Sidebar SidebarContainer)
    [paddingXY 0 10, center]
    [ scaleLegend paths vulnClicked
    ]

scaleLegend : Paths -> Openness -> Element MainStyles Variations Msg
scaleLegend paths vulnClicked = 
  column (Sidebar SidebarContainer)
    [verticalCenter, center, paddingXY 10 10, spacing 10]
    [ textLayout (Zoi ZoiText) [center, spacing 10]
      [ Element.text "About"
      , hairline (PL Line)
      , Element.text "Resources"
      , hairline (PL Line)
      , Element.text "Methods"
      ]
    ]