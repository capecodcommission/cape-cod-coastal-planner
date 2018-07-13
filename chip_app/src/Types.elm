module Types exposing (..)

import Graphqelm.Http
import RemoteData exposing (RemoteData)


type alias GqlData a =
    RemoteData (Graphqelm.Http.Error a) a


type alias CoastalHazard =
    { name : String
    }


type alias CoastalHazardsResponse =
    { hazards : List (Maybe CoastalHazard)
    }
