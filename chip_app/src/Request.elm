module Request exposing (..)

import Graphqelm.Http exposing (..)
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData, fromResult)
import ChipApi.Object
import ChipApi.Object.CoastalHazard as CH
import ChipApi.Object.ShorelineLocation as SL
import ChipApi.Query as Query
import Types exposing (..)
import Message exposing (..)


--
-- COASTAL HAZARDS
--


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
        |> queryRequest "./api"
        |> send (fromResult >> HandleCoastalHazardsResponse)



--
-- SHORELINE LOCATIONS
--


queryShorelineLocations : SelectionSet ShorelineLocationsResponse RootQuery
queryShorelineLocations =
    Query.selection ShorelineLocationsResponse
        |> with (Query.shorelineLocations identity shorelineLocations)


shorelineLocations : SelectionSet Types.ShorelineLocation ChipApi.Object.ShorelineLocation
shorelineLocations =
    SL.selection Types.ShorelineLocation
        |> with SL.name
        |> with SL.minX
        |> with SL.minY
        |> with SL.maxX
        |> with SL.maxY


getShorelineLocations : Cmd Msg
getShorelineLocations =
    queryShorelineLocations
        |> queryRequest "./api"
        |> send (fromResult >> HandleShorelineLocationsResponse)
