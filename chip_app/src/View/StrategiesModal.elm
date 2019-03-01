module View.StrategiesModal exposing (..)


import Dict as Dict exposing (Dict)
import Maybe.Extra as MEx
import Types exposing (..)
import AdaptationStrategy.AdaptationInfo as Info exposing (AdaptationInfo)
import AdaptationStrategy.Categories as Categories exposing (Categories, Category)
import AdaptationStrategy.CoastalHazards as Hazards exposing (CoastalHazards, CoastalHazard)
import AdaptationStrategy.Strategies as Strategies exposing (Strategies, Strategy)
import AdaptationStrategy.StrategyDetails as Details exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Keyed as Keyed
import Element.Attributes as Attr exposing (..)
import Element.Events exposing (..)
import Color
import Styles exposing (..)
import Graphics.Erosion exposing (erosionIcon, erosionIconConfig)
import Graphics.SeaLevelRise exposing (seaLevelRiseIcon, seaLevelRiseIconConfig)
import Graphics.StormSurge exposing (stormSurgeIcon, stormSurgeIconConfig)
import View.ModalImage as ModalImage
import View.Helpers exposing (..)
import RemoteData as Remote exposing (RemoteData(..))
import Keyboard.Event exposing (decodeKeyboardEvent)
import ChipApi.Scalar as Scalar
import Json.Decode as D
import List.Zipper as Zipper exposing (Zipper)
import AdaptationOutput exposing (..)
import AdaptationStrategy.Impacts as Impacts


modalHeight : Device -> Float
modalHeight device =
    adjustOnHeight ( 525, 650 ) device


detailsHeaderHeight : Device -> Float
detailsHeaderHeight device =
    adjustOnHeight ( 70, 120 ) device

mainHeight : Device -> Float
mainHeight device =
    (modalHeight device) - (detailsHeaderHeight device)


sidebarHeaderHeight : Float
sidebarHeaderHeight = 120

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
        , slrPath : String
    }
    -> GqlData AdaptationInfo
    -> ZoneOfImpact
    -> AdaptationOutput
    -> Element MainStyles Variations Msg
view config adaptationInfo zoneOfImpact outputDetails =
    column NoStyle
        []
        [ modal (Modal ModalBackground)
            [ height fill
            , width fill
            , padding 90
            ] <|
            el (Modal ModalContainer)
                [ width (px 1300)
                , maxHeight (px <| modalHeight config.device)
                , center
                , verticalCenter
                ] <|
                row NoStyle 
                    [ height fill ]
                    [ sidebarView config adaptationInfo zoneOfImpact 
                    , mainContentView config adaptationInfo outputDetails
                    ]
        ]


sidebarView :
    { config
        | device : Device
        , trianglePath : String
        , slrPath :String
    }
    -> GqlData AdaptationInfo
    -> ZoneOfImpact
    -> Element MainStyles Variations Msg
sidebarView { device, trianglePath, slrPath } adaptationInfo zoneOfImpact =
    let
        currentHazard =
            adaptationInfo
                |> Remote.toMaybe
                |> Info.currentHazard


        currentStrategy =
            adaptationInfo
                |> Remote.toMaybe
                |> Info.currentStrategy
    in
    sidebar (AddStrategies StrategiesSidebar)
        [ width (px 400)
        , height fill
        ]
        [ header (AddStrategies StrategiesSidebarHeader)
            [ height ( px sidebarHeaderHeight ) ] <| 
                hazardPickerView device trianglePath currentHazard slrPath
        , column (AddStrategies StrategiesSidebarList)
            [ height ( px <| activeStrategiesHeight device ) ] <| 
                strategiesView zoneOfImpact adaptationInfo
        , footer (AddStrategies StrategiesSidebarFooter)
            [ width fill, height (px sidebarFooterHeight) ]
            ( el NoStyle [ center, verticalCenter ] <| 
                applyStrategyButton currentStrategy
            )
        ]


hazardPickerView : Device -> String -> Maybe CoastalHazard -> String -> Element MainStyles Variations Msg
hazardPickerView device trianglePath currentHazard slrPath = 
    h5 (Headings H5) 
        [ height fill, width fill ] <| 
            case currentHazard of
                Just hazard ->
                    row NoStyle
                            [ verticalCenter
                            , width fill
                            , height fill
                            , paddingXY 16 0
                            , paddingTop 16
                            ]
                        [ column NoStyle [alignLeft]
                             [ image (AddStrategies StrategiesHazardPicker) 
                                [ alignLeft
                                , onClick SelectPreviousHazard
                                , title "Select previous hazard"
                                , vary Secondary True
                                ] 
                                { src = trianglePath, caption = "left arrow" }
                             ]
                        , column NoStyle [center]
                            [ column NoStyle
                                [ alignBottom
                                , verticalCenter
                                , height (percent 50)
                                , center
                                ]
                                [ image (AddStrategies StrategiesHazardPicker) 
                                    [ center
                                    , width (percent 20)
                                    ] 
                                    { src = slrPath, caption = "selected hazard" }
                            , column NoStyle
                                [
                                width fill
                                , height (percent 50)
                                , center
                                ]
                                [ el NoStyle [ width fill ] <| Element.text hazard.name ]
                                ]
                            ]
                        , column NoStyle [alignRight]
                            [ image (AddStrategies StrategiesHazardPicker) 
                                [ alignRight
                                , onClick SelectNextHazard
                                , title "Select next hazard"
                                ] 
                                { src = trianglePath, caption = "right arrow" }
                            ]
                        ]

                Nothing -> 
                    el NoStyle [] empty
    

type alias ApplicableStrategy =
    { id : Scalar.Id
    , htmlId : String
    , name : String
    , isApplicable : Bool
    }


toApplicableStrategy : ZoneOfImpact -> Maybe Strategy -> Maybe ApplicableStrategy
toApplicableStrategy zoneOfImpact maybeStrategy =
    maybeStrategy
        |> Maybe.map
            (\strategy ->
                ApplicableStrategy
                    strategy.id
                    ("strategy-" ++ getId strategy.id)
                    strategy.name
                    (Strategies.isApplicableToZoneOfImpact zoneOfImpact strategy)        
            )


strategiesView : ZoneOfImpact -> GqlData AdaptationInfo -> List (Element MainStyles Variations Msg)
strategiesView zoneOfImpact adaptationInfo =
    case Info.availableStrategies adaptationInfo of
        Just strategies ->
            let
                before = 
                    Zipper.before strategies 
                        |> List.map (toApplicableStrategy zoneOfImpact) 
                        |> List.map strategyView

                selected = 
                    Zipper.current strategies
                        |> toApplicableStrategy zoneOfImpact
                        |> selectedStrategyView
                        |> List.singleton

                after = 
                    Zipper.after strategies 
                        |> List.map (toApplicableStrategy zoneOfImpact)
                        |> List.map strategyView
            in
                (before ++ selected ++ after)
                    |> MEx.values
            
        Nothing ->
            [ el NoStyle [ center, verticalCenter ] <| 
                Element.text "No active strategies found" 
            ]


strategyView : Maybe ApplicableStrategy -> Maybe (Element MainStyles Variations Msg)
strategyView maybeStrategy =
    maybeStrategy
        |> Maybe.map
            (\strategy ->
                case strategy.isApplicable of
                    True ->
                        button (AddStrategies StrategiesSidebarListBtn)
                            [ height content
                            , paddingXY 16 8
                            , onClick <| SelectStrategy strategy.id
                            , Attr.id strategy.htmlId
                            ] <| paragraph NoStyle [] [ el NoStyle [] <| Element.text strategy.name ]

                    False ->
                        el (AddStrategies StrategiesSidebarListBtnDisabled)
                            [ height content
                            , paddingXY 16 8
                            , Attr.id strategy.htmlId
                            ] <| paragraph NoStyle [] 
                                [ el NoStyle [ width fill ] <| Element.text strategy.name
                                , el NoStyle [ alignRight ] <| Element.text "(n/a for selection)"
                                ]
            )

selectedStrategyView : Maybe ApplicableStrategy -> Maybe (Element MainStyles Variations Msg)
selectedStrategyView maybeStrategy =
    maybeStrategy
        |> Maybe.map 
            (\strategy ->
                button (AddStrategies StrategiesSidebarListBtnSelected) 
                    [ height content
                    , paddingXY 16 8
                    , on "keydown" <| D.map HandleStrategyKeyboardEvent decodeKeyboardEvent
                    , Attr.id strategy.htmlId
                    ] <| paragraph NoStyle [] [ Element.text strategy.name ]        
            )


applyStrategyButton : Maybe Strategy ->  Element MainStyles Variations Msg
applyStrategyButton maybeStrategy =
    maybeStrategy
        |> Maybe.map .details
        |> Maybe.andThen Remote.toMaybe
        |> MEx.join
        |> Maybe.map
            (\details ->
                button ActionButton
                    [ width (px 274)
                    , height (px 42)
                    , title "Apply strategy"
                    , onClick <| ApplyStrategy details Nothing
                    , on "keydown" <| D.map (ApplyStrategy details) <| D.map Just decodeKeyboardEvent
                    ] <| Element.text "APPLY STRATEGY"
            )
        |> Maybe.withDefault
            ( button ActionButton
                [ width (px 274)
                , height (px 42)
                , title "Apply strategy"
                , vary Disabled True
                ] <| Element.text "APPLY STRATEGY"
            )


-- --
-- -- MAIN CONTENT VIEWS 
-- --


mainContentView : 
    { config
        | device : Device
        , closePath : String
    }
    -> GqlData AdaptationInfo
    -> AdaptationOutput
    -> Element MainStyles Variations Msg
mainContentView { device, closePath } adaptationInfo outputDetails =
    case adaptationInfo of
        Success info ->
            let
                currentStrategy = Info.currentStrategy (Just info)

                currentDetails = 
                    Info.currentStrategyDetails (Just info)
                        |> Maybe.andThen Remote.toMaybe
                        |> MEx.join

                name = currentStrategy |> Maybe.map .name |> Maybe.withDefault " "
            in
            column NoStyle
                [ height fill, width fill ]
                [ headerDetailsView device name
                    [ closeIconView closePath
                    , categoriesView info.categories currentStrategy
                    ]
                , currentStrategy
                    |> Maybe.map3
                        (\hazards details strategy -> 
                            mainDetailsView device info.benefits hazards strategy details outputDetails
                        )
                        info.hazards
                        currentDetails
                    |> Maybe.withDefault empty
                ]

        Failure err ->
            column NoStyle
                [ height fill, width fill ]
                [ headerDetailsView device "Error Loading Strategies!"
                    [ closeIconView closePath ]
                ]

        _ ->
            column NoStyle
                [ height fill, width fill ]
                [ headerDetailsView device " "
                    [ closeIconView closePath ]
                ]

           
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
            [ height fill, width fill, paddingLeft 40, verticalCenter ]
            [ el NoStyle [ width fill, height (percent 40) ] 
                <| el (AddStrategies StrategiesSheetHeading) [ verticalCenter ] <| 
            column NoStyle [ ]
                [ el (AddStrategies StrategiesSubHeading) [] <| 
                 el (AddStrategies StrategiesMainHeading) [] <| 
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
        |> List.map 
            (\category -> 
                ( category
                , maybeStrategy
                    |> Maybe.map (Strategies.hasCategory category.id)
                    |> Maybe.withDefault False
                )
            )
        |> List.indexedMap categoryView
        |> categoriesRowView


categoriesRowView : List (String, Element MainStyles Variations Msg) -> Element MainStyles Variations Msg
categoriesRowView views =
    el NoStyle 
        [ alignRight 
        , moveDown 10
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
    ( "category_icon_" ++ name ++ "_" ++ keySuffix matched
    , image NoStyle [ center, verticalCenter, width (px 78), height (px 78) ]
        { src = srcPath, caption = name  }
    )
    


categoryMissingIconView : Int -> String -> Bool -> ( String, Element MainStyles Variations Msg )
categoryMissingIconView index lbl matched =
    ( "category_icon_missing_" ++ keySuffix matched
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
        , onClick CancelPickStrategy
        ]
        { src = srcPath, caption = "Close Modal" }


--
-- MAIN DETAILS
--

mainDetailsView : 
    Device 
    -> Benefits 
    -> Zipper CoastalHazard 
    -> Strategy 
    -> StrategyDetails
    -> AdaptationOutput
    -> Element MainStyles Variations Msg
mainDetailsView device benefits hazards strategy details outputDetails =
    let
        theOutputDetails : OutputDetails
        theOutputDetails = defaultOutput
        scaleDisabled a = vary Disabled (not <| Impacts.hasScale a theOutputDetails.scales)
    
    in
    column (AddStrategies StrategiesDetailsMain)
        [ height (px <| mainHeight device) ]
        [ row NoStyle
            [ paddingXY 32 1, spacing 0 ]
            [ column NoStyle
                [ width fill, paddingXY 2 0 ]
                [ ModalImage.view NoStyle NoStyle details.imagePath
                ]
            , column NoStyle
                [ ]
                [  el NoStyle [] <|
            row NoStyle [ width fill, spread, paddingXY 4 10, verticalCenter ]
                [ column NoStyle [center]
                [ el (ShowOutput OutputImpact)
                    [ paddingXY 4 2, minWidth (px 115) ] <| text theOutputDetails.cost.name
                    , el NoStyle [ moveDown 3 ] (text "COST")
                        |> within [ infoIconView (Just "...") ]
                    ]
                , column NoStyle [center]
                    [ el (ShowOutput OutputImpact) 
                        [ paddingXY 4 2, minWidth (px 115), vary Secondary True ] <| text theOutputDetails.lifespan.name
                    , el NoStyle [ moveDown 3 ] (text "LIFESPAN")
                        |> within [ infoIconView (Just "...") ]
                    ]
                , column NoStyle [center]                    
                    [ column NoStyle []
                        [ row NoStyle [ minWidth (px 115) ]
                            [ el (ShowOutput OutputMultiImpact) 
                                [ paddingXY 4 0 
                                , scaleDisabled "Site"
                                ] <| text "Site"
                            , el (ShowOutput OutputMultiImpact) 
                                [ paddingXY 4 0
                                , vary Secondary True 
                                , scaleDisabled "Neighborhood"
                                ] <| text "Neighborhood"
                            ]
                        , row NoStyle [ minWidth (px 115) ]
                            [ el (ShowOutput OutputMultiImpact) 
                                [ paddingXY 4 0
                                , vary Tertiary True 
                                , scaleDisabled "Community"
                                ] <| text "Community"
                            , el (ShowOutput OutputMultiImpact) 
                                [ paddingXY 4 0
                                , vary Quaternary True
                                , scaleDisabled "Region"
                                ] <| text "Region"
                            ]
                        ]
                , column NoStyle [alignRight]
                    [ el NoStyle [ moveDown 3 ] (text "SCALE")
                        |> within [ infoIconView (Just "...") ]
                    ]
                    ]
                ]
                , hairline Hairline
                , el NoStyle [ ] <|
                    column (AddStrategies StrategiesDetailsHeading) []
                        [ h6 NoStyle [center] <| text "ECOSYSTEM SERVICES" ]
                , benefitsProvidedView benefits details
                , hairline Hairline
                ]
            ]
        , column NoStyle
            [ paddingXY 32 10 ]
            [ paragraph (AddStrategies StrategiesDetailsDescription) []
                [ el (AddStrategies StrategiesDetailsDescription) 
                    [ vary Secondary True ] <| text "Description: "
                , text <| Maybe.withDefault "n/a" details.description
                ]
            , hairline Hairline
            ]
        , column NoStyle
            [ paddingXY 32 0 ]
            [ paragraph (AddStrategies StrategiesDetailsDescription) []
                    [ el (AddStrategies StrategiesDetailsDescription) 
                        [ vary Secondary True ] <| text "Applicability: "
                    , text <| Maybe.withDefault "This will be filled in the future with adaptation strategy-specific applicability content." details.currentlyPermittable
                    ]
            , hairline Hairline
            ]
        ]

coastalHazardsView : Zipper CoastalHazard -> StrategyDetails -> Element MainStyles Variations Msg
coastalHazardsView hazards details = 
    hazards
        |> Zipper.toList
        |> List.map 
            (\hazard ->
                details
                    |> Details.hasHazard hazard.id
                    |> coastalHazardView hazard
            )
        |> coastalHazardsRowView


coastalHazardsRowView : List (String, Element MainStyles Variations Msg) -> Element MainStyles Variations Msg
coastalHazardsRowView views =
    el NoStyle
        [] <|
        Keyed.row NoStyle [ spread, width fill ] views


coastalHazardView : CoastalHazard -> Bool -> ( String, Element MainStyles Variations Msg) 
coastalHazardView hazard matched =
    ("coastal_hazard_view_" ++ (toString <| getId hazard.id)
    , Keyed.column NoStyle
        [ width (percent (1/3 * 100)), center, verticalCenter ]
        [ case (Hazards.toType hazard, matched) of
            ( Ok Hazards.Erosion, True ) ->
                ( "erosion_icon_" ++ keySuffix matched
                , erosionIconConfig
                    |> erosionIcon
                    |> html
                )

            ( Ok Hazards.Erosion, False ) ->
                ( "erosion_icon_" ++ keySuffix matched
                , { erosionIconConfig | color = Color.rgb 79 88 98 }
                    |> erosionIcon 
                    |> html
            
                )

            ( Ok Hazards.SeaLevelRise, True ) ->
                ( "sea_level_rise_icon_" ++ keySuffix matched
                , seaLevelRiseIconConfig
                    |> seaLevelRiseIcon
                    |> html
                )

            ( Ok Hazards.SeaLevelRise, False ) ->
                ( "sea_level_rise_icon_" ++ keySuffix matched
                , { seaLevelRiseIconConfig | color = Color.rgb 79 88 98 }
                    |> seaLevelRiseIcon 
                    |> html
                )

            ( Ok Hazards.StormSurge, True ) ->
                ( "storm_surge_icon" ++ keySuffix matched
                , stormSurgeIconConfig
                    |> stormSurgeIcon
                    |> html
                )

            ( Ok Hazards.StormSurge, False ) ->
                ( "storm_surge_icon" ++ keySuffix matched
                , { stormSurgeIconConfig | color = Color.rgb 79 88 98 }
                    |> stormSurgeIcon 
                    |> html
                )

            ( Err _, _ ) ->
                coastalHazardUnknownIconView
                
        , coastalHazardLabelView hazard.name matched
        ]
    )

infoIconView : Maybe String -> Element MainStyles Variations Msg
infoIconView maybeHelpText =
    case maybeHelpText of
        Just helpText ->
            circle 6 (ShowOutput OutputInfoIcon) 
                [ title helpText, alignRight, moveRight 18 ] <| 
                    el NoStyle [verticalCenter, center] (text "i")
  
        Nothing ->
            empty   


coastalHazardLabelView : String -> Bool -> ( String, Element MainStyles Variations Msg )
coastalHazardLabelView lbl matched =
    ( "category_label_" ++ lbl
    , el (AddStrategies StrategiesDetailsHazards)
        [ center
        , verticalCenter
        , paddingTop 8
        , vary Disabled (not matched)
        ] <|
            text lbl
    )


coastalHazardUnknownIconView : ( String, Element MainStyles Variations Msg )
coastalHazardUnknownIconView =
    ( "unknown_hazard_icon"
    , circle 22 (AddStrategies StrategiesDetailsHazardsCircle)
        [ center
        , verticalCenter
        , vary Disabled True 
        ] <| 
            el (AddStrategies StrategiesDetailsHazards)
                [ center
                , verticalCenter
                , vary Disabled True
                ] <| 
                    text "Unknown Hazard"
    )


benefitsProvidedView : Benefits -> StrategyDetails -> Element MainStyles Variations Msg
benefitsProvidedView benefits details =
    benefits
        |> List.map 
            (\benefit ->
                details
                    |> Details.hasBenefit benefit
                    |> benefitProvidedView benefit
            )
        |> benefitsProvidedRowView


benefitsProvidedRowView : List (Element MainStyles Variations Msg) -> Element MainStyles Variations Msg
benefitsProvidedRowView views =
    el NoStyle
        [] <|
        row NoStyle [ spread, width fill ] views


benefitProvidedView : Benefit -> Bool -> Element MainStyles Variations Msg
benefitProvidedView benefit matched =
    paragraph (AddStrategies StrategiesDetailsBenefits)
        [ center
        , verticalCenter
        , vary Disabled (not matched)
        , width (px 58)
        ] [ text benefit ]


basicListView : String -> List String -> Element MainStyles Variations Msg
basicListView titleTxt listItems =
    let
        items =
            List.map
                (\item ->
                    row NoStyle [ spacingXY 8 0 ]
                        [ circle 3 CircleBullet [ center, moveDown 9 ] empty
                        , paragraph (AddStrategies StrategiesDetailsTextList) []
                            [ text item ]
                        ]
                )
                listItems
    in
    column NoStyle [ spacingXY 0 18 ]
        ( (h6 (AddStrategies StrategiesDetailsTextList) [ vary Secondary True ] <| text titleTxt)
            :: items
        )

keySuffix : Bool -> String
keySuffix matched =
    if matched then 
        "active" 
    else 
        "inactive"


