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
                    , padding 40
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
    column NoStyle
        [ ]
        [ row (Modal MethodsResourcesBackground)
            [ width fill, height (percent 33), paddingXY 10 10 ]
            [ column NoStyle
                [ width (percent 15), verticalCenter, paddingRight 20 ]
                [ column NoStyle
                    [ width fill, verticalCenter, alignLeft ]
                    [ decorativeImage NoStyle 
                        [ verticalCenter, center, width fill ]
                        { src = config.paths.erosionPath }
                    ]
                ]
                , column NoStyle
                    [ width (percent 35) ]
                        [ textLayout NoStyle
                            [ verticalCenter, width fill, paddingBottom 5 ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ el (Modal MethodsResourcesModalHeading) [] <| text "ADAPTATION STRATEGIES MATRIX" ]
                                ]
                        , textLayout NoStyle
                            [ verticalCenter, width fill ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ el (Modal MethodsResourcesModal) [] <| text "Excel spreadsheet describing in detail possible adaptation strategies, including siting and permitting considerations and process." ]
                                ]
                        ]
            , column NoStyle
                [ width (percent 15), verticalCenter, paddingLeft 20]
                [ column NoStyle
                    [ width fill, verticalCenter, alignLeft ]
                    [ decorativeImage NoStyle 
                        [ verticalCenter, center, width fill ]
                        { src = config.paths.erosionPath }
                    ]
                ]
                , column NoStyle
                    [ width (percent 35), paddingLeft 20, paddingBottom 5 ]
                        [ textLayout NoStyle
                            [ verticalCenter ] 
                                [ paragraph NoStyle
                                [ ]
                                    [ el (Modal MethodsResourcesModalHeading) [] <| text "ADAPTATION STRATEGIES FACT SHEETS" ]
                                ]
                        , textLayout NoStyle
                            [ verticalCenter ] 
                                [ paragraph NoStyle
                                [ ]
                                    [ el (Modal MethodsResourcesModal) [] <| text "Educational handouts on a subset of Adaptation Strategies found in the Cape Cod Coastal Planner." ]
                                ]
                        ]
            ]
        , el NoStyle 
            [ paddingXY 5 0 ] <| hairline (MethodsResourcesBackgroundLine) 
        , row (Modal MethodsResourcesBackground)
            [ width fill, height (percent 33), paddingXY 10 10 ]
            [ column NoStyle
                [ width (percent 15), verticalCenter, paddingRight 20 ]
                [ column NoStyle
                    [ width fill, verticalCenter, alignLeft ]
                    [ decorativeImage NoStyle 
                        [ verticalCenter, center, width fill ]
                        { src = config.paths.erosionPath }
                    ]
                ]
                , column NoStyle
                    [ width (percent 35) ]
                        [ textLayout NoStyle
                            [ verticalCenter, width fill, paddingBottom 5 ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ el (Modal MethodsResourcesModalHeading) [] <| text "RESILIENT CAPE COD SPARK PAGE" ]
                                ]
                        , textLayout NoStyle
                            [ verticalCenter, width fill ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ el (Modal MethodsResourcesModal) [] <| text "Website describing the 3-year Resilient Cape Cod project." ]
                                ]
                        ]
            , column NoStyle
                [ width (percent 15), verticalCenter, paddingLeft 20]
                [ column NoStyle
                    [ width fill, verticalCenter, alignLeft ]
                    [ decorativeImage NoStyle 
                        [ verticalCenter, center, width fill ]
                        { src = config.paths.erosionPath }
                    ]
                ]
                , column NoStyle
                    [ width (percent 35), paddingLeft 20, paddingBottom 5 ]
                        [ textLayout NoStyle
                            [ verticalCenter ] 
                                [ paragraph NoStyle
                                [ ]
                                    [ el (Modal MethodsResourcesModalHeading) [] <| text "LOCAL STORIES OF COASTAL IMPACTS" ]
                                ]
                        , textLayout NoStyle
                            [ verticalCenter ] 
                                [ paragraph NoStyle
                                [ ]
                                    [ el (Modal MethodsResourcesModal) [] <| text "ESRI Storymap of stakeholder-sourced case studies of coastal impacts due to sea level rise, erosion, and storm surge." ]
                                ]
                        ]
            ]
        , el NoStyle 
            [ paddingXY 5 0 ] <| hairline (MethodsResourcesBackgroundLine)
        , row (Modal MethodsResourcesBackground)
            [ width fill, height (percent 33), paddingXY 10 10 ]
            [ column NoStyle
                [ width (percent 15), verticalCenter, paddingRight 20 ]
                [ column NoStyle
                    [ width fill, verticalCenter, alignLeft ]
                    [ decorativeImage NoStyle 
                        [ verticalCenter, center, width fill ]
                        { src = config.paths.erosionPath }
                    ]
                ]
                , column NoStyle
                    [ width (percent 35) ]
                        [ textLayout NoStyle
                            [ verticalCenter, width fill, paddingBottom 5 ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ el (Modal MethodsResourcesModalHeading) [] <| text "ECOSYSTEM SERVICES HANDOUT" ]
                                ]
                        , textLayout NoStyle
                            [ verticalCenter, width fill ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ el (Modal MethodsResourcesModal) [] <| text "Educational handout describing ecosystem services used during the Resilient Cape Cod stakeholder process." ]
                                ]
                        ]
            , column NoStyle
                [ width (percent 15), verticalCenter, paddingLeft 20]
                [ column NoStyle
                    [ width fill, verticalCenter, alignLeft ]
                    [ decorativeImage NoStyle 
                        [ verticalCenter, center, width fill ]
                        { src = config.paths.erosionPath }
                    ]
                ]
                , column NoStyle
                    [ width (percent 35), paddingLeft 20, paddingBottom 5 ]
                        [ textLayout NoStyle
                            [ verticalCenter ] 
                                [ paragraph NoStyle
                                [ ]
                                    [ el (Modal MethodsResourcesModalHeading) [] <| text "RESILIENT CAPE COD HOME PAGE" ]
                                ]
                        , textLayout NoStyle
                            [ verticalCenter ] 
                                [ paragraph NoStyle
                                [ ]
                                    [ el (Modal MethodsResourcesModal) [] <| text "Link to Cape Cod Commission’s project homepage." ]
                                ]
                        ]
            ]
        ]