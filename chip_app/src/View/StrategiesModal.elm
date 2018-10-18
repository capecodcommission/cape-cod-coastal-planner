module View.StrategiesModal exposing (..)


import Dict as Dict exposing (Dict)
import Types exposing (..)
import AdaptationStrategy as AS exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Keyed as Keyed
import Element.Attributes as Attr exposing (..)
import Element.Events exposing (..)
import Styles exposing (..)
import View.Helpers exposing (..)
import RemoteData as Remote exposing (RemoteData(..))
import Keyboard.Event exposing (decodeKeyboardEvent)
import Graphqelm.Http exposing (Error(..), mapError)
import ChipApi.Scalar as Scalar
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


view : 
    { config 
        | device : Device
        , closePath : String
        , trianglePath : String
        , adaptationInfo : GqlData AdaptationInfo
    }
    -> Element MainStyles Variations Msg
view config =
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
        | device : Device
        , trianglePath : String
        , adaptationInfo : GqlData AdaptationInfo
    }
    -> Element MainStyles Variations Msg
sidebarView config =
    let
        maybeInfo = config.adaptationInfo |> Remote.toMaybe

        strategies = maybeInfo |> Maybe.map .strategies

        currentHazard = maybeInfo |> Maybe.andThen .hazards |> Maybe.map Zipper.current

        strategyIds = 
            currentHazard |> Maybe.andThen .strategies
    in
    sidebar (AddStrategies StrategiesSidebar)
        [ width (px 400)
        , height fill
        ]
        [ header (AddStrategies StrategiesSidebarHeader)
            [ width fill, height (px 58) ] <|
                hazardPickerView config.device config.trianglePath currentHazard
        , column (AddStrategies StrategiesSidebarList)
            [ height ( px <| activeStrategiesHeight config.device ) ] <| 
                strategiesView strategies strategyIds
        , footer (AddStrategies StrategiesSidebarFooter)
            [ width fill, height (px 90) ]
            ( el NoStyle [ center, verticalCenter ] <| 
                button ActionButton
                    [ width (px 274)
                    , height (px 42)
                    , title "Apply strategy"
                    ] <| Element.text "APPLY STRATEGY"         
            )
        ]


hazardPickerView : Device -> String -> Maybe CoastalHazard -> Element MainStyles Variations Msg
hazardPickerView device trianglePath currentHazard = 
    h5 (Headings H5) 
        [ height fill, width fill ] <| 
            case currentHazard of
                Just hazard ->
                    row NoStyle
                        [ verticalCenter, width fill, height fill ]
                        [ image NoStyle 
                            [ alignLeft
                            , onClick SelectPreviousHazard
                            , title "Select previous hazard"
                            ] 
                            { src = trianglePath, caption = "left arrow" }
                        , el NoStyle [ width fill ] <| Element.text hazard.name
                        , image NoStyle 
                            [ alignRight
                            , onClick SelectNextHazard
                            , title "Select next hazard"
                            ] 
                            { src = trianglePath, caption = "right arrow" }
                        ]

                Nothing -> 
                    el NoStyle [] empty
    


strategiesView : Maybe Strategies -> Maybe StrategyIdZipper -> List (Element MainStyles Variations Msg)
strategiesView maybeStrategies maybeSelections =
    case (maybeStrategies, maybeSelections) of
        -- (Just strategies, Just selections) ->
        --     ( Zipper.before selections |> List.map (strategyView strategies))
        --     ++ [ Zipper.current selections |> selectedStrategyView strategies ]
        --     ++ ( Zipper.after selections |> List.map (strategyView strategies) )

        (_, _) ->
            [ el NoStyle [ center, verticalCenter ] <| 
                Element.text "No active strategies found" 
            ]


-- strategyView : Strategies -> Scalar.Id -> Element MainStyles Variations Msg
-- strategyView strategies ((Scalar.Id id) as strategyId) =
--     let
--         strategy = strategies |> Dict.get id  
--     in
    
--     button (AddStrategies StrategiesSidebarListBtn)
--         [ height content
--         , paddingXY 16 8
--         , onClick (SelectStrategy strategyId)
--         , Attr.id <| getStrategyHtmlId strategyId
--         ] <| paragraph NoStyle [] [ Element.text name ]



-- selectedStrategyView : Strategy -> Element MainStyles Variations Msg
-- selectedStrategyView ({ id, name } as strategy) =
--     button (AddStrategies StrategiesSidebarListBtnSelected) 
--         [ height content
--         , paddingXY 16 8
--         , on "keydown" <| D.map HandleStrategyKeyboardEvent decodeKeyboardEvent
--         , Attr.id <| getStrategyHtmlId strategy
--         ] <| paragraph NoStyle [] [ Element.text name ]


-- --
-- -- MAIN CONTENT VIEWS 
-- --


mainContentView : 
    { config
        | device : Device
        , closePath : String
        , adaptationInfo : GqlData AdaptationInfo
    }
    -> Element MainStyles Variations Msg
mainContentView config =
    column NoStyle
        [ scrollbars, height fill, width fill ]
        [ headerDetailsView config
        ]
        -- ( case strategiesToCurrentDetails config.strategies of
        --     (maybeName, NotAsked) ->
        --         [ headerDetailsLoadingView
        --             { device = config.device 
        --             , closePath = config.closePath
        --             , name = maybeName
        --             , categories = config.adaptationCategories
        --             } 
        --         ]

        --     (maybeName, Loading) ->
        --         [ headerDetailsLoadingView
        --             { device = config.device 
        --             , closePath = config.closePath
        --             , name = maybeName
        --             , categories = config.adaptationCategories
        --             }
        --         ]

        --     (Just name, Success (Just details)) ->
        --         [ headerDetailsView
        --             { device = config.device
        --             , closePath = config.closePath
        --             , name = name
        --             , categories = config.adaptationCategories
        --             , details = details
        --             }
        --         ]

        --     (Just name, Success Nothing) ->
        --         [ Element.text <| "Details for " ++ name ++ " not found" ]

        --     (Nothing, Success _) ->
        --         [ Element.text "Strategy details not found" ]

        --     (_, Failure err) ->
        --         err 
        --             |> parseErrors 
        --             |> List.map 
        --                 (\(s1, s2) ->
        --                     Element.text (s1 ++ ": " ++ s2)
        --                 )
        -- )
        
headerDetailsView : 
    { config
        | device : Device
        , closePath : String
        --, name : String
        --, categories : GqlData Categories
        --, details : StrategyDetails
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
                [ el (AddStrategies StrategiesSubHeading) [] <| 
                    Element.text "Strategy:"
                , el (AddStrategies StrategiesMainHeading) [] <| 
                    Element.text "NAME" --config.name
                ]
            ]
            |> within 
                [ closeIconView config.closePath 
                --, categoriesView config.categories config.details.categories
                ]
        )


-- headerDetailsLoadingView : 
--     { config
--         | device : Device
--         , closePath : String
--         , name : Maybe String
--         , categories : GqlData Categories
--     }
--     -> Element MainStyles Variations Msg
-- headerDetailsLoadingView config =
--     header (AddStrategies StrategiesDetailsHeader)
--         [ width fill
--         , height (px <| detailsHeaderHeight config.device)
--         ]
--         (column NoStyle
--             [ height fill, width fill, paddingXY 40 10, spacingXY 0 5 ]
--             [ el NoStyle [ width fill, height (percent 40) ] 
--                 <| el (AddStrategies StrategiesSheetHeading) [ verticalCenter ] <| 
--                     Element.text "ADAPTATION STRATEGIES SHEET"
--             , column NoStyle [ width fill, height (percent 60), verticalCenter ]
--                 [ el (AddStrategies StrategiesSubHeading) [] <| 
--                     Element.text "Strategy:"
--                 , el (AddStrategies StrategiesMainHeading) [] <| 
--                     Element.text " "
--                 ]
--             ]
--             |> within 
--                 [ closeIconView config.closePath 
--                 , categoriesView config.categories []
--                 ]
--         )


-- --
-- -- STRATEGY CATEGORIES
-- --

-- categoriesView : GqlData Categories -> List CategoryId -> Element MainStyles Variations Msg
-- categoriesView allCategories stratCategoryIds =
--     case ( allCategories, stratCategoryIds ) of
--         ( NotAsked, [] ) ->
--             [ 0, 1, 2 ]
--                 |> List.map categoryLoadingView
--                 |> categoriesRowView

--         ( Loading, [] ) ->
--             [ 0, 1, 2 ]
--                 |> List.map categoryLoadingView
--                 |> categoriesRowView

