module Types exposing (..)

import Http exposing (..)
import Graphqelm.Http
import RemoteData exposing (RemoteData)
import ChipApi.Scalar as Scalar
import Window
import Json.Encode as E
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)


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
    }


decodeEnv : Decoder Env
decodeEnv =
    decode Env
        |> required "agsLittoralCellUrl" D.string


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
    , publicBeachCount : Int
    , recreationOpenSpaceAcres : Scalar.Decimal
    , townWaysToWater : Int
    , totalAssessedValue : Scalar.Decimal
    }


type alias Extent =
    { minX : Float
    , minY : Float
    , maxX : Float
    , maxY : Float
    }


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
