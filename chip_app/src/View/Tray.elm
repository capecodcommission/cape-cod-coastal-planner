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
  column NoStyle
    [ center, width fill, inlineStyle [("pointer-events","none")] ]
    [ el NoStyle
        ( renderAnimation model.titleRibbonFX
            [ height fill
            , width content
            ]
        )
        ( centerRibbon model.paths ) 
    ]




centerRibbon : Paths -> Element MainStyles Variations Msg
centerRibbon paths = 
  row (Header HeaderBackgroundRounded)
    [paddingXY 0 10]
    [ zoomButtons
    , scaleLegend paths
    , geoLocate
    ]




zoomButtons : Element MainStyles Variations Msg
zoomButtons = 
  column (Header HeaderBackground)
    []
    [ textLayout 
      (Header HeaderBackground)
      [ verticalCenter, spacing 5, paddingXY 32 5 ]
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

scaleLegend : Paths -> Element MainStyles Variations Msg
scaleLegend paths = 
  column (Header ScaleHeader)
    [verticalCenter, paddingXY 10 0, spacing 5]
    [ Element.text "Low   "
      |> onRight
        [ decorativeImage
          (Rbn LessThanZero)
          [height (px 20), width (px 20), moveLeft 10] 
          {src = paths.downArrow} 
        ]
    , Element.text "Med   "
        |> onRight
          [ decorativeImage
              (Rbn OneToFive)
              [height (px 20), width (px 20), moveLeft 10] 
              {src = paths.downArrow} 
          ]
    , Element.text "High"
        |> onRight
          [ decorativeImage
              (Rbn SixPlus)
              [height (px 20), width (px 20), moveLeft 10] 
              {src = paths.downArrow} 
          ] 
    ]

geoLocate : Element MainStyles Variations Msg
geoLocate = 
  column (Header HeaderBackground)
    [verticalCenter]
    [ textLayout 
      (Header HeaderBackground)
      [ verticalCenter, spacing 5, paddingXY 32 10 ]
      [ column NoStyle
          []
          [ button (Baseline BaselineInfoBtn)
              [height (px 42), width (px 42), onClick GetLocation]
              (Element.text "⌖")
          ]
      ]
    ]