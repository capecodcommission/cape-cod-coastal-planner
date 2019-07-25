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
                            [ width (px 500)
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
    column NoStyle
        [ ]
        [ column (Modal MethodsResourcesBackground)
            [width fill]
                [ row NoStyle
                    [width fill]
                        [ paragraph NoStyle
                            [verticalCenter]
                            [ el (Modal IntroWelcome) [paddingXY 10 10, verticalCenter, alignLeft] <| text "Description of how the tool works, including features, data sources, and background calculations."]
                        ]
                , row NoStyle
                    [width fill, center, paddingBottom 10]
                        [ newTab "https://barnstablecounty.sharepoint.com/:w:/g/dept/commission/team/Ef07YrVI4BdEq-j-NT4hMPgBQkVA3hE4sZMZ1cpklNzTHg?e=eaMAh3" <| el SelectShorelineButton [ width fill, height (px 26),paddingXY 6 3 ] (text "Download methods") ]
                ]
        ]