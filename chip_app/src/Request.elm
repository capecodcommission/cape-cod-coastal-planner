module Request exposing (..)

import Maybe
import Http
import Graphqelm.Http exposing (..)
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData, fromResult, sendRequest)
import QueryString as QS
import Json.Decode as D
import ChipApi.Object
import ChipApi.Object.CoastalHazard as CH
import ChipApi.Object.ShorelineLocation as SL
import ChipApi.Query as Query
import ChipApi.Scalar as Scalar
import Types exposing (..)
import Message exposing (..)


--
-- COASTAL HAZARDS
--


queryCoastalHazards : SelectionSet CoastalHazards RootQuery
queryCoastalHazards =
    Query.selection CoastalHazards
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
-- SHORELINE EXTENTS
--


queryShorelineExtents : SelectionSet ShorelineExtents RootQuery
queryShorelineExtents =
    Query.selection ShorelineExtents
        |> with (Query.shorelineLocations identity shorelineLocations)


shorelineLocations : SelectionSet ShorelineExtent ChipApi.Object.ShorelineLocation
shorelineLocations =
    SL.selection ShorelineExtent
        |> with SL.id
        |> with SL.name
        |> with SL.minX
        |> with SL.minY
        |> with SL.maxX
        |> with SL.maxY


getShorelineExtents : Cmd Msg
getShorelineExtents =
    queryShorelineExtents
        |> queryRequest "./api"
        |> send (fromResult >> HandleShorelineExtentsResponse)



--
-- SHORELINE BASELINE INFO
--


queryBaselineInfo : Scalar.Id -> SelectionSet (Maybe BaselineInfo) RootQuery
queryBaselineInfo id =
    Query.selection identity
        |> with (Query.shorelineLocation { id = id } baselineInfo)


baselineInfo : SelectionSet BaselineInfo ChipApi.Object.ShorelineLocation
baselineInfo =
    SL.selection BaselineInfo
        |> with SL.id
        |> with SL.name
        |> with SL.imagePath
        |> with SL.lengthMiles
        |> with SL.impervPercent
        |> with SL.criticalFacilitiesCount
        |> with SL.coastalStructuresCount
        |> with SL.workingHarbor
        |> with SL.publicBuildingsCount
        |> with SL.saltMarshAcres
        |> with SL.eelgrassAcres
        |> with SL.coastalDuneAcres
        |> with SL.rareSpeciesAcres
        |> with SL.publicBeachCount
        |> with SL.recreationOpenSpaceAcres
        |> with SL.townWaysToWater
        |> with SL.nationalSeashore
        |> with SL.totalAssessedValue


getBaselineInfo : Scalar.Id -> Cmd Msg
getBaselineInfo id =
    queryBaselineInfo id
        |> queryRequest "./api"
        |> send (fromResult >> HandleBaselineInfoResponse)



--
-- LITTORAL CELLS (FEATURE SERVICE)
--


sendGetLittoralCellsRequest : Env -> Extent -> Cmd Msg
sendGetLittoralCellsRequest env extent =
    Http.send LoadLittoralCellsResponse <|
        getLittoralCells env extent


getLittoralCells : Env -> Extent -> Http.Request D.Value
getLittoralCells env extent =
    let
        qs =
            QS.empty
                |> QS.add "f" "pjson"
                |> QS.add "returnGeometry" "true"
                |> QS.add "spatialRel" "esriSpatialRelIntersects"
                |> QS.add "geometryType" "esriGeometryEnvelope"
                |> QS.add "outFields" "Id,Littoral_Cell_Name"
                |> QS.add "inSR" "3857"
                |> QS.add "outSR" "3857"
                |> QS.add "geometry" (extentToString extent)

        getUrl =
            env.agsLittoralCellUrl ++ QS.render qs
    in
        Http.get getUrl D.value



--
-- VULNERABILITY RIBBON (FEATURE SERVICE)
--


sendGetVulnRibbonRequest : Env -> ShorelineExtent -> Cmd Msg
sendGetVulnRibbonRequest env shorelineExtent =
    shorelineExtent
        |> shorelineExtentToExtent
        |> getVulnRibbonForLocation env
        |> Http.send LoadVulnerabilityRibbonResponse



-- |> sendRequest
-- |> Cmd.map LoadVulnerabilityRibbonResponse


getVulnRibbonForLocation : Env -> Extent -> Http.Request D.Value
getVulnRibbonForLocation env extent =
    let
        qs =
            QS.empty
                |> QS.add "f" "pjson"
                |> QS.add "returnGeometry" "true"
                |> QS.add "spatialRel" "esriSpatialRelIntersects"
                |> QS.add "geometryType" "esriGeometryEnvelope"
                |> QS.add "outFields" "OBJECTID,SaltMarsh,CoastalDune,Undeveloped,RibbonScore"
                |> QS.add "inSR" "4326"
                |> QS.add "outSR" "3857"
                |> QS.add "geometry" (extentToString extent)

        getUrl =
            env.agsVulnerabilityRibbonUrl ++ QS.render qs
    in
        Http.get getUrl D.value
