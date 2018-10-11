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
         , adaptationCategories : GqlData Categories
         , adaptationBenefits : GqlData Benefits
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
        , adaptationCategories : GqlData Categories
        , adaptationBenefits : GqlData Benefits
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
        , adaptationCategories : GqlData Categories
        , adaptationBenefits : GqlData Benefits
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
                    , categories = config.adaptationCategories
                    , benefits = config.adaptationBenefits
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
        , closePath : String
        , name : String
        , categories : GqlData Categories
        , benefits : GqlData Benefits
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
            [ el NoStyle [ width fill, height (percent 40) ] 
                <| el (AddStrategies StrategiesSheetHeading) [ verticalCenter ] <| 
                    Element.text "ADAPTATION STRATEGIES SHEET"
            , column NoStyle [ width fill, height (percent 60), verticalCenter ]
                [ el (AddStrategies StrategiesSubHeading) [] <| Element.text "Strategy:"
                , el (AddStrategies StrategiesMainHeading) [] <| Element.text config.name
                ]
            ]
            |> within 
                [ closeIconView config.closePath 
                , categoriesView config.categories config.details.categories
                ]
        )


--
-- STRATEGY CATEGORIES
--

categoriesView : GqlData Categories -> Categories -> Element MainStyles Variations Msg
categoriesView allCategories stratCategories =
    case ( allCategories, stratCategories ) of
        ( Success allCats, cats ) ->
            -- show available categories as compared with master list
            allCats
                |> List.map
                    (\c -> categoryView (hasCategory cats c) c)
                |> categoriesRowView

        ( _, [] ) ->
            -- show empty stuff?
            empty
        
        ( _, cats ) ->
            -- show available categories
            cats
                |> List.map (categoryView True) 
                |> categoriesRowView
        

categoriesRowView : List (Element MainStyles Variations Msg) -> Element MainStyles Variations Msg
categoriesRowView views =
    el NoStyle 
        [ alignRight 
        , moveDown 50
        , moveLeft 50
        ] <| 
        row NoStyle [ spacingXY 20 0 ] views

categoryView : Bool -> Category -> Element MainStyles Variations Msg
categoryView matched category = 
    column NoStyle
        []
        [ circle 39 (AddStrategies StrategiesDetailsCategoryIcon) 
            [ center
            , verticalCenter
            , vary Disabled (not matched) 
            ] <| 
                el (AddStrategies StrategiesDetailsCategories) 
                    [ center
                    , verticalCenter 
                    , vary Disabled (not matched)
                    ] <| 
                        Element.text "icon"
        , el (AddStrategies StrategiesDetailsCategories) 
            [ center
            , verticalCenter
            , paddingTop 8
            , vary Disabled (not matched) 
            ] <| 
                Element.text category.name
        ]


hasCategory : Categories -> Category -> Bool
hasCategory categories category =
    categories
        |> List.filter (\c -> c.name == category.name)
        |> (not << List.isEmpty)


closeIconView : String -> Element MainStyles Variations Msg
closeIconView srcPath =
    image CloseIcon 
        [ alignRight
        , moveDown 15
        , moveLeft 15
        , title "Close strategy selection"
        , onClick CloseStrategyModal
        ]
        { src = srcPath, caption = "Close Modal" }