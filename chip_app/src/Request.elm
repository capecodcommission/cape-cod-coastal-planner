module Request exposing (..)

import Maybe
import Http
import Graphqelm.Http exposing (..)
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import RemoteData as Remote exposing (RemoteData, fromResult, sendRequest)
import QueryString as QS
import Json.Decode as D
import ChipApi.Object
import ChipApi.Object.ShorelineLocation as SL
import ChipApi.Query as Query
import ChipApi.Scalar as Scalar
import Types exposing (..)
import ShorelineLocation exposing (Extent, ShorelineExtent, BaselineInfo, extentToString, shorelineExtentToExtent)
import Message exposing (..)
import AdaptationStrategy.Query
    exposing 
        ( queryAdaptationInfo
        , queryAdaptationStrategyDetailsById 
        )
import AdaptationHexes as AH
    exposing ( AdaptationHexes, adaptationHexesDecoder )

--
-- ADAPTATION INFO
--

getAdaptationInfo : Cmd Msg
getAdaptationInfo =
    queryAdaptationInfo
        |> queryRequest "./api"
        |> send (Remote.fromResult >> GotAdaptationInfo)


--
-- ADAPTATION STRATEGIES
--


getStrategyDetailsById : Scalar.Id -> Cmd Msg
getStrategyDetailsById strategyId =
    queryAdaptationStrategyDetailsById strategyId
        |> queryRequest "./api"
        |> send (Remote.fromResult >> (GotStrategyDetails strategyId))


--
-- SHORELINE EXTENTS
--


queryShorelineExtents : SelectionSet (GqlList ShorelineExtent) RootQuery
queryShorelineExtents =
    Query.selection GqlList
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
        |> with SL.littoralCellId


getShorelineExtents : Cmd Msg
getShorelineExtents =
    queryShorelineExtents
        |> queryRequest "./api"
        |> send (fromResult >> GotShorelineExtents)



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
        |> send (Remote.fromResult >> GotBaselineInfo)



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
sendGetVulnRibbonRequest env { littoralCellId } =
    littoralCellId
        |> getVulnRibbonForLocation env
        |> Http.send LoadVulnerabilityRibbonResponse


getVulnRibbonForLocation : Env -> Int -> Http.Request D.Value
getVulnRibbonForLocation env id =
    let
        qs =
            QS.empty
                |> QS.add "f" "pjson"
                |> QS.add "returnGeometry" "true"
                |> QS.add "spatialRel" "esriSpatialRelIntersects"
                |> QS.add "geometryType" "esriGeometryEnvelope"
                |> QS.add "outFields" "OBJECTID,SaltMarsh,CoastalBank,Undeveloped,RibbonScore,LittoralID,BeachOwner"
                |> QS.add "inSR" "4326"
                |> QS.add "outSR" "3857"
                |> QS.add "where" ("LittoralID=" ++ toString id)
        getUrl =
            env.agsVulnerabilityRibbonUrl ++ QS.render qs
    in
        Http.get getUrl D.value



--
-- HEX LAYER (FEATURE SERVICE)
--


sendGetHexesRequest : Env -> Maybe ZoneOfImpact -> Cmd Msg
sendGetHexesRequest env zoneOfImpact =
    zoneOfImpact
        |> Maybe.andThen .geometry
        |> Maybe.map (getHexesForZoneOfImpact env)
        |> Maybe.map Remote.sendRequest
        |> Maybe.map (Cmd.map GotHexesResponse)
        |> Maybe.withDefault Cmd.none


getHexesForZoneOfImpact : Env -> String -> Http.Request AdaptationHexes
getHexesForZoneOfImpact env geometry =
    let
        body =
            Http.multipartBody
                [ Http.stringPart "f" "json"
                , Http.stringPart "returnGeometry" "false"
                , Http.stringPart "returnDistinctValues" "true"
                , Http.stringPart "spatialRel" "esriSpatialRelIntersects"
                , Http.stringPart "geometryType" "esriGeometryPolygon" 
                , Http.stringPart "outFields" "*"
                , Http.stringPart "inSR" "3857"
                , Http.stringPart "geometry" geometry
                ]
    in
        Http.request
            { method = "POST"
            , headers = [ Http.header "Accept" "application/json, text/javascript, */*; q=0.01" ]
            , url = env.agsHexUrl
            , body = body
            , expect = Http.expectJson adaptationHexesDecoder
            , timeout = Nothing
            , withCredentials = True
            }