--         ( Success _, [] ) ->
--             [ 0, 1, 2 ]
--                 |> List.map categoryLoadingView
--                 |> categoriesRowView

--         ( Failure _, [] ) ->
--             [ 0, 1, 2 ]
--                 |> List.map categoryErrorView
--                 |> categoriesRowView
        
--         ( Success allCats, catIds ) ->
--             -- show master list of categories as compared against strats cats
--             allCats
--                 |> Dict.values
--                 |> List.indexedMap
--                     (\i c -> 
--                         categoryView (categoryIdsHasCategory c catIds) i c
--                     )
--                 |> categoriesRowView
       
--         ( _, cats ) ->
--             -- show available categories from strategy
--             cats
--                 |> categoryIdsToCategories
--                 |> List.indexedMap (categoryView True) 
--                 |> categoriesRowView
        

-- categoriesRowView : List (String, Element MainStyles Variations Msg) -> Element MainStyles Variations Msg
-- categoriesRowView views =
--     el NoStyle 
--         [ alignRight 
--         , moveDown 50
--         , moveLeft 50
--         ] <| 
--         Keyed.row NoStyle [ spacingXY 20 0 ] views


-- categoryView : Bool -> Int -> Category -> (String, Element MainStyles Variations Msg)
-- categoryView matched index category = 
--     let
--         srcPath =
--             if matched == True then
--                 category.imagePathActive
--             else 
--                 category.imagePathInactive
--     in
--     ( "category_view_" ++ toString index
--     , Keyed.column NoStyle
--         [ width (px 84), height (px 100) ]
--         [ case srcPath of
--             Just path ->
--                 categoryIconView path category.name matched

--             Nothing ->
--                 categoryMissingIconView index "?" matched
--         , categoryLabelView category.name matched
--         ]
--     )
    


-- categoryLoadingView : Int -> ( String, Element MainStyles Variations Msg )
-- categoryLoadingView index =
--     ( "category_loading_view_" ++ toString index
--     , Keyed.column NoStyle
--         [ width (px 84), height (px 100) ]
--         [ categoryMissingIconView index "..." False 
--         , categoryLabelView "loading" False 
--         ]
--     )
    


-- categoryErrorView : Int -> (String, Element MainStyles Variations Msg)
-- categoryErrorView index =
--     ( "category_error_view_" ++ toString index
--     , Keyed.column NoStyle
--         [ width (px 84), height (px 100) ]
--         [ categoryMissingIconView index "!" False 
--         , categoryLabelView "error" False
--         ]
--     )
    


-- categoryLabelView : String -> Bool -> ( String, Element MainStyles Variations Msg )
-- categoryLabelView lbl matched =
--     ( "category_label_" ++ lbl
--     , el (AddStrategies StrategiesDetailsCategories) 
--         [ center
--         , verticalCenter
--         , paddingTop 8
--         , vary Disabled (not matched) 
--         ] <| 
--             Element.text lbl
--     )


-- categoryIconView : String -> String -> Bool -> ( String, Element MainStyles Variations Msg )
-- categoryIconView srcPath captionText matched =
--     let
--         keySuffix = 
--             if matched == True then
--                 "active"
--             else
--                 "inactive"
--     in
--     ( "category_icon_" ++ captionText ++ "_" ++ keySuffix
--     , image NoStyle [ center, verticalCenter, width (px 84), height (px 84) ]
--         { src = srcPath, caption = captionText  }
--     )
    


-- categoryMissingIconView : Int -> String -> Bool -> ( String, Element MainStyles Variations Msg )
-- categoryMissingIconView index lbl matched =
--     let
--         keySuffix =
--             if matched == True then
--                 "active"
--             else
--                 "inactive"
--     in
--     ( "category_icon_missing_" ++ keySuffix
--     , circle 39 (AddStrategies StrategiesDetailsCategoryCircle) 
--         [ center
--         , verticalCenter
--         , vary Secondary (matched && index == 1)
--         , vary Tertiary (matched && index == 2)
--         , vary Disabled (not matched) 
--         ] <| 
--             el (AddStrategies StrategiesDetailsCategories) 
--                 [ center
--                 , verticalCenter
--                 , vary Disabled (not matched)
--                 ] <| 
--                     Element.text lbl
--     )
    

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