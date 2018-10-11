module View.StrategiesModal exposing (..)


import Types exposing (..)
import AdaptationStrategy exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Attributes as Attr exposing (..)
import Element.Events exposing (..)
import Styles exposing (..)
import View.Helpers exposing (..)
import RemoteData exposing (RemoteData(..))
import Keyboard.Event exposing (decodeKeyboardEvent)
import Graphqelm.Http exposing (Error(..), mapError)
import Json.Decode as D
import List.Zipper as Zipper


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


strategiesToCurrentDetails : GqlData Strategies -> ( Maybe String, GqlData (Maybe StrategyDetails) )
strategiesToCurrentDetails data =
    case data of
        NotAsked -> 
            ( Nothing, NotAsked )

        Loading -> 
            ( Nothing, Loading )

        Success Nothing -> 
            ( Nothing, Success Nothing )

        Success (Just strategies) ->
            strategies
                |> Zipper.current
                |> \(Strategy s) -> ( Just s.name, s.details )

        Failure err ->
            ( Nothing, Failure <| mapError (always Nothing) err )


view :
    { config
         | device : Device
         , closePath : String
         , strategies : GqlData Strategies
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
        , strategies : GqlData Strategies
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
        , strategies : GqlData Strategies
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
            [ height ( px <| activeStrategiesHeight config.device )
            ] <| 
                strategiesView config.strategies
        , footer (AddStrategies StrategiesSidebarFooter)
            [ width fill, height (px 89) ]
            ( el NoStyle [ center, verticalCenter ] <| Element.text "APPLY STRATEGY" )
        ]


strategiesView : GqlData Strategies -> List (Element MainStyles Variations Msg)
strategiesView data = 
 case data of
    NotAsked ->
        [ el NoStyle [ center, verticalCenter ] <| Element.text "Reload Strategies"
        ]

    Loading ->
        [ el NoStyle [ center, verticalCenter ] <| Element.text "Loading Strategies"
        ]

    Success (Just strategies) ->
        ( Zipper.before strategies |> List.map strategyView )
          ++ [ Zipper.current strategies |> selectedStrategyView ]
          ++ ( Zipper.after strategies |> List.map strategyView )
        

    Success Nothing ->
        [ el NoStyle [ center, verticalCenter ] <| Element.text "No active strategies found"
        ]

    Failure err ->
        [ el NoStyle [ center, verticalCenter ] <| Element.text "Error loading strategies"
        , el NoStyle [ center, verticalCenter ] <| Element.text "Reload Strategies"
        ]


strategyView : Strategy -> Element MainStyles Variations Msg
strategyView ( Strategy { id, name } as strategy) =
    button (AddStrategies StrategiesSidebarListBtn)
        [ height content
        , paddingXY 16 8
        , onClick (SelectStrategy id)
        , Attr.id <| getStrategyHtmlId strategy
        ] <| paragraph NoStyle [] [ Element.text name ]



selectedStrategyView : Strategy -> Element MainStyles Variations Msg
selectedStrategyView ( Strategy { id, name } as strategy) =
    button (AddStrategies StrategiesSidebarListBtnSelected) 
        [ height content
        , paddingXY 16 8
        , on "keydown" <| D.map HandleStrategyKeyboardEvent decodeKeyboardEvent
        , Attr.id <| getStrategyHtmlId strategy
        ] <| paragraph NoStyle [] [ Element.text name ]


mainContentView : 
    { config
        | device : Device
        , closePath : String
        , strategies : GqlData Strategies
    }
    -> Element MainStyles Variations Msg
mainContentView config =
    column NoStyle
        [ scrollbars, height fill, width fill ]
        ( case strategiesToCurrentDetails config.strategies of
            (_, NotAsked) ->
                [ Element.text "Not Asked" ]

            (_, Loading) ->
                [ Element.text "Loading" ]

            (Just name, Success (Just details)) ->
                [ headerDetailsView 
                    { device = config.device
                    , closePath = config.closePath
                    , name = name
                    , details = details
                    }
                ]

            (Just name, Success Nothing) ->
                [ Element.text <| "Details for " ++ name ++ " not found" ]

            (Nothing, Success _) ->
                [ Element.text "Strategy details not found" ]

            (_, Failure err) ->
                err 
                    |> parseErrors 
                    |> List.map 
                        (\(s1, s2) ->
                            Element.text (s1 ++ ": " ++ s2)
                        )

        )
        
headerDetailsView : 
    { config
        | device : Device
        , name : String
        , closePath : String
        , details : StrategyDetails
    }
    -> Element MainStyles Variations Msg
headerDetailsView config =
    header (AddStrategies StrategiesDetailsHeader)
        [ width fill
        , height (px <| detailsHeaderHeight config.device)
        ]
        (column NoStyle
            [ height fill, width fill, paddingXY 40 10, spacingXY 0 5 ]
            [ h3 (Headings H3) [ width fill, height (px 65) ] <| Element.text config.name ]
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