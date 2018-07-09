-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module ChipApi.Enum.SortOrder exposing (..)

import Json.Decode as Decode exposing (Decoder)


type SortOrder
    = Asc
    | Desc


decoder : Decoder SortOrder
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "ASC" ->
                        Decode.succeed Asc

                    "DESC" ->
                        Decode.succeed Desc

                    _ ->
                        Decode.fail ("Invalid SortOrder type, " ++ string ++ " try re-running the graphqelm CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : SortOrder -> String
toString enum =
    case enum of
        Asc ->
            "ASC"

        Desc ->
            "DESC"