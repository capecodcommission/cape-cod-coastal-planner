module View.Erosion exposing (..)

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
        | slrOpenness : Openness
        , slrToggleFx : Animation.State
        , critFacClicked : Openness
        , slrFx : Animation.State
        , slr2ftClicked : Openness
        , infraOpenness : Openness
        , infraFx : Animation.State
        , infraToggleFx : Animation.State
        , mopClicked : Openness
        , pprClicked : Openness
        , spClicked : Openness
        , cdsClicked : Openness
        , structuresClicked : Openness
        , erosionSectionOpenness : Openness
        , erosionFx : Animation.State
        , erosionToggleFx : Animation.State
        , fourtyYearClicked : Openness
        , stiClicked : Openness
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
      , buttonView paths.trianglePath config.erosionToggleFx 
      ] 
    , row NoStyle 
        ( renderAnimation config.erosionFx 
          [width fill, paddingXY 0 0]
        ) 
        ( 
          [ case config.erosionSectionOpenness of 
              Open -> 
                erosionDetails config paths 
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
     

buttonView : String -> Animation.State -> Element MainStyles Variations Msg
buttonView togglePath fx =
    el (Sidebar SidebarLeftToggle) 
        [ height (px 45), width (px 45)] <| 
            decorativeImage NoStyle 
                ( renderAnimation fx
                    [height (px 35), width (px 35), moveDown 5]
                )
                { src = togglePath } 

erosionDetails :
    { config
        | critFacClicked : Openness
        , slrFx : Animation.State
        , slr2ftClicked : Openness
        , mopClicked : Openness
        , pprClicked : Openness
        , spClicked : Openness
        , cdsClicked : Openness
        , structuresClicked : Openness
        , fourtyYearClicked : Openness
        , stiClicked : Openness
    } 
    -> Paths 
    -> Element MainStyles Variations Msg
erosionDetails config paths =
    textLayout (Zoi ZoiText)
        [ verticalCenter, spacing 0, paddingXY 20 0 ]
        [ paragraph CloseIcon [ onClick ToggleFourtyYearLayer ] 
            [ decorativeImage
                ( case config.fourtyYearClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "40-yr Erosion"
            ]
        , case config.fourtyYearClicked of 
            Open ->
                fourtyYearLegend paths
            Closed -> 
                (el NoStyle [] empty )
        , paragraph CloseIcon [onClick ToggleSTILayer] 
            [ decorativeImage 
                ( case config.stiClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Sediment Transport Indicators"
            ]
        ]

fourtyYearLegend : Paths -> Element MainStyles Variations Msg
fourtyYearLegend paths =
    textLayout 
        NoStyle 
        [ verticalCenter, spacing 5, paddingXY 32 0 ]
        [ paragraph 
            NoStyle 
            []
            [ decorativeImage
                (PL Accretion)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , text "Accretion   "
            , decorativeImage
                (PL Erosion)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , text "Erosion"
            ]
        ]

cdsLegend : Paths -> Element MainStyles Variations Msg
cdsLegend paths =
    textLayout 
        NoStyle 
        [ verticalCenter, spacing 5, paddingXY 32 0 ]
        [ paragraph 
            NoStyle 
            []
            [ decorativeImage
                (PL Groins)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , text "Groins   "
            , decorativeImage
                (PL Revetment)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , text "Revetment   "
            , decorativeImage
                (PL Jetty)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , text "Jetty"
            ]
        ]