module View.BaselineInfo exposing (..)

import Dict exposing (Dict)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import RemoteData exposing (RemoteData(..))
import Message exposing (..)
import Types exposing (..)
import Styles exposing (..)
import View.Helpers exposing (..)


type alias BaselineInformation =
    Dict String BaselineInfo


view : { config | closePath : String, baselineModal : GqlData (Maybe BaselineInfo) } -> Element MainStyles Variations Msg
view config =
    case config.baselineModal of
        NotAsked ->
            button (Baseline BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , onClick GetBaselineInfo
                , title "Show baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"

        Loading ->
            button (Baseline BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , title "Loading baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"

        Success (Just info) ->
            column NoStyle
                []
                [ button (Baseline BaselineInfoBtn)
                    [ height (px 42)
                    , width (px 42)
                    , title "Baseline information for the selected Shoreline Location"
                    ]
                  <|
                    Element.text "i"
                , modal (Baseline BaselineInfoModalBg)
                    [ height fill
                    , width fill
                    , padding 90
                    ]
                  <|
                    el (Baseline BaselineInfoModal)
                        [ width (px 900)
                        , maxHeight (px 900)
                        , center
                        , verticalCenter
                        ]
                    <|
                        column NoStyle
                            []
                            [ headerView config.closePath info
                            , mainContentView info
                            ]
                ]

        Success Nothing ->
            button (Baseline BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , title "Baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"

        Failure err ->
            button (Baseline BaselineInfoBtn)
                [ height (px 42)
                , width (px 42)
                , title "Baseline information for the selected Shoreline Location"
                ]
            <|
                Element.text "i"


headerView : String -> BaselineInfo -> Element MainStyles Variations Msg
headerView closePath info =
    header (Baseline BaselineInfoHeader)
        [ width fill, height (px 225) ]
    <|
        (column (Baseline BaselineInfoHeader)
            [ alignBottom
            , height fill
            , width fill
            , paddingXY 40 10
            , spacingXY 0 5
            ]
            [ h6 (Headings H6) [ width fill ] <| Element.text "BASELINE LOCATION INFORMATION"
            , h3 (Headings H3) [ width fill, height (px 65) ] <| Element.text info.name
            ]
            |> within
                [ image CloseIcon
                    [ alignRight
                    , moveDown 15
                    , moveLeft 15
                    , title "Close baseline information"
                    , onClick CloseBaselineInfo
                    ]
                    { src = closePath, caption = "Close Modal" }
                ]
        )


mainContentView : BaselineInfo -> Element MainStyles Variations Msg
mainContentView info =
    column NoStyle
        [ maxHeight (px 615), scrollbars ]
        [ row NoStyle
            [ padding 32, spacing 32 ]
            [ column (Baseline BaselineInfoText)
                [ width (percent 50), spacingXY 0 25 ]
                [ (case info.imagePath of
                    Just path ->
                        column NoStyle
                            []
                            [ decorativeImage NoStyle
                                [ width fill ]
                                { src = path }
                            ]

                    Nothing ->
                        Element.empty
                  )
                ]
            , column (Baseline BaselineInfoText)
                [ width (percent 50), spacingXY 0 25 ]
                [ column NoStyle
                    [ spacingXY 0 8 ]
                    [ h5 (Headings H6) [ vary Secondary True ] <| Element.text "GENERAL INFO"
                    , infoRowView
                        "Length of shoreline:"
                        (formatDecimal 2 info.lengthMiles ++ " miles")
                    , infoRowView
                        "Impervious surface area:"
                        (formatDecimal 2 info.impervPercent ++ " %")
                    ]
                , column NoStyle
                    [ spacingXY 0 8 ]
                    [ h5 (Headings H6) [ vary Secondary True ] <| Element.text "PUBLIC INFRASTRUCTURE"
                    , infoRowView
                        "Critical facilities:"
                        (toString info.criticalFacilitiesCount)
                    , infoRowView
                        "Coastal structures:"
                        (toString info.coastalStructuresCount)
                    , infoRowView
                        "Public buildings:"
                        (toString info.publicBuildingsCount)
                    , infoRowView
                        "Working harbor:"
                        (formatBoolean info.workingHarbor)
                    ]
                , column NoStyle
                    [ spacingXY 0 8 ]
                    [ h5 (Headings H6) [ vary Secondary True ] <| Element.text "HABITAT"
                    , infoRowView
                        "Acres of salt marsh:"
                        (formatDecimal 2 info.saltMarshAcres)
                    , infoRowView
                        "Acres of eelgrass:"
                        (formatDecimal 2 info.eelgrassAcres)
                    ]
                , column NoStyle
                    [ spacingXY 0 8 ]
                    [ h5 (Headings H6) [ vary Secondary True ] <| Element.text "RECREATION"
                    , infoRowView
                        "Public beaches:"
                        (toString info.publicBeachCount)
                    , infoRowView
                        "Acres of recreational open space:"
                        (formatDecimal 2 info.recreationOpenSpaceAcres)
                    , infoRowView
                        "Town ways to water:"
                        (toString info.townWaysToWater)
                    ]
                , column NoStyle
                    [ spacingXY 0 8 ]
                    [ h5 (Headings H6) [ vary Secondary True ] <| Element.text "PRIVATE INFRASTRUCTURE"
                    , infoRowView
                        "Total assessed value:"
                        ("$" ++ formatDecimal 2 info.totalAssessedValue)
                    ]
                ]
            ]
        ]


infoRowView : String -> String -> Element MainStyles Variations Msg
infoRowView label value =
    row NoStyle
        [ width fill ]
        [ el FontLeft [ width fill ] <| Element.text label
        , el FontRight [ width fill ] <| Element.text value
        ]
