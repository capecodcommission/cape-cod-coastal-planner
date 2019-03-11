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
      , vulnRibbonClicked : Openness
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
        ( centerRibbon model.paths model.vulnRibbonClicked ) 
    ]




centerRibbon : Paths -> Openness -> Element MainStyles Variations Msg
centerRibbon paths vulnClicked = 
  row (Header HeaderBackgroundRounded)
    [paddingXY 0 10]
    [ zoomButtons
    , scaleLegend paths vulnClicked
    , geoLocate
    ]




zoomButtons : Element MainStyles Variations Msg
zoomButtons = 
  column (Header HeaderBackground)
    [verticalCenter, paddingXY 0 10]
    [ textLayout 
      (Header HeaderBackground)
      [ verticalCenter, spacing 10, paddingXY 32 10 ]
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

scaleLegend : Paths -> Openness -> Element MainStyles Variations Msg
scaleLegend paths vulnClicked = 
  column (Header ScaleHeader)
    [verticalCenter, paddingXY 10 10, spacing 10]
    [ Element.text "Low   "
      |> onRight
        [ button
          (Rbn LessThanZero)
          [height (px 20), width (px 20), moveLeft 10] 
          (Element.text "")
        ]
    , Element.text "Medium   "
        |> onRight
          [ button
              (Rbn OneToFive)
              [height (px 20), width (px 20), moveLeft 10] 
              (Element.text "")
          ]
    , Element.text "High"
        |> onRight
          [ button
              (Rbn SixPlus)
              [height (px 20), width (px 20), moveLeft 10] 
              (Element.text "")
          ] 
    , button 
        (case vulnClicked of
          Open ->
            (Baseline BaselineInfoBtnClicked)
          Closed ->
            (Baseline BaselineInfoBtn)
        )
        [height (px 42), onClick ToggleVulnRibbon]
        (Element.text "~")
    ]

geoLocate : Element MainStyles Variations Msg
geoLocate = 
  column (Header HeaderBackground)
    [verticalCenter, paddingXY 0 10]
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