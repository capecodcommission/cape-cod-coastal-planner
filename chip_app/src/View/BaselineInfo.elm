module View.BaselineInfo exposing (..)

import Dict exposing (Dict)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import RemoteData exposing (RemoteData(..))
import Message exposing (..)
import Types exposing (..)
import ShorelineLocation as SL
import Styles exposing (..)
import View.ModalImage as ModalImage
import View.Helpers exposing (..)


type alias BaselineInformation =
    Dict String SL.BaselineInfo


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
        , baselineModal : GqlData (Maybe SL.BaselineInfo) 
    } 
    -> Element MainStyles Variations Msg
view config =
    case config.baselineModal of
        NotAsked ->
            "Show baseline information for the selected Shoreline Location"
                |> infoButtonView [ onClick GetBaselineInfo ]

        Loading ->
            "Loading baseline information for the selected Shoreline Location"
                |> infoButtonView []

        Success (Just info) ->
            column NoStyle
                []
                [ infoButtonView [] defaultButtonText
                , modal (Modal ModalBackground)
                    [ height fill
                    , width fill
                    , padding 90
                    ]
                  <|
                    el (Modal ModalContainer)
                        [ width (px 900)
                        , maxHeight (px <| modalHeight config.device)
                        , center
                        , verticalCenter
                        ]
                    <|
                        column NoStyle
                            []
                            [ headerView config info
                            , mainContentView config info
                            ]
                ]

        Success Nothing ->
            infoButtonView [] defaultButtonText

        Failure err ->
            infoButtonView [] defaultButtonText


headerView : 
    { config 
        | closePath : String
        , device : Device 
    } 
    -> SL.BaselineInfo 
    -> Element MainStyles Variations Msg
headerView { closePath, device } info =
    header (Baseline BaselineInfoHeader)
        [ width fill ]
        (row (Baseline BaselineInfoHeader)
            [ verticalCenter
            , height fill
            , width fill
            , paddingXY 0 5
            , spacingXY 0 5
            ]
            [ column (Baseline BaselineInfoText)
                [ paddingXY 40 5]
                [ h6 (Headings H6) [ width fill ] <| Element.text "BASELINE LOCATION INFORMATION"
                , h3 (Headings H3) [ width fill, moveLeft 2 ] <| Element.text info.name
                ]
            , column (Baseline BaselineInfoText)
                [ alignRight, paddingRight 40, paddingLeft 75 ]
                [ ModalImage.view NoStyle (Baseline BaselineInfoImage) info.imagePath
                ]
                |> within
                    [ image CloseIcon
                        [ alignRight
                        , moveDown 3
                        , moveLeft 6
                        , title "Close baseline information"
                        , onClick CloseBaselineInfo
                        ]
                        { src = closePath, caption = "Close Modal" }
                    ]
            ]
        )


mainContentView : { config | device : Device } -> SL.BaselineInfo -> Element MainStyles Variations Msg
mainContentView { device } info =
    column NoStyle
        [ scrollbars ]
        [ row NoStyle
            [ ]
            [ column (Baseline BaselineInfoText)
                [ spacingXY 0 5, width fill, paddingXY 50 20 ]
                [ h5 (Headings H6) [ vary Secondary True ] <| Element.text "GENERAL INFO"
                , infoRowView
                    "Length of shoreline:"
                    (formatDecimal 2 info.lengthMiles ++ " miles")
                , infoRowView
                    "Impervious surface area:"
                    (formatDecimal 2 info.impervPercent ++ " %")
                ]
            , column (Baseline BaselineInfoText) 
                [ spacingXY 0 5, width fill, paddingXY 50 20 ]
                [ h5 (Headings H6) [ vary Secondary True ] <| Element.text "PUBLIC INFRASTRUCTURE"
                , infoRowView
                    "Critical facilities:"
                    --(toString info.criticalFacilitiesCount)
                    (String.fromInt info.criticalFacilitiesCount)
                -- , infoRowView
                --     "Historical places:"
                --     (String.fromInt info.historicalPlacesCount)
                , infoRowView
                    "Coastal structures:"
                    (String.fromInt info.coastalStructuresCount)
                , infoRowView
                    "Public buildings:"
                    (String.fromInt info.publicBuildingsCount)
                , infoRowView
                    "Working harbor:"
                    (formatBoolean info.workingHarbor)
                ]
                    
            ]
        , row NoStyle
            [ ]
            [ column (Baseline BaselineInfoText)
                [ spacingXY 0 5, width fill, paddingXY 50 20 ]
                [ h5 (Headings H6) [ vary Secondary True ] <| Element.text "HABITAT"
                , infoRowView
                    "Acres of salt marsh:"
                    (formatDecimal 2 info.saltMarshAcres)
                , infoRowView
                    "Acres of eelgrass:"
                    (formatDecimal 2 info.eelgrassAcres)
                , infoRowView
                    "Acres of coastal dune:"
                    (formatDecimal 2 info.coastalDuneAcres)
                , infoRowView
                    "Acres of rare species habitat:"
                    (formatDecimal 2 info.rareSpeciesAcres)  
                ]
            , column (Baseline BaselineInfoText) 
                [ spacingXY 0 5, width fill, paddingXY 50 20 ]
                [ h5 (Headings H6) [ vary Secondary True ] <| Element.text "RECREATION"
                , infoRowView
                    "Public beaches:"
                    --(toString info.publicBeachCount)
                    (String.fromInt info.publicBeachCount)                    
                , infoRowView
                    "Acres of recreational open space:"
                    (formatDecimal 2 info.recreationOpenSpaceAcres)
                , infoRowView
                    "Town ways to water:"
                    --(toString info.townWaysToWater)
                    (String.fromInt info.townWaysToWater)
                , infoRowView
                    "National seashore:"
                    (formatBoolean info.nationalSeashore)
                ]
            ]
        , row NoStyle
            [ paddingBottom 5 ]
            [ column (Baseline BaselineInfoText) 
                [ spacingXY 0 5, width fill, paddingXY 50 20 ]
                [ h5 (Headings H6) [ vary Secondary True ] <| Element.text "PRIVATE INFRASTRUCTURE"
                , infoRowView
                    "Total assessed value:"
                    ("$" ++ formatDecimal 0 info.totalAssessedValue)
                ]
            , column (Baseline BaselineInfoText) 
                [ spacingXY 0 5, width fill, paddingXY 50 20 ]
                []
            ]
        ]         


infoRowView : String -> String -> Element MainStyles Variations Msg
infoRowView label value =
    row NoStyle
        [ width fill ]
        [ el FontLeft [ width fill ] <| Element.text label
        , el FontRight [ width fill ] <| Element.text value
        ]


defaultButtonText : String
defaultButtonText =
    "Baseline information for the selected Shoreline Location"


infoButtonView : List (Attribute Variations Msg) -> String -> Element MainStyles Variations Msg
infoButtonView attrs txt =
    button (Baseline BaselineInfoBtn)
        (height (px 42) :: width (px 42) :: title txt :: attrs)
        (Element.text "i")
