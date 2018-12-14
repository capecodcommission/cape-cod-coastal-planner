module View.Infrastructure exposing (..)

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
      , buttonView paths.downArrow config.infraToggleFx 
      ] 
    , row NoStyle 
        ( renderAnimation config.infraFx 
          [width fill, paddingXY 32 0]
        ) 
        ( 
          [ case config.infraOpenness of 
              Open -> 
                infraDetails config paths 
              Closed ->
                (el NoStyle [] empty )
          ] 
        ) 
    ]

headerView : String -> Element MainStyles Variations Msg
headerView titleText =
    header (Sidebar SidebarHeader) 
        [ height (px 60), width fill ] <| 
            h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text titleText)
     

buttonView : String -> Animation.State -> Element MainStyles Variations Msg
buttonView togglePath fx =
    el (Sidebar SidebarLeftToggle) 
        [ height (px 60), width (px 70)] <| 
            decorativeImage NoStyle 
                ( renderAnimation fx
                    [height (px 60), width (px 70)]
                )
                { src = togglePath } 

infraDetails :
    { config
        | critFacClicked : Openness
        , slrFx : Animation.State
        , slr2ftClicked : Openness
        , mopClicked : Openness
        , pprClicked : Openness
        , spClicked : Openness
        , cdsClicked : Openness
        , structuresClicked : Openness
    } 
    -> Paths 
    -> Element MainStyles Variations Msg
infraDetails config paths =
    textLayout NoStyle
        [ verticalCenter, spacing 10, paddingXY 32 0 ]
        [ paragraph NoStyle [] 
            [ text "Toggle map layers related to Infrastructure" ]
        , hairline (PL Line)
        , paragraph CloseIcon [ onClick ToggleMOPLayer ] 
            [ decorativeImage
                ( case config.mopClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Municipal Properties"
            ]
        , paragraph CloseIcon [onClick TogglePPRLayer] 
            [ decorativeImage 
                ( case config.pprClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Public and Private Roads"
            ]
        , case config.pprClicked of 
            Open ->
                pprLegend paths
            Closed -> 
                (el NoStyle [] empty )
        , paragraph CloseIcon [onClick ToggleSPLayer] 
            [ decorativeImage
                ( case config.spClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed ->
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Sewered Parcels"
            ]
        , paragraph CloseIcon [onClick ToggleCDSLayer] 
            [ decorativeImage
                ( case config.cdsClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed ->
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Coastal Defense Structures"
            ]
        , paragraph 
            CloseIcon 
            [] 
            [ decorativeImage
                ( case config.structuresClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed ->
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Structures"
            ]
        ]

pprLegend : Paths -> Element MainStyles Variations Msg
pprLegend paths =
    textLayout 
        NoStyle 
        [ verticalCenter, spacing 10, paddingXY 32 0 ]
        [ paragraph 
            NoStyle 
            []
            [ decorativeImage
                (PL RoadsPrivate)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , text "Private"
            ]
        , paragraph 
            NoStyle 
            []
            [ decorativeImage
                (PL RoadsPublic)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow} 
            , text "Public"
            ]
        ]
