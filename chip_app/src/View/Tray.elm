module View.Tray exposing (..)

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
      , titleRibbonFX : Animation.State
  } 
  -> Element MainStyles Variations Msg
view model =
  el NoStyle [alignBottom]
    ( centerRibbon model.paths ) 
    




centerRibbon : Paths -> Element MainStyles Variations Msg
centerRibbon paths = 
  row (Header HeaderBackgroundRounded)
    [paddingXY 0 10]
    [ zoomButtons
    ]




zoomButtons : Element MainStyles Variations Msg
zoomButtons = 
  column (Header HeaderBackground)
    [verticalCenter, paddingXY 2 1]
    [ textLayout 
      (Header HeaderBackground)
      [ verticalCenter, spacing 10, paddingXY 2 1 ]
      [ column NoStyle
          [spacing 10]
          [ button (Baseline BaselineInfoBtn)
              [height (px 42), width (px 42), onClick ZoomIn]
              (Element.text "+")
          , button (Baseline BaselineInfoBtn)
              [height (px 42), width (px 42), onClick ZoomOut]
              (Element.text "-")
          ]
      ]
    ]