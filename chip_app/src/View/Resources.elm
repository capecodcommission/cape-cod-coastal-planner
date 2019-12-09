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
                            [ width (px 800)
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
    column (Modal MethodsResourcesBackground)
        [ ]
        [ row NoStyle
            [ width fill, height (percent 33), paddingXY 10 10 ]
                [ column NoStyle
                    [ width fill, paddingXY 10 0 ]
                        [ textLayout NoStyle
                            [ verticalCenter, paddingBottom 5 ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ newTab "https://barnstablecounty.sharepoint.com/:x:/g/dept/commission/team/EbU6Sj-gMzxLmWSlU2hQW8wB6ozqMsIM7MnpwsiNpCyitQ?e=UcmtRe" <| el (Modal MethodsResourcesModalHeading) [] (text "ADAPTATION STRATEGIES MATRIX") ]
                                ]
                        , textLayout NoStyle
                            [ verticalCenter, width fill ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ el (Modal MethodsResourcesModal) [] <| text "Excel spreadsheet describing in detail possible adaptation strategies, including siting and permitting considerations and process." ]
                                ]
                        ]
                , column NoStyle
                    [ width fill, paddingXY 10 0 ]
                        [ textLayout NoStyle
                            [ verticalCenter, paddingBottom 5 ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ newTab "https://gcc02.safelinks.protection.outlook.com/?url=http%3A%2F%2Fww2.capecodcommission.org%2Fcoastal%2F&data=02%7C01%7Csgoulet%40capecodcommission.org%7Ca763fe821bcf4c4274a908d7314f92ca%7C84475217b42348dbb766ed4bbbea74f1%7C0%7C0%7C637032090136269375&sdata=b4O2KLVJbVU25Xzllt%2BXbHVOJcwiSe3zlRXNI9dbh2Q%3D&reserved=0" <| el (Modal MethodsResourcesModalHeading) [] (text "ADAPTATION STRATEGIES FACT SHEETS") ]
                                ]
                        , textLayout NoStyle
                            [ verticalCenter, width fill ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ el (Modal MethodsResourcesModal) [] <| text "Educational handouts on a subset of Adaptation Strategies found in the Cape Cod Coastal Planner." ]
                                ]
                        ]
                ]
            , el NoStyle 
                [ paddingXY 5 0 ] <| hairline (MethodsResourcesBackgroundLine)
            , row NoStyle
                [ width fill, height (percent 33), paddingXY 10 10 ]
                [ column NoStyle
                    [ width fill, paddingXY 10 0 ]
                        [ textLayout NoStyle
                            [ verticalCenter, paddingBottom 5 ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ newTab "https://spark.adobe.com/page/H3TgtzULGkbjH/" <| el (Modal MethodsResourcesModalHeading) [] (text "RESILIENT CAPE COD SPARK PAGE") ]
                                ]
                        , textLayout NoStyle
                            [ verticalCenter, width fill ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ el (Modal MethodsResourcesModal) [] <| text "Website describing the 3-year Resilient Cape Cod project." ]
                                ]
                        ]
                , column NoStyle
                    [ width fill, paddingXY 10 0 ]
                        [ textLayout NoStyle
                            [ verticalCenter, paddingBottom 5 ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ newTab "https://gcc01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fcccommission.maps.arcgis.com%2Fapps%2FMapJournal%2Findex.html%3Fappid%3D49b16395cc114c32ab548a5ac167ec5d&data=02%7C01%7Csgoulet%40capecodcommission.org%7C4a8598e5c01f410e271b08d6b93f122d%7C84475217b42348dbb766ed4bbbea74f1%7C0%7C0%7C636900077868969463&sdata=l0DX4gjiDt4eFDZbH1iaIADjl%2FTv3AJcE2Th%2BzzxiWI%3D&reserved=0" <| el (Modal MethodsResourcesModalHeading) [] (text "LOCAL STORIES OF COASTAL IMPACTS") ]
                                ]
                        , textLayout NoStyle
                            [ verticalCenter, width fill ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ el (Modal MethodsResourcesModal) [] <| text "ESRI Storymap of stakeholder-sourced case studies of coastal impacts due to sea level rise, erosion, and storm surge." ]
                                ]
                        ]
                ]
            , el NoStyle 
                [ paddingXY 5 0 ] <| hairline (MethodsResourcesBackgroundLine)
            , row NoStyle
                [ width fill, height (percent 33), paddingXY 10 10 ]
                [ column NoStyle
                    [ width fill, paddingXY 10 0 ]
                        [ textLayout NoStyle
                            [ verticalCenter, paddingBottom 5 ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ newTab "https://barnstablecounty-my.sharepoint.com/:b:/g/personal/danielle_donahue_capecodcommission_org/EQG_lIZF7jRIpP4PZVrgx18BfhEY-lAasg7lMGiPvCipSg?e=yQgdiN" <| el (Modal MethodsResourcesModalHeading) [] (text "ECOSYSTEM SERVICES HANDOUT") ]
                                ]
                        , textLayout NoStyle
                            [ verticalCenter, width fill ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ el (Modal MethodsResourcesModal) [] <| text "Educational handout describing ecosystem services used during the Resilient Cape Cod stakeholder process." ]
                                ]
                        ]
                , column NoStyle
                    [ width fill, paddingXY 10 0 ]
                        [ textLayout NoStyle
                            [ verticalCenter, paddingBottom 5 ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ newTab "https://www.capecodcommission.org/our-work/resilient-cape-cod" <| el (Modal MethodsResourcesModalHeading) [] (text "RESILIENT CAPE COD HOME PAGE") ]
                                ]
                        , textLayout NoStyle
                            [ verticalCenter, width fill ] 
                                [ paragraph NoStyle
                                [ width fill ]
                                    [ el (Modal MethodsResourcesModal) [] <| text "Link to Cape Cod Commission’s project homepage." ]
                                ]
                        ]
                ]
        ]