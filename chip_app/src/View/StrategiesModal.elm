module View.StrategiesModal exposing (..)


import Types exposing (..)
import AdaptationStrategy exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Styles exposing (..)
import View.Helpers exposing (..)
import RemoteData exposing (RemoteData(..))
import ChipApi.Scalar as Scalar


modalHeight : Device -> Float
modalHeight device =
    adjustOnHeight ( 580, 1000 ) device


detailsHeaderHeight : Device -> Float
detailsHeaderHeight device =
    adjustOnHeight ( 165, 225 ) device


sidebarHeaderHeight : Float
sidebarHeaderHeight = 58

sidebarFooterHeight : Float
sidebarFooterHeight = 89


activeStrategiesHeight : Device -> Float
activeStrategiesHeight device =
    (modalHeight device) - (sidebarHeaderHeight + sidebarFooterHeight)


view :
    { config
         | device : Device
         , closePath : String
         , strategies : Strategies
         , activeStrategies : GqlData ActiveStrategies
         , strategiesModalOpenness : Openness
    }
    -> Element MainStyles Variations Msg
view config =
    case config.strategiesModalOpenness of
        Closed ->
            el NoStyle [] empty

        Open ->
            modalView config


modalView : 
    { config 
        | device : Device
        , closePath : String
        , strategies : Strategies
        , activeStrategies : GqlData ActiveStrategies        
    }
    -> Element MainStyles Variations Msg
modalView config =
    column NoStyle
        []
        [ modal (Modal ModalBackground)
            [ height fill
            , width fill
            , padding 90
            ] <|
            el (Modal ModalContainer)
                [ width (px 1200)
                , maxHeight (px <| modalHeight config.device)
                , center
                , verticalCenter
                ] <|
                row NoStyle 
                    [ height fill ] 
                    [ sidebarView config
                    , mainContentView config
                    ]
        ]


sidebarView :
    { config
        | device: Device
        , activeStrategies : GqlData ActiveStrategies
    }
    -> Element MainStyles Variations Msg
sidebarView config =
    sidebar (AddStrategies StrategiesSidebar)
        [ width (px 400)
        , height fill
        ]
        [ header (AddStrategies StrategiesSidebarHeader)
            [ width fill, height (px 58) ]
            ( h5 (Headings H5) 
                [ center
                , verticalCenter
                , height fill
                ] <| 
                    Element.text "Erosion Strategies" 
            )
        , column (AddStrategies StrategiesSidebarList)
            [ height ( px <|activeStrategiesHeight config.device ) 
            ] <| 
                activeStrategiesView config.activeStrategies
        , footer (AddStrategies StrategiesSidebarFooter)
            [ width fill, height (px 89) ]
            ( el NoStyle [ center, verticalCenter ] <| Element.text "APPLY STRATEGY" )
        ]


activeStrategiesView : GqlData ActiveStrategies -> List (Element MainStyles Variations Msg)
activeStrategiesView data = 
 case data of
    NotAsked ->
        [ el NoStyle [ center, verticalCenter ] <| Element.text "Reload Strategies"
        ]

    Loading ->
        [ el NoStyle [ center, verticalCenter ] <| Element.text "Loading Strategies"
        ]

    Success { items } ->
        List.map activeStrategyView items


    Failure err ->
        [ el NoStyle [ center, verticalCenter ] <| Element.text "Error loading strategies"
        , el NoStyle [ center, verticalCenter ] <| Element.text "Reload Strategies"
        ]


activeStrategyView : 
    { item
        | id : Scalar.Id
        , name : String
    }
    -> Element MainStyles Variations Msg
activeStrategyView item =
    button (AddStrategies StrategiesSidebarListBtn) 
        [ height content
        , padding 8
        ] <| el NoStyle [ alignLeft, paddingXY 8 0 ] <| Element.text item.name



mainContentView : 
    { config
        | device : Device
        , closePath : String
    }
    -> Element MainStyles Variations Msg
mainContentView config =
    column NoStyle
        [ scrollbars, height fill, width fill ]
        [ header (AddStrategies StrategiesDetailsHeader)
            [ width fill
            , height (px <| detailsHeaderHeight config.device)
            ]
            (column NoStyle
                [ height fill, width fill, paddingXY 40 10, spacingXY 0 5 ]
                [ h3 (Headings H3) [ width fill, height (px 65) ] <| Element.text "TITLE" ]
                |> within
                    [ image CloseIcon 
                        [ alignRight
                        , moveDown 15
                        , moveLeft 15
                        , title "Close strategy selection"
                        , onClick CloseStrategyModal
                        ]
                        { src = config.closePath, caption = "Close Modal" }
                    ]
            )
            
        ]

        


