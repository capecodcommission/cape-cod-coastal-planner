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
        ( scoreCard model.paths ) 
    ]




scoreCard : Paths -> Element MainStyles Variations Msg
scoreCard paths = 
  row (Header HeaderBackgroundRounded)
    [paddingXY 0 20]
    [ zoomButtons
    , legend paths
    , geoLocate
    ]




zoomButtons : Element MainStyles Variations Msg
zoomButtons = 
  column (Header HeaderBackground)
    []
    [ textLayout 
      (Header HeaderBackground)
      [ verticalCenter, spacing 5, paddingXY 32 10 ]
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

legend : Paths -> Element MainStyles Variations Msg
legend paths = 
  column NoStyle
    [verticalCenter]
    [ textLayout 
        (Header HeaderBackground)
        [ verticalCenter, spacing 5, paddingXY 32 10 ]
        [ paragraph 
            (Header HeaderTitle) 
            []
            [ decorativeImage
                (Rbn LessThanZero)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , Element.text "Low   "
            , decorativeImage
                (Rbn OneToFive)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , Element.text "Medium   "
            , decorativeImage
                (Rbn SixPlus)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , Element.text "High"
            ]
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