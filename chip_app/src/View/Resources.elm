module View.Resources exposing (..)

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
    (row (Baseline BaselineInfoHeader)
        [ verticalCenter
        , height (px 100)
        , width fill
        , paddingXY 20 0
        ]
        [ column (ShowOutput ScenarioBold) 
            []
            [ h6 (Headings H3) [ width fill ] <| Element.text "Resources"
            ]
        ]
        |> within
            [ image CloseIcon
                [ alignRight
                , moveDown 15
                , moveLeft 15
                , title "Close resources"
                , onClick ToggleResources
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
    row (Modal IntroBody)
        [ ]
        [ column (Modal IntroWelcome)
            [ spacingXY 0 5, width fill, paddingXY 20 20 ]
            [ row NoStyle
                [height fill]
                [ decorativeImage NoStyle 
                    [ width (percent 20), verticalCenter, alignLeft ]
                    { src = config.paths.erosionPath }
                , paragraph (Modal IntroWelcome)
                    [ paddingLeft 20, verticalCenter, alignRight ]
                    [ text "These are the resources of the 1st column and 1st row." ]
                ]
            , row NoStyle
                [height fill]
                [ decorativeImage NoStyle
                    [ width (percent 20), verticalCenter, alignLeft ]
                    { src = config.paths.erosionPath }
                , paragraph (Modal IntroWelcome)
                    [ paddingLeft 20, verticalCenter, alignRight ]
                    [ text "These are the resources of the 1st column and 2nd row." ]
                ]
            , row NoStyle
                [height fill]
                [ decorativeImage NoStyle
                    [ width (percent 20), verticalCenter, alignLeft ]
                    { src = config.paths.erosionPath }
                , paragraph (Modal IntroWelcome)
                    [ paddingLeft 20, verticalCenter, alignRight ]
                    [ text "These are the resources of the 1st column and 3rd row." ]
                ]
            ]
        , column (Modal IntroWelcome)
            [ spacingXY 0 5, width fill, paddingXY 20 20 ]
            [ row NoStyle
                [height fill]
                [ decorativeImage NoStyle
                    [ width (percent 20), verticalCenter, alignLeft ]
                    { src = config.paths.erosionPath }
                , paragraph (Modal IntroWelcome)
                    [ paddingLeft 20, verticalCenter, alignRight ]
                    [ text "These are the resources of the 2nd column and 1st row." ]
                ]
            , row NoStyle
                [height fill]
                [ decorativeImage NoStyle
                    [ width (percent 20), verticalCenter, alignLeft ]
                    { src = config.paths.erosionPath }
                , paragraph (Modal IntroWelcome)
                    [ paddingLeft 20, verticalCenter, alignRight ]
                    [ text "These are the resources of the 2nd column and 2nd row." ]
                ]
            , row NoStyle
                [height fill]
                [ decorativeImage NoStyle
                    [ width (percent 20), verticalCenter, alignLeft ]
                    { src = config.paths.erosionPath }
                , paragraph (Modal IntroWelcome)
                    [ paddingLeft 20, verticalCenter, alignRight ]
                    [ text "These are the resources of the 2nd column and 3nd row." ]
                ]
            ]
        ]
