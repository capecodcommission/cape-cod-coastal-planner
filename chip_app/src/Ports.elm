port module Ports exposing (..)

import Http
import Json.Encode as E
import Json.Decode as D exposing (Decoder)
import Types exposing (..)
import ShorelineLocation as SL
import Message exposing (..)
import Result


-- COMMAND PORTS (OUTBOUND)


port logErrorCmd : E.Value -> Cmd msg


port olCmd : E.Value -> Cmd msg


type OpenLayersCmd
    = InitMap
    | ZoomToShorelineLocation SL.ShorelineExtent
    | LittoralCellsLoaded (Result Http.Error D.Value)
    | RenderVulnerabilityRibbon (Result Http.Error D.Value)
    | ClearZoneOfImpact
    | RenderLocationHexes (Result Http.Error D.Value)
    | RenderCritFac (Result Http.Error D.Value)
    | DisableCritFac 
    | RenderDR (Result Http.Error D.Value)
    | DisableDR


encodeOpenLayersCmd : OpenLayersCmd -> E.Value
encodeOpenLayersCmd cmd =
    case cmd of
        InitMap ->
            E.object
                [ ( "cmd", E.string "init_map" )
                ]

        ZoomToShorelineLocation location ->
            E.object
                [ ( "cmd", E.string "zoom_to_shoreline_location" )
                , ( "data", SL.encodeShorelineExtent location )
                ]

        LittoralCellsLoaded response ->
            E.object
                [ ( "cmd", E.string "littoral_cells_loaded" )
                , ( "data", encodeRawResponse response )
                ]

        RenderVulnerabilityRibbon response ->
            E.object
                [ ( "cmd", E.string "render_vulnerability_ribbon" )
                , ( "data", encodeRawResponse response )
                ]

        ClearZoneOfImpact ->
            E.object
                [ ( "cmd", E.string "clear_zone_of_impact" )
                ]

        RenderLocationHexes response ->
            E.object
                [ ( "cmd", E.string "render_location_hexes" )
                , ( "data", encodeRawResponse response )
                ]

        RenderCritFac response ->
            E.object
                [ ( "cmd", E.string "render_critical_facilities" )
                , ( "data", encodeRawResponse response )
                ]

        DisableCritFac ->
            E.object
                [ ( "cmd", E.string "disable_critical_facilities" )
                ]
            
        RenderDR response ->
            E.object
                [ ( "cmd", E.string "render_disconnected_roads" )
                , ( "data", encodeRawResponse response )
                ]

        DisableDR ->
            E.object
                [ ( "cmd", E.string "disable_disconnected_roads" )
                ]
            



-- SUBSCRIPTION PORTS (INBOUND)



port olSub : (D.Value -> msg) -> Sub msg


decodeOpenLayersSub : D.Value -> Msg
decodeOpenLayersSub value =
    let
        subDecoder : String -> Decoder Msg
        subDecoder sub =
            case sub of
                "load_littoral_cells" ->
                    D.field "data"
                        (D.map4 SL.Extent
                            (D.field "min_x" D.float)
                            (D.field "min_y" D.float)
                            (D.field "max_x" D.float)
                            (D.field "max_y" D.float)
                        )
                        |> D.map LoadLittoralCells

                "map_select_littoral_cell" ->
                    D.at [ "data", "name" ] D.string
                        |> D.map MapSelectLittoralCell

                "update_impact_zone" ->
                    D.field "data" zoneOfImpactDecoder
                        |> D.map UpdateZoneOfImpact

                _ ->
                    D.succeed Noop
    in
        D.field "sub" D.string
            |> D.andThen subDecoder
            |> (\decoder -> D.decodeValue decoder value)
            |> Result.toMaybe
            |> Maybe.withDefault Noop
