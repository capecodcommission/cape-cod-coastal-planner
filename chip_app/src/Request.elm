module Request exposing (..)

import Maybe
import Http
import Graphql.Http exposing (..)
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (..)
import RemoteData as Remote exposing (RemoteData, fromResult, WebData)
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
import Url.Builder exposing (..)
import ChipApi.Enum.SortOrder exposing (decoder)

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
    SelectionSet.succeed GqlList
        |> with (Query.shorelineLocations identity shorelineLocations)


shorelineLocations : SelectionSet ShorelineExtent ChipApi.Object.ShorelineLocation
shorelineLocations =
    SelectionSet.succeed ShorelineExtent
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
    SelectionSet.succeed identity
        |> with (Query.shorelineLocation { id = id } baselineInfo)


baselineInfo : SelectionSet BaselineInfo ChipApi.Object.ShorelineLocation
baselineInfo =
    SelectionSet.succeed BaselineInfo
        |> with SL.id
        |> with SL.name
        |> with SL.imagePath
        |> with SL.lengthMiles
        |> with SL.impervPercent
        |> with SL.criticalFacilitiesCount
        -- |> with SL.historicalPlacesCount
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
        getLittoralCells env extent
getLittoralCells : Env -> Extent -> Cmd Msg
getLittoralCells env extent =
    let
        qs =
            [ string "f" "pjson"
            , string "returnGeometry" "true"
            , string "spatialRel" "esriSpatialRelIntersects"
            , string "geometryType" "esriGeometryEnvelope"
            , string "outFields" "Id,Littoral_Cell_Name"
            , string "inSR" "3857"
            , string "outSR" "3857"
            , string "geometry" (extentToString extent)
            ]
        getUrl =
            env.agsLittoralCellUrl ++ toQuery qs
 in
    Http.riskyRequest
         { method = "GET"
         , headers = [ Http.header "Accept" "application/json, text/javascript, */*; q=0.01" ]
         , url = getUrl
         , body = Http.emptyBody
         , expect = Http.expectJson handleGetLittoralCellsResponse D.value
         , timeout = Nothing
         , tracker = Nothing
         }
    
handleGetLittoralCellsResponse : Result Http.Error D.Value -> Msg
handleGetLittoralCellsResponse result =
    case result of
        Ok _ ->
            LoadLittoralCellsResponse result
        Err err ->
            Noop


--
-- VULNERABILITY RIBBON (FEATURE SERVICE)
--


sendGetVulnRibbonRequest : Env -> ShorelineExtent -> Cmd Msg
sendGetVulnRibbonRequest env { littoralCellId } =
    getVulnRibbonForLocation env littoralCellId


getVulnRibbonForLocation : Env -> Int -> Cmd Msg
getVulnRibbonForLocation env id =
    let
        qs =
            [ string "f" "pjson"
            , string "returnGeometry" "true"
            , string "spatialRel" "esriSpatialRelIntersects"
            , string "geometryType" "esriGeometryEnvelope"
            , string "outFields" "OBJECTID,SaltMarsh,CoastalBank,Undeveloped,RibbonScore,LittoralID,BeachOwner"
            , string "inSR" "4326"
            , string "outSR" "3857"
            , string "where" ("LittoralID=" ++ String.fromInt id)
            ]
        getUrl =
            env.agsVulnerabilityRibbonUrl ++ toQuery qs
    in
        Http.request
            { method = "GET"
            , headers = [ Http.header "Accept" "application/json, text/javascript, */*; q=0.01" ]
            , url = getUrl
            , body = Http.emptyBody
            , expect = Http.expectJson handleGetVulnRibbonForLocationResponse D.value
            , timeout = Nothing
            , tracker = Nothing
            }
handleGetVulnRibbonForLocationResponse : Result Http.Error D.Value -> Msg
handleGetVulnRibbonForLocationResponse result =
    case result of
        Ok _ ->
            LoadVulnerabilityRibbonResponse result
        Err err ->
            Noop


sendGetHexesRequest : Env -> Maybe ZoneOfImpact -> Cmd Msg
sendGetHexesRequest env zoneOfImpact =
    zoneOfImpact
        |> Maybe.andThen .geometry
        |> Maybe.map (getHexesForZoneOfImpact env)
        |> Maybe.withDefault Cmd.none


getHexesForZoneOfImpact : Env -> String -> Cmd Msg
getHexesForZoneOfImpact env geometry  =
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
        Http.riskyRequest
            { method = "POST"
            , headers = [ Http.header "Accept" "application/json, text/javascript, */*; q=0.01" ]
            , url = env.agsHexUrl
            , body = body
            , expect = Http.expectJson (Remote.fromResult >> GotHexesResponse) adaptationHexesDecoder
            , timeout = Nothing
            , tracker = Nothing
            }

--
-- STORMTIDE PATHWAYS POINT QUERY
--

sendGetSTPPointRequest : Env -> String -> Cmd Msg
sendGetSTPPointRequest env feet=
        getSTPPoint env feet

getSTPPoint : Env -> String -> Cmd Msg
getSTPPoint env feet =
    let
        qs =
            [ string "f" "pjson"
            , string "returnGeometry" "true"
            , string "spatialRel" "esriSpatialRelIntersects"
            , string "geometryType" "esriGeometryPoint"
            , string "outFields" "*"
            , string "outSR" "3857"
            , string "where" ("Plane_CCCP > 0 and Plane_CCCP <=" ++ feet)
            ]
        getUrl =
            env.agsSTPPointUrl ++ toQuery qs
    in
        Http.request
         { method = "GET"
         , headers = [ Http.header "Accept" "application/json, text/javascript, */*; q=0.01" ]
         , url = getUrl
         , body = Http.emptyBody
         , expect = Http.expectJson handleGetSTPPointResponse D.value
         , timeout = Nothing
         , tracker = Nothing
         }
handleGetSTPPointResponse : Result Http.Error D.Value -> Msg
handleGetSTPPointResponse result =
    case result of
        Ok _ ->
            LoadSTPPointResponse result
        Err err ->
            Noop


--
-- CRITICAL FACILITIES (FEATURE SERVICE)
--

sendGetCritFacRequest : Env -> Cmd Msg
sendGetCritFacRequest env =
    getCritFac env

getCritFac : Env -> Cmd Msg
getCritFac env =
    let
        qs =
            [ string "f" "pjson"
            , string "returnGeometry" "true"
            , string "spatialRel" "esriSpatialRelIntersects"
            , string "geometryType" "esriGeometryPoint"
            , string "outFields" "*"
            , string "outSR" "3857"
            , string "where" "1=1"
            ]
        getUrl =
            env.agsCritUrl ++ toQuery qs
    in
        Http.request
         { method = "GET"
         , headers = [ Http.header "Accept" "application/json, text/javascript, */*; q=0.01" ]
         , url = getUrl
         , body = Http.emptyBody
         , expect = Http.expectJson handleGetCritFacResponse D.value
         , timeout = Nothing
         , tracker = Nothing
         }
handleGetCritFacResponse : Result Http.Error D.Value -> Msg
handleGetCritFacResponse result =
    case result of
        Ok _ ->
            LoadCritFacResponse result
        Err err ->
            Noop

--
-- DISCONNECTED ROADS (FEATURE SERVICE)
--

-- sendGetDRRequest : Env -> Cmd Msg
-- sendGetDRRequest env =
--     getDR env 
--     |> Http.send LoadDRResponse

-- getDR : Env -> Http.Request D.Value
-- getDR env =
--     let
--         qs =
--             QS.empty
--                 |> QS.add "f" "pjson"
--                 |> QS.add "returnGeometry" "true"
--                 |> QS.add "geometryType" "esriGeometryPolyline"
--                 |> QS.add "spatialRel" "esriSpatialRelIntersects"
--                 |> QS.add "outFields" "*"
--                 |> QS.add "outSR" "3857"
--                 |> QS.add "where" "1=1"
--         getUrl =
--             env.agsDRUrl ++ QS.render qs
--     in
--         Http.get getUrl D.value

--
-- SEA LEVEL RISE (FEATURE SERVICE)
--

-- sendGetSLRRequest : Env -> Cmd Msg
-- sendGetSLRRequest env =
--     getSLR env 
--     |> Http.send LoadSLRResponse

-- getSLR : Env -> Http.Request D.Value
-- getSLR env =
--     let
--         qs =
--             QS.empty
--                 |> QS.add "f" "json"
--                 |> QS.add "returnGeometry" "true"
--                 |> QS.add "geometryType" "esriGeometryPolygon"
--                 |> QS.add "spatialRel" "esriSpatialRelIntersects"
--                 |> QS.add "outFields" "*"
--                 |> QS.add "outSR" "3857"
--                 |> QS.add "where" "1=1"
--         getUrl =
--             env.agsSLRUrl ++ QS.render qs
--     in
--         Http.get getUrl D.value


-- --
-- -- MUNICIPALLY OWNED PARCELS (FEATURE SERVICE)
-- --

-- sendGetMOPRequest : Env -> Cmd Msg
-- sendGetMOPRequest env =
--     getMOP env 
--     |> Http.send LoadMOPResponse

-- getMOP : Env -> Http.Request D.Value
-- getMOP env =
--     let
--         qs =
--             QS.empty
--                 |> QS.add "f" "pjson"
--                 |> QS.add "returnGeometry" "true"
--                 |> QS.add "geometryType" "esriGeometryPolygon"
--                 |> QS.add "spatialRel" "esriSpatialRelIntersects"
--                 |> QS.add "outFields" "*"
--                 |> QS.add "outSR" "3857"
--                 |> QS.add "where" "1=1"
--         getUrl =
--             env.agsMOPUrl ++ QS.render qs
--     in
--         Http.get getUrl D.value