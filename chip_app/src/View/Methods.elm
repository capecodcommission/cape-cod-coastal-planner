module View.Methods exposing (..)

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
        , methodsClicked : Openness
        , paths : Paths
    } 
    -> Element MainStyles Variations Msg
view config =
    case config.methodsClicked of
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
    (row (Baseline BaselineInfoHeader)
        [ verticalCenter
        , height (px 100)
        , width fill
        , paddingXY 20 0
        ]
        [ column (ShowOutput ScenarioBold) 
            []
            [ h6 (Headings H3) 
                [ width fill ] <| Element.text "Methods"
            ]
        ]
        |> within
            [ image CloseIcon
                [ alignRight
                , moveDown 15
                , moveLeft 15
                , title "Close methods"
                , onClick ToggleMethods
                ]
                { src = config.paths.closePath, caption = "Close Modal" }
            ]
    )


mainView : 
    { config 
        | device : Device 
        , paths : Paths
    } 
    -> Element MainStyles Variations Msg
mainView config =
    column (Modal MethodsResourcesBackground)
        [ ]
        [ row NoStyle
            [ spacingXY 0 5, width fill, paddingXY 20 20 ]
            [ decorativeImage NoStyle
                [ width (percent 20), verticalCenter, alignLeft ]
                { src = config.paths.erosionPath }
            , paragraph (Modal IntroWelcome)
                [ paddingLeft 20, verticalCenter, alignRight ]
                [ text "Description of how the tool works, including features, data sources, and background calculations." 
                ]
            ]
        ]