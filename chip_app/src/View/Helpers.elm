module View.Helpers exposing (..)

import Http
import Graphqelm.Http exposing (Error(..))
import Graphqelm.Http.GraphqlError exposing (GraphqlError)
import Element exposing (Attribute)
import Element.Attributes exposing (..)
import Styles exposing (..)
import Message exposing (..)
import ChipApi.Scalar as Scalar
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (usLocale)


parseErrors : Graphqelm.Http.Error a -> List ( String, String )
parseErrors error =
    case error of
        HttpError err ->
            parseHttpError err

        GraphqlError _ errs ->
            parseGraphqlErrors errs


parseHttpError : Http.Error -> List ( String, String )
parseHttpError error =
    case error of
        Http.BadUrl msg ->
            [ ( "BadUrl", msg ) ]

        Http.Timeout ->
            [ ( "Timeout", "The operation timed out" ) ]

        Http.NetworkError ->
            [ ( "Network Error", "There is an error with the network" ) ]

        Http.BadStatus { status } ->
            [ ( "Bad Status", status.message ++ " (" ++ toString status.code ++ ")" ) ]

        Http.BadPayload msg { status } ->
            [ ( "Bad Payload", msg ++ " (" ++ toString status.code ++ ")" ) ]


parseGraphqlErrors : List GraphqlError -> List ( String, String )
parseGraphqlErrors errors =
    errors
        |> List.map
            (\err ->
                ( "GraphQL Error", err.message )
            )


title : String -> Attribute Variations Msg
title t =
    attribute "title" t


formatBoolean : Bool -> String
formatBoolean boolean =
    case boolean of
        True ->
            "Yes"

        False ->
            "No"


formatDecimal : Int -> Scalar.Decimal -> String
formatDecimal precision decimal =
    decimal
        |> parseDecimal precision
        |> Result.map (format { usLocale | decimals = precision })
        |> Result.toMaybe
        |> Maybe.withDefault "Err!"


parseDecimal : Int -> Scalar.Decimal -> Result String Float
parseDecimal precision (Scalar.Decimal decimal) =
    let
        multiplier =
            List.repeat precision 10
                |> List.foldr (*) 1
    in
        decimal
            |> String.toFloat
            |> Result.map
                (\num ->
                    num
                        * multiplier
                        |> round
                        |> toFloat
                        |> flip (/) multiplier
                )
