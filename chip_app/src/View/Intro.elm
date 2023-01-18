module View.Intro exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Message exposing (..)
import Types exposing (..)
import Styles exposing (..)
import View.Helpers exposing (..)


modalHeight : Device -> Float
modalHeight device =
    adjustOnHeight ( 580, 1000 ) device


headerHeight : Device -> Float
headerHeight device =
    adjustOnHeight ( 165, 225 ) device


mainHeight : Device -> Float
mainHeight device =
    (modalHeight device) - (headerHeight device)


view : 
    { config 
        | device : Device
        , closePath : String
        , introClicked : Openness
        , paths : Paths
        , shorelineButtonClicked : Openness
    } 
    -> Element MainStyles Variations Msg
view config =
    case config.introClicked of
        Open ->
            column NoStyle
                []
                [ modal (Modal ModalBackground)
                    [ height fill
                    , width fill
                    , padding 45
                    ] <|
                        el NoStyle
                            [ width (px 700)
                            --, maxHeight (px <| modalHeight config.device)
                            , height (percent <| 99)
                            , center
                            , verticalCenter
                            ] <|
                            column NoStyle
                                [ height (percent <| 100)
                                , yScrollbar ]
                                [ headerView config 
                                , mainView config
                                ]
                ]

        Closed ->
            el NoStyle [] empty
            

headerView : 
    { config 
        | device : Device 
        , paths : Paths
    } 
    -> Element MainStyles Variations Msg
headerView config =
    row (Modal IntroHeader)
        [ spacingXY 0 5, width fill]
        [ decorativeImage NoStyle
            [width fill, height (px 180), alignLeft]
            { src = config.paths.welcome_lighthouse } 
        , decorativeImage CloseIcon 
            [ alignRight
            , height (px 22)
            , width (px 22)
            , moveDown 15
            , moveLeft 15
            , title "Close strategy selection"
            , onClick ToggleIntro
            ]
            { src = config.paths.closePath }
        ]     


mainView : 
    { config 
        | device : Device 
        , paths : Paths
        , shorelineButtonClicked : Openness
    } 
    -> Element MainStyles Variations Msg
mainView config =
    column (Modal IntroBody)
        [ spacingXY 0 5, width fill, paddingXY 50 0]
        [ decorativeImage NoStyle
            [width (px 400), height (px 75), moveRight 25]
            { src = config.paths.logoPath } 
        , textLayout (Modal IntroWelcome)
            [paddingTop 18, paddingBottom 10] 
            [ paragraph NoStyle
                []
                [ el (ShowOutput ScenarioBold) [] <| text "Welcome! " 
                , text "The Cape Cod Coastal Planner is a communication and decision support tool intended to educate users on the climate change hazards impacting Cape Cod's coastline, the adaptation strategies available to address them, and implications for local infrastructure and ecosystems. Choose your location and zone of impact to begin planning. View planning layers and test adaptation strategies for three coastal hazards."
                ]
            ]
        , case config.shorelineButtonClicked of
            Open ->
                button SelectShorelineButton 
                [ onClick ToggleIntro , width fill, height (px 42) ] <| text "select a shoreline location to start planning"
            Closed ->
                el NoStyle [] empty
        , textLayout (Modal IntroDisclaimer)
            [center]
            [ paragraph NoStyle
                [paddingTop 10]
                [ text "First time user? Tutorial Video "
                , newTab "https://www.youtube.com/watch?v=mqsXjOeDAZg" <| el (Zoi ZoiCallout) [] (text "Here")
                , text "."
                ]
            ]
        , el NoStyle 
            [paddingTop 20, paddingBottom 10] <| hairline (PL Line) 
        , textLayout (Modal IntroDisclaimer)
            [spacing 5] 
            [ paragraph NoStyle
                []
                [ el (ShowOutput ScenarioBold) [] <| text "Disclaimer: " 
                , text "The Cape Cod Commission developed the Cape Cod Coastal Planner to improve understanding of the coastal hazards facing Cape Cod, including erosion, sea level rise, and storm surge, and to aid in local coastal planning processes. The application is an informational resource intended to provide high-level anticipated impacts for planning purposes. The output panel provides estimates of change to the shoreline location, and are not intended to be used in an engineering context or to indicate support for any particular Adaptation Strategy."
                ]
            , paragraph NoStyle
                []
                [ text "Funded by a NOAA Coastal Resilience Grant awarded to the Cape Cod Commission and its partner agencies. "
                ]
            , paragraph NoStyle
                []
                [ text "Learn more at "
                , newTab "http://capecodcommission.org/resilientcapecod" <| el (Zoi ZoiCallout) [] (text "The Resilient Cape Cod Site")
                , text "."
                ]
            ]
        , el NoStyle 
            [paddingXY 0 10] <| hairline (PL Line) 
        ] 
