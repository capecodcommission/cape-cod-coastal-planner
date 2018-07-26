module Types exposing (..)

import Graphqelm.Http
import RemoteData exposing (RemoteData)
import ChipApi.Scalar exposing (..)
import Json.Encode as E


type alias GqlData a =
    RemoteData (Graphqelm.Http.Error a) a


type alias CoastalHazard =
    { name : String
    }


type alias CoastalHazardsResponse =
    { hazards : List CoastalHazard
    }


type alias ShorelineLocation =
    { name : String
    , minX : Float
    , minY : Float
    , maxX : Float
    , maxY : Float
    }


encodeShorelineLocation : ShorelineLocation -> E.Value
encodeShorelineLocation location =
    let
        extent =
            [ location.minX, location.minY, location.maxX, location.maxY ]
                |> List.map E.float
    in
        E.object
            [ ( "name", E.string location.name )
            , ( "extent", E.list extent )
            ]


type alias ShorelineLocationsResponse =
    { locations : List ShorelineLocation
    }
