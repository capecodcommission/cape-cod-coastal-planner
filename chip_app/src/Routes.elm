module Routes exposing (..)

import Url exposing (Url)
import Url.Parser as P exposing ((</>))
import List.Extra as LEx


type Route
    = Blank


route : P.Parser (Route -> a) a
route =
    P.oneOf
        [ P.map Blank P.top            
        ]



parseRoute : Url -> Maybe Route
parseRoute url =
    let
        parts =
            url.fragment
                |> Maybe.withDefault ""
                |> String.split "?"
                |> LEx.filterNot String.isEmpty

        ( path, query ) =
            case parts of
                [] ->
                    ( "", Nothing )

                p :: [] ->
                    ( p, Nothing )

                p :: q :: _ ->
                    ( p, Just q )
    in
    { url | path = path, query = query, fragment = Nothing }
        |> P.parse route