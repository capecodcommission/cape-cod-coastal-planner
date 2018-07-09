port module Ports exposing (..)

import Json.Encode as E
import Json.Decode as D


-- COMMAND PORTS (OUTBOUND)


port logErrorCmd : E.Value -> Cmd msg


port olCmd : E.Value -> Cmd msg


-- SUBSCRIPTION PORTS (INBOUND)


port olSub : (D.Value -> msg) -> Sub msg



-- HELPER TYPES
-- maybe extract to separate file


type OpenLayersCmd
    = InitMap



encodeOpenLayersCmd : OpenLayersCmd -> E.Value
encodeOpenLayersCmd cmd = 
    case cmd of
        InitMap ->
            E.object
                [ ("cmd", E.string "init_map")
                ]
                

