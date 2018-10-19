module View.StrategiesModal exposing (..)


import Dict as Dict exposing (Dict)
import Maybe.Extra as MEx
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
                        [ verticalCenter
                        , width fill
                        , height fill 
                        , paddingXY 16 0
                        ]
                        [ image (AddStrategies StrategiesHazardPicker) 
                            [ alignLeft
                            , onClick SelectPreviousHazard
                            , title "Select previous hazard"
                            , vary Secondary True
                            ] 
                            { src = trianglePath, caption = "left arrow" }
                        , el NoStyle [ width fill ] <| Element.text hazard.name
                        , image (AddStrategies StrategiesHazardPicker) 
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
        (Just strategies, Just selections) ->
            let
                before = ( Zipper.before selections |> List.map (strategyView strategies) )

                selected = [ Zipper.current selections |> selectedStrategyView strategies ]

                after = ( Zipper.after selections |> List.map (strategyView strategies) )
            in
                (before ++ selected ++ after)
                    |> MEx.values
            
        (_, _) ->
            [ el NoStyle [ center, verticalCenter ] <| 
                Element.text "No active strategies found" 
            ]


strategyView : Strategies -> Scalar.Id -> Maybe (Element MainStyles Variations Msg)
strategyView strategies ((Scalar.Id id) as strategyId) =
    strategies
        |> Dict.get id
        |> Maybe.map 
            (\strategy ->
                button (AddStrategies StrategiesSidebarListBtn)
                    [ height content
                    , paddingXY 16 8
                    , onClick (SelectStrategy strategyId)
                    , Attr.id <| getStrategyHtmlId strategyId
                    ] <| paragraph NoStyle [] [ Element.text strategy.name ]
            )


selectedStrategyView : Strategies -> Scalar.Id -> Maybe (Element MainStyles Variations Msg)
selectedStrategyView strategies ((Scalar.Id id) as strategyId) =
    strategies
        |> Dict.get id
        |> Maybe.map 
            (\strategy ->
                button (AddStrategies StrategiesSidebarListBtnSelected) 
                    [ height content
                    , paddingXY 16 8
                    , on "keydown" <| D.map HandleStrategyKeyboardEvent decodeKeyboardEvent
                    , Attr.id <| getStrategyHtmlId strategyId
                    ] <| paragraph NoStyle [] [ Element.text strategy.name ]        
            )
    


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
mainContentView { device, closePath, adaptationInfo } =
    let
        ( lbl, childViews ) =
            case adaptationInfo of
                Success info ->
                    let 
                        strategy = currentStrategy info

                        name = strategy |> Maybe.map .name |> Maybe.withDefault " "
                    in
                    ( name
                    , [ closeIconView closePath
                      , categoriesView info.categories strategy
                      ]
                    )
                
                Failure err ->
                    ( "Error Loading Strategies!"
                    , [ closeIconView closePath ]
                    )

                _ ->
                    ( " "
                    , [ closeIconView closePath ]
                    )
    in
    column NoStyle
        [ height fill, width fill ]
        [ headerDetailsView device lbl childViews ]

           
headerDetailsView : 
    Device
    -> String    
    -> List ( Element MainStyles Variations Msg )
    -> Element MainStyles Variations Msg
headerDetailsView device lbl viewsWithin =
    header (AddStrategies StrategiesDetailsHeader)
        [ width fill
        , height (px <| detailsHeaderHeight device)
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
                    Element.text lbl
                ]
            ]
            |> within viewsWithin                
        )


-- --
-- -- STRATEGY CATEGORIES
-- --

categoriesView : Categories -> Maybe Strategy -> Element MainStyles Variations Msg
categoriesView categories maybeStrategy =
    categories
        |> Dict.values
        |> List.map (categoryAppliesToStrategy maybeStrategy)
        |> List.indexedMap categoryView
        |> categoriesRowView


categoriesRowView : List (String, Element MainStyles Variations Msg) -> Element MainStyles Variations Msg
categoriesRowView views =
    el NoStyle 
        [ alignRight 
        , moveDown 50
        , moveLeft 50
        ] <| 
        Keyed.row NoStyle [ spacingXY 20 0 ] views


categoryView : Int -> ( Category, Bool ) -> (String, Element MainStyles Variations Msg)
categoryView index ( category, matched ) = 
    let
        srcPath =
            if matched == True then
                category.imagePathActive
            else 
                category.imagePathInactive
    in
    ( "category_view_" ++ (toString <| getId category.id)
    , Keyed.column NoStyle
        [ width (px 84), height (px 100) ]
        [ case srcPath of
            Just path ->
                categoryIconView path category.name matched

            Nothing ->
                categoryMissingIconView index "?" matched
        , categoryLabelView category.name matched
        ]
    )
    
   

categoryLabelView : String -> Bool -> ( String, Element MainStyles Variations Msg )
categoryLabelView lbl matched =
    ( "category_label_" ++ lbl
    , el (AddStrategies StrategiesDetailsCategories) 
        [ center
        , verticalCenter
        , paddingTop 8
        , vary Disabled (not matched) 
        ] <| 
            Element.text lbl
    )


categoryIconView : String -> String -> Bool -> ( String, Element MainStyles Variations Msg )
categoryIconView srcPath name matched =
    let
        keySuffix = 
            if matched == True then
                "active"
            else
                "inactive"
    in
    ( "category_icon_" ++ name ++ "_" ++ keySuffix
    , image NoStyle [ center, verticalCenter, width (px 84), height (px 84) ]
        { src = srcPath, caption = name  }
    )
    


categoryMissingIconView : Int -> String -> Bool -> ( String, Element MainStyles Variations Msg )
categoryMissingIconView index lbl matched =
    let
        keySuffix =
            if matched == True then
                "active"
            else
                "inactive"
    in
    ( "category_icon_missing_" ++ keySuffix
    , circle 39 (AddStrategies StrategiesDetailsCategoryCircle) 
        [ center
        , verticalCenter
        , vary Secondary (matched && index == 1)
        , vary Tertiary (matched && index == 2)
        , vary Disabled (not matched) 
        ] <| 
            el (AddStrategies StrategiesDetailsCategories) 
                [ center
                , verticalCenter
                , vary Disabled (not matched)
                ] <| 
                    Element.text lbl
    )
    

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