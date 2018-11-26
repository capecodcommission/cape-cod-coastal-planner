module Types exposing (..)

import Animation
import Animations exposing (..)
import Http exposing (..)
import Graphqelm.Http as GHttp
import RemoteData exposing (RemoteData)
import ChipApi.Scalar as Scalar
import Window
import Dict exposing (Dict)
import List.Zipper as Zipper exposing (Zipper)
import Json.Encode as E
import Json.Encode.Extra as EEx
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, custom, hardcoded)


type alias Flags =
    { env : Env
    , closePath : String
    , trianglePath : String
    , zoiPath : String
    , size : Window.Size
    , slrPath : String
    , wetPath : String
    , shorePath : String
    }


decodeWindowSize : Decoder Window.Size
decodeWindowSize =
    D.map2 Window.Size
        (D.field "width" D.int)
        (D.field "height" D.int)


decodeFlags : Decoder Flags
decodeFlags =
    D.map8 Flags
        (D.field "env" decodeEnv)
        (D.field "closePath" D.string)
        (D.field "trianglePath" D.string)
        (D.field "zoiPath" D.string)
        (D.field "size" decodeWindowSize)
        (D.field "slrPath" D.string)
        (D.field "wetPath" D.string)
        (D.field "shorePath" D.string)


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


type Openness
    = Open
    | Closed


type alias GqlData a =
    RemoteData (GHttp.Error a) a


type alias GqlList a =
    { items : List a }


unwrapGqlList : GqlList a -> List a
unwrapGqlList gqlList =
    gqlList.items


mapGqlError : (a -> b) -> GHttp.Error a -> GHttp.Error b
mapGqlError fn error =
    GHttp.mapError fn error


zipperFromGqlList : (a -> b) -> GqlList a -> Maybe (Zipper b)
zipperFromGqlList fn gqlList =
    gqlList.items
        |> List.map fn
        |> Zipper.fromList


dictFromGqlList : (a -> ( comparable, b )) -> GqlList a -> Dict comparable b
dictFromGqlList fn gqlList =
    gqlList.items
        |> List.map fn
        |> Dict.fromList


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


type alias PlacementMajorities =
    { majoritySaltMarsh : Bool
    , majorityCoastalBank : Bool
    , majorityUndeveloped : Bool
    }


placementMajoritiesDecoder : Decoder PlacementMajorities
placementMajoritiesDecoder =
    D.map3 PlacementMajorities
        (D.field "majoritySaltMarsh" D.bool)
        (D.field "majorityCoastalBank" D.bool)
        (D.field "majorityUndeveloped" D.bool)


type alias BeachLengths =
    { total : Int
    , nationalSeashore : Int
    , townBeach : Int
    , otherPublic : Int
    }


beachLengthsDecoder : Decoder BeachLengths
beachLengthsDecoder =
    D.map4 BeachLengths
        (D.field "total" D.int)
        (D.field "nationalSeashore" D.int)
        (D.field "townBeach" D.int)
        (D.field "otherPublic" D.int)


type alias ZoneOfImpact =
    { geometry : Maybe String
    , numSelected : Int
    , beachLengths : BeachLengths
    , placementMajorities : PlacementMajorities
    }


zoiTotalMeters : ZoneOfImpact -> Float
zoiTotalMeters zoi =
    zoi.beachLengths.total
        |> toFloat
        |> (*) metersPerFoot


zoiAcreageImpact : Float -> ZoneOfImpact -> Float
zoiAcreageImpact width zoi =
    zoiTotalMeters zoi * width * acresPerSqMeter


zoneOfImpactDecoder : Decoder ZoneOfImpact
zoneOfImpactDecoder =
    D.map4 ZoneOfImpact
        (D.maybe (D.field "geometry" D.string))
        (D.field "num_selected" D.int)
        (D.field "beach_lengths" beachLengthsDecoder)
        (D.field "placements" placementMajoritiesDecoder)


getId : Scalar.Id -> String
getId (Scalar.Id id) =
    id


metersPerFoot : Float
metersPerFoot = 0.3048


acresPerSqMeter : Float
acresPerSqMeter = 0.000247105