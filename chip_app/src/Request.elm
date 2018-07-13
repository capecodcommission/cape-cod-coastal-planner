module Request exposing (..)

import Graphqelm.Http exposing (..)
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData, fromResult)
import ChipApi.Object
import ChipApi.Object.CoastalHazard as CH
import ChipApi.Query as Query
import Types exposing (..)
import Message exposing (..)


queryCoastalHazards : SelectionSet CoastalHazardsResponse RootQuery
queryCoastalHazards =
    Query.selection CoastalHazardsResponse
        |> with (Query.coastalHazards identity coastalHazards)


coastalHazards : SelectionSet Types.CoastalHazard ChipApi.Object.CoastalHazard
coastalHazards =
    CH.selection Types.CoastalHazard
        |> with CH.name


getCoastalHazards : Cmd Msg
getCoastalHazards =
    queryCoastalHazards
        |> queryRequest "http://localhost:4000/api"
        |> send (fromResult >> HandleCoastalHazardsResponse)
