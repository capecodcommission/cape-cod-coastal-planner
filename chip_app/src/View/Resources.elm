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
            [ width (percent 50), height (percent 33), paddingXY 20 0, paddingBottom 20 ]
            [ row NoStyle
                [height fill, paddingBottom 10]
                [ decorativeImage NoStyle 
                    [ width (percent 20), verticalCenter, alignLeft ]
                    { src = config.paths.erosionPath }
                , 
                textLayout (Modal IntroWelcome)
                    [ paddingLeft 20, verticalCenter ] 
                    [ paragraph NoStyle
                        [ ]
                        [ el (AddStrategies StrategiesDetailsCategories) [] <| text "ADAPTATION STRATEGIES MATRIX" ]
                    ]
                , textLayout (Modal IntroWelcome)
                    [ paddingLeft 20 ] 
                    [ paragraph NoStyle
                        [ ]
                        [ el (AddStrategies StrategiesDetailsCategories) [] <| text "Excel spreadsheet describing in detail possible adaptation strategies, including siting and permitting considerations and process."
                        ]
                    ]
                ]
            , el NoStyle 
                [ ] <| hairline (Hairline) 
            , row NoStyle
                [height fill, paddingXY 0 10]
                [ decorativeImage NoStyle 
                    [ width (percent 20), verticalCenter, alignLeft ]
                    { src = config.paths.erosionPath }
                , 
                textLayout (Modal IntroWelcome)
                    [ paddingLeft 20, verticalCenter ] 
                    [ paragraph NoStyle
                        [ ]
                        [ el (AddStrategies StrategiesDetailsCategories) [] <| text "ADAPTATION STRATEGIES FACT SHEETS" ]
                    ]
                , textLayout (Modal IntroWelcome)
                    [ paddingLeft 20 ] 
                    [ paragraph NoStyle
                        [ ]
                        [ el (AddStrategies StrategiesDetailsCategories) [] <| text "Educational handouts on a subset of Adaptation Strategies found in the Cape Cod Coastal Planner." ]
                    ] 
                ]
            , el NoStyle 
                [ ] <| hairline (Hairline) 
            , row NoStyle
                [height fill, paddingTop 10]
                [ decorativeImage NoStyle 
                    [ width (percent 20), verticalCenter, alignLeft ]
                    { src = config.paths.erosionPath }
                , 
                textLayout (Modal IntroWelcome)
                    [ paddingLeft 20, verticalCenter ] 
                    [ paragraph NoStyle
                        [ ]
                        [ el (AddStrategies StrategiesDetailsCategories) [] <| text "RESILIENT CAPE COD SPARK PAGE" ]
                    ]
                , textLayout (Modal IntroWelcome)
                    [ paddingLeft 20 ] 
                    [ paragraph NoStyle
                        [ ]
                        [ el (AddStrategies StrategiesDetailsCategories) [] <| text "Website describing the 3-year Resilient Cape Cod project." ]
                    ] 
                ]
            ]
        , column (Modal IntroWelcome)
            [ width (percent 50), paddingXY 20 0, paddingBottom 20 ]
            [ row NoStyle
                [height fill, paddingBottom 10]
                [ decorativeImage NoStyle 
                    [ width (percent 20), verticalCenter, alignLeft ]
                    { src = config.paths.erosionPath }
                , 
                textLayout (Modal IntroWelcome)
                    [ paddingLeft 20, verticalCenter ] 
                    [ paragraph NoStyle
                        [ ]
                        [ el (AddStrategies StrategiesDetailsCategories) [] <| text "LOCAL STORIES OF COASTAL IMPACTS" ]
                    ]
                , textLayout (Modal IntroWelcome)
                    [ paddingLeft 20 ] 
                    [ paragraph NoStyle
                        [ ]
                        [ el (AddStrategies StrategiesDetailsCategories) [] <| text "ESRI Storymap of stakeholder-sourced case studies of coastal impacts due to sea level rise, erosion, and storm surge." ]
                    ] 
                ]
            , el NoStyle 
                [ ] <| hairline (Hairline)
            , row NoStyle
                [height fill, paddingXY 0 10]
                [ decorativeImage NoStyle 
                    [ width (percent 20), verticalCenter, alignLeft ]
                    { src = config.paths.erosionPath }
                , 
                textLayout (Modal IntroWelcome)
                    [ paddingLeft 20, verticalCenter ] 
                    [ paragraph NoStyle
                        [ ]
                        [ el (AddStrategies StrategiesDetailsCategories) [] <| text "ECOSYSTEM SERVICES HANDOUT" ]
                    ]
                , textLayout (Modal IntroWelcome)
                    [ paddingLeft 20 ] 
                    [ paragraph NoStyle
                        [ ]
                        [ el (AddStrategies StrategiesDetailsCategories) [] <| text "Educational handout describing ecosystem services used during the Resilient Cape Cod stakeholder process." ]
                    ] 
                ]
            , el NoStyle 
                [ ] <| hairline (Hairline)
            , row NoStyle
                [height fill, paddingTop 10]
                [ decorativeImage NoStyle 
                    [ width (percent 20), verticalCenter, alignLeft ]
                    { src = config.paths.erosionPath }
                , 
                textLayout (Modal IntroWelcome)
                    [ paddingLeft 20, verticalCenter ] 
                    [ paragraph NoStyle
                        [ ]
                        [ el (AddStrategies StrategiesDetailsCategories) [] <| text "RESILIENT CAPE COD HOME PAGE" ]
                    ]
                , textLayout (Modal IntroWelcome)
                    [ paddingLeft 20 ] 
                    [ paragraph NoStyle
                        [ ]
                        [ el (AddStrategies StrategiesDetailsCategories) [] <| text "Link to Cape Cod Commission’s project homepage." ]
                    ] 
                ]
            ]
        ]
