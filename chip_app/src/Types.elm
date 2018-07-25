module Types exposing (..)

import Graphqelm.Http
import RemoteData exposing (RemoteData)
import ChipApi.Scalar exposing (..)


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
    , extent : GeographicExtent
    }


type alias ShorelineLocationsResponse =
    { locations : List ShorelineLocation
    }
