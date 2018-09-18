module Types exposing (..)

import Http exposing (..)
import Graphqelm.Http
import RemoteData exposing (RemoteData)
import ChipApi.Scalar as Scalar
import Window
import Dict exposing (Dict)
import Json.Encode as E
import Json.Encode.Extra as EEx
import Json.Decode as D exposing (Decoder)
import Json.Decode.Extra as DEx
import Json.Decode.Pipeline exposing (decode, required, custom, hardcoded)


type alias Flags =
    { env : Env
    , closePath : String
    , size : Window.Size
    }


decodeWindowSize : Decoder Window.Size
decodeWindowSize =
    D.map2 Window.Size
        (D.field "width" D.int)
        (D.field "height" D.int)


decodeFlags : Decoder Flags
decodeFlags =
    D.map3 Flags
        (D.field "env" decodeEnv)
        (D.field "closePath" D.string)
        (D.field "size" decodeWindowSize)


type alias Env =
    { agsLittoralCellUrl : String
    , agsVulnerabilityRibbonUrl : String
    , agsHexUrl : String
    }


decodeEnv : Decoder Env
decodeEnv =
    decode Env
        |> required "agsLittoralCellUrl" D.string
        |> required "agsVulnerabilityRibbonUrl" D.string
        |> required "agsHexUrl" D.string


type alias GqlData a =
    RemoteData (Graphqelm.Http.Error a) a


type alias CoastalHazard =
    { name : String
    }


type alias CoastalHazards =
    { items : List CoastalHazard
    }


type alias ShorelineExtent =
    { id : Scalar.Id
    , name : String
    , minX : Float
    , minY : Float
    , maxX : Float
    , maxY : Float
    }


shorelineExtentToExtent : ShorelineExtent -> Extent
shorelineExtentToExtent { minX, minY, maxX, maxY } =
    Extent minX minY maxX maxY


encodeShorelineExtent : ShorelineExtent -> E.Value
encodeShorelineExtent location =
    let
        extent =
            [ location.minX, location.minY, location.maxX, location.maxY ]
                |> List.map E.float
    in
        E.object
            [ ( "name", E.string location.name )
            , ( "extent", E.list extent )
            ]


type alias ShorelineExtents =
    { items : List ShorelineExtent
    }


type alias BaselineInfo =
    { id : Scalar.Id
    , name : String
    , imagePath : Maybe String
    , lengthMiles : Scalar.Decimal
    , impervPercent : Scalar.Decimal
    , criticalFacilitiesCount : Int
    , coastalStructuresCount : Int
    , workingHarbor : Bool
    , publicBuildingsCount : Int
    , saltMarshAcres : Scalar.Decimal
    , eelgrassAcres : Scalar.Decimal
    , coastalDuneAcres : Scalar.Decimal
    , rareSpeciesAcres : Scalar.Decimal
    , publicBeachCount : Int
    , recreationOpenSpaceAcres : Scalar.Decimal
    , townWaysToWater : Int
    , nationalSeashore : Bool
    , totalAssessedValue : Scalar.Decimal
    }


type alias Extent =
    { minX : Float
    , minY : Float
    , maxX : Float
    , maxY : Float
    }


extentToString : Extent -> String
extentToString extent =
    [ extent.minX, extent.minY, extent.maxX, extent.maxY ]
        |> List.map toString
        |> String.join ","


encodeRawResponse : Result Http.Error D.Value -> E.Value
encodeRawResponse response =
    case response of
        Ok value ->
            E.object [ ( "response", value ) ]

        Err (BadUrl err) ->
            E.object [ ( "error", E.string <| "bad url: " ++ err ) ]

        Err Timeout ->
            E.object [ ( "error", E.string "http timeout" ) ]

        Err NetworkError ->
            E.object [ ( "error", E.string "network error" ) ]

        Err (BadStatus { status }) ->
            E.object [ ( "error", E.string <| "bad status: " ++ toString status ) ]

        Err (BadPayload err { status }) ->
            E.object [ ( "error", E.string <| "bad payload: " ++ err ) ]


type alias VulnerabilityRibbon =
    Dict Int RibbonSegment


type alias RibbonSegment =
    { id : Int
    , score : Int
    , saltMarsh : Bool
    , coastalDune : Bool
    , undeveloped : Bool
    , geometry : D.Value
    }


encodeVulnerabilityRibbon : VulnerabilityRibbon -> E.Value
encodeVulnerabilityRibbon ribbon =
    let
        ribbonList : List RibbonSegment
        ribbonList =
            ribbon |> Dict.toList |> List.map Tuple.second
    in
        E.object
            [ ( "features", E.list <| List.map encodeRibbonSegment ribbonList ) ]


encodeRibbonSegment : RibbonSegment -> E.Value
encodeRibbonSegment segment =
    E.object
        [ ( "id", E.int segment.id )
        , ( "score", E.int segment.score )
        , ( "saltMarsh", E.bool segment.saltMarsh )
        , ( "coastalDune", E.bool segment.coastalDune )
        , ( "undeveloped", E.bool segment.undeveloped )
        , ( "geometry", segment.geometry )
        ]


vulnerabilityRibbonDecoder : Decoder VulnerabilityRibbon
vulnerabilityRibbonDecoder =
    D.at [ "features" ] (D.list <| ribbonSegmentDecoder)
        |> D.andThen (Dict.fromList >> D.succeed)


ribbonSegmentDecoder : Decoder ( Int, RibbonSegment )
ribbonSegmentDecoder =
    (D.map6 RibbonSegment
        (D.at [ "attributes", "OBJECTID" ] D.int)
        (D.at [ "attributes", "RibbonScore" ] D.int)
        (D.at [ "attributes", "SaltMarsh" ] yesNoDecoder)
        (D.at [ "attributes", "CoastalDune" ] yesNoDecoder)
        (D.at [ "attributes", "Undeveloped" ] yesNoDecoder)
        (D.at [ "geometry" ] D.value)
    )
        |> D.andThen (\segment -> D.succeed ( segment.id, segment ))


yesNoDecoder : Decoder Bool
yesNoDecoder =
    D.string
        |> D.andThen (yesNoToBool >> Maybe.withDefault False >> D.succeed)


yesNoToBool : String -> Maybe Bool
yesNoToBool yesNo =
    case String.toLower yesNo of
        "y" ->
            Just True

        "yes" ->
            Just True

        "n" ->
            Just False

        "no" ->
            Just False

        _ ->
            Nothing


type alias PopupPosition =
    { x : Float
    , y : Float
    }


popupPositionDecoder : Decoder PopupPosition
popupPositionDecoder =
    D.map2 PopupPosition
        (D.field "x" D.float)
        (D.field "y" D.float)


encodePopupPosition : PopupPosition -> E.Value
encodePopupPosition pos =
    E.list <| [ E.float pos.x, E.float pos.y ]


type PopupState
    = PopupDisabled
    | PopupEnabled PopupPosition
    | PopupHidden PopupPosition


encodePopupState : PopupState -> E.Value
encodePopupState state =
    case state of
        PopupDisabled ->
            E.object [ ( "state", E.string "popup_disabled" ) ]

        PopupEnabled position ->
            E.object
                [ ( "state", E.string "popup_enabled" )
                , ( "position", encodePopupPosition position )
                ]

        PopupHidden position ->
            E.object
                [ ( "state", E.string "popup_hidden" )
                , ( "position", encodePopupPosition position )
                ]


popupStateDecoder : Decoder PopupState
popupStateDecoder =
    (D.map2 (\a b -> ( a, b ))
        (D.field "state" D.string)
        (D.maybe (D.field "position" popupPositionDecoder))
    )
        |> D.andThen
            (\( state, maybePosition ) ->
                case ( state, maybePosition ) of
                    ( "popup_disabled", _ ) ->
                        D.succeed PopupDisabled

                    ( "popup_enabled", Just position ) ->
                        D.succeed <| PopupEnabled position

                    ( "popup_hidden", Just position ) ->
                        D.succeed <| PopupHidden position

                    ( "popup_enabled", Nothing ) ->
                        D.fail <| "Invalid popup position, expecting { x : Float, y : Float }"

                    ( "popup_hidden", Nothing ) ->
                        D.fail <| "Invalid popup position, expecting { x : Float, y : Float }"

                    _ ->
                        D.fail <| "Invalid PopupState '" ++ state ++ "', expecting one of ['popup_hidden', 'popup_enabled', 'popup_disabled']"
            )


type alias ZoneOfImpact =
    { state : PopupState
    , geometry : Maybe String
    , numSelected : Int
    }


encodeZoneOfImpact : ZoneOfImpact -> E.Value
encodeZoneOfImpact zoi =
    E.object
        [ ( "state", encodePopupState zoi.state )
        , ( "geometry", EEx.maybe E.string zoi.geometry )
        , ( "numSelected", E.int zoi.numSelected )
        ]


zoneOfImpactDecoder : Decoder ZoneOfImpact
zoneOfImpactDecoder =
    popupStateDecoder
        |> D.andThen
            (\popupState ->
                D.map3 ZoneOfImpact
                    (D.succeed popupState)
                    (D.maybe (D.field "geometry" D.string))
                    (D.field "num_selected" D.int)
            )
