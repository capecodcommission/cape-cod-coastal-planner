module View.Resources exposing (..)

import Dict exposing (Dict)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import RemoteData exposing (RemoteData(..))
import Message exposing (..)
import Types exposing (..)
import Styles exposing (..)
import View.ModalImage as ModalImage
import View.Helpers exposing (..)
import View.ZoneOfImpact exposing (textLayoutSpacing)


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
        , resourcesClicked : Openness
        , paths : Paths
    } 
    -> Element MainStyles Variations Msg
view config =
    case config.resourcesClicked of
        Open ->
            column NoStyle
                []
                [ modal (Modal ModalBackground)
                    [ height fill
                    , width fill
                    , padding 90
                    ] <|
                        el NoStyle
                            [ width (px 700)
                            , maxHeight (px <| modalHeight config.device)
                            , center
                            , verticalCenter
                            ] <|
                            column NoStyle
                                []
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
            [width fill, height (px 200), alignLeft]
            { src = config.paths.welcome_lighthouse } 
        ]     


mainView : 
    { config 
        | device : Device 
        , paths : Paths
    } 
    -> Element MainStyles Variations Msg
mainView config =
    column (Modal IntroBody)
        [ spacingXY 0 5, width fill, paddingXY 50 0]
        [ decorativeImage NoStyle
            [width (px 400), height (px 75), moveRight 25]
            { src = config.paths.logoPath } 
        , textLayout (Modal IntroWelcome)
            [paddingTop 25, paddingBottom 10] 
            [ paragraph NoStyle
                []
                [ el (ShowOutput ScenarioBold) [] <| text "Welcome! " 
                , text "The Cape Cod Coastal Planner is a communication and decision support tool intended to educate users on the climate change hazards impacting Cape Cod's coastline, the adaptation strategies available to address them, and implications for local infrastructure and ecosystems. Choose your location and zone of impact to begin planning. View planning layers and test adaptation strategies for three coastal hazards."
                ]
            ]
        , button SelectShorelineButton 
            [ onClick ToggleResources, width fill, height (px 42) ] <| text "select a shoreline location to start planning"
        , textLayout (Modal IntroDisclaimer)
            [center]
            [ paragraph NoStyle
                []
                [ text "First time user? Follow the "
                , link "https://dev.capecodcoast.org" <| el (Zoi ZoiCallout) [] (text "tutorial wizard")
                , text " first."
                ]
            ]
        , el NoStyle 
            [paddingTop 25, paddingBottom 10] <| hairline (PL Line) 
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
                [ text "Learn more at capecodcommission.org/resilientcapecod"
                ]
            ]
        , el NoStyle 
            [paddingXY 0 10] <| hairline (PL Line) 
        ] 