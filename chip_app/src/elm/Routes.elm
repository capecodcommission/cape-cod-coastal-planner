module Routes exposing (..)

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>))


type Route
    = Blank


route : Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Blank Url.top            
        ]


parseRoute : Location -> Maybe Route
parseRoute loc =
    Url.parseHash route loc