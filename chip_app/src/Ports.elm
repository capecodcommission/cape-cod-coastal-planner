port module Ports exposing (..)

import Json.Encode as E
import Json.Decode as D
import Types exposing (..)


-- COMMAND PORTS (OUTBOUND)


port logErrorCmd : E.Value -> Cmd msg


port olCmd : E.Value -> Cmd msg


type OpenLayersCmd
    = InitMap
    | ZoomToShorelineLocation (ShorelineExtent -> E.Value) ShorelineExtent


encodeOpenLayersCmd : OpenLayersCmd -> E.Value
encodeOpenLayersCmd cmd =
    case cmd of
        InitMap ->
            E.object
                [ ( "cmd", E.string "init_map" )
                ]

        ZoomToShorelineLocation encoder location ->
            E.object
                [ ( "cmd", E.string "zoom_to_shoreline_location" )
                , ( "data", encoder location )
                ]



-- SUBSCRIPTION PORTS (INBOUND)


port olSub : (D.Value -> msg) -> Sub msg


type OpenLayersSub
    = LoadLittoralCells



--decodeOpenLayersSub : Decoder a
