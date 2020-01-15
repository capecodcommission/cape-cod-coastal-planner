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
    | RenderCritFac 
    | DisableCritFac 
    | RenderDR (String)
    | DisableDR (String)
    | RenderSLR (String)
    | DisableSLR (String)
    | RenderMOP 
    | DisableMOP
    | RenderPPR
    | DisablePPR
    | RenderSP
    | DisableSP
    | RenderCDS
    | DisableCDS
    | RenderFZ
    | DisableFZ
    | RenderSlosh
    | DisableSlosh
    | RenderFourtyYears
    | DisableFourtyYears
    | RenderSTI
    | DisableSTI
    | ClearLayers
    | RenderStructures
    | DisableStructures
    | ResetAllOL
    | ZoomInOL
    | ZoomOutOL
    | GetLocOL
    | DisableVulnOL
    | RenderVulnOL
    | RenderHistDist
    | DisableHistDist
    | RenderHistPlaces
    | DisableHistPlaces


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

        RenderCritFac ->
            E.object
                [ ( "cmd", E.string "render_critical_facilities" )
                ]

        DisableCritFac ->
            E.object
                [ ( "cmd", E.string "disable_critical_facilities" )
                ]
            
        RenderDR level ->
            E.object
                [ ( "cmd", E.string "render_disconnected_roads" )
                , ("data", E.string level)
                ]

        DisableDR level ->
            E.object
                [ ( "cmd", E.string "disable_disconnected_roads" )
                , ("data", E.string level)
                ]

        RenderSLR level ->
            E.object
                [ ( "cmd", E.string "render_slr" )
                , ("data", E.string level)
                ]
        
        DisableSLR level ->
            E.object
                [ ( "cmd", E.string "disable_sea_level_rise" )
                , ("data", E.string level)
                ]

        RenderMOP ->
            E.object
                [ ( "cmd", E.string "render_municipally_owned_parcels" )
                ]

        DisableMOP ->
            E.object
                [ ( "cmd", E.string "disable_municipally_owned_parcels" )
                ]

        RenderPPR ->
            E.object
                [ ( "cmd", E.string "render_public_private_roads" )
                ]

        DisablePPR ->
            E.object
                [ ( "cmd", E.string "disable_public_private_roads" )
                ]

        RenderSP ->
            E.object
                [ ( "cmd", E.string "render_sewered_parcels" )
                ]

        DisableSP ->
            E.object
                [ ( "cmd", E.string "disable_sewered_parcels" )
                ]

        RenderCDS ->
            E.object
                [ ( "cmd", E.string "render_coastal_defense_structures" )
                ]

        DisableCDS ->
            E.object
                [ ( "cmd", E.string "disable_coastal_defense_structures" )
                ]

        RenderFZ ->
            E.object
                [ ( "cmd", E.string "render_flood_zones" )
                ]

        DisableFZ ->
            E.object
                [ ( "cmd", E.string "disable_flood_zones" )
                ]

        RenderSlosh ->
            E.object
                [ ( "cmd", E.string "render_slosh_layer" )
                ]

        DisableSlosh ->
            E.object
                [ ( "cmd", E.string "disable_slosh_layer" )
                ]

        RenderFourtyYears ->
            E.object
                [ ( "cmd", E.string "render_fourty_years" )
                ]

        DisableFourtyYears ->
            E.object
                [ ( "cmd", E.string "disable_fourty_years" )
                ]

        RenderSTI ->
            E.object
                [ ( "cmd", E.string "render_sediment_transport" )
                ]

        DisableSTI ->
            E.object
                [ ( "cmd", E.string "disable_sediment_transport" )
                ]

        DisableStructures ->
            E.object
                [ ( "cmd", E.string "disable_structures" )
                ]

        RenderStructures ->
            E.object
                [ ( "cmd", E.string "render_structures" )
                ]

        ClearLayers ->
            E.object
                [ ( "cmd", E.string "clear_layers" )

                ]

        ResetAllOL ->
            E.object
                [ ( "cmd", E.string "reset_all" )

                ]

        ZoomInOL -> 
            E.object
                [ ( "cmd", E.string "zoom_in" )

                ]
        
        ZoomOutOL -> 
            E.object
                [ ( "cmd", E.string "zoom_out" )

                ]

        GetLocOL -> 
            E.object
                [ ( "cmd", E.string "get_loc" )

                ]

        DisableVulnOL -> 
            E.object
                [ ( "cmd", E.string "disable_vuln_ribbon" )

                ]

        RenderVulnOL -> 
            E.object
                [ ( "cmd", E.string "render_vuln_ribbon" )

                ]
            
        RenderHistDist -> 
            E.object
                [ ( "cmd", E.string "render_historic_districts" )

                ]

        DisableHistDist -> 
            E.object
                [ ( "cmd", E.string "disable_historic_districts" )

                ]

        RenderHistPlaces -> 
            E.object
                [ ( "cmd", E.string "render_historic_places" )

                ]

        DisableHistPlaces -> 
            E.object
                [ ( "cmd", E.string "disable_historic_places" )

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
