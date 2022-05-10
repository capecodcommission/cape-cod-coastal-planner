module View.Helpers exposing (..)

import Http
import Animation
import Basics
import Graphql.Http as Ghttp exposing (Error)
import Graphql.Http.GraphqlError exposing (GraphqlError)
import Element exposing (..)
import Element.Attributes exposing (..)
import Message exposing (..)
import ChipApi.Scalar as Scalar
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (Decimals(..), usLocale)
import Flip




renderAnimation : Animation.State -> List (Element.Attribute variation Msg) -> List (Element.Attribute variation Msg)
renderAnimation animations otherAttrs =
    (List.map Element.Attributes.toAttr <| Animation.render animations) ++ otherAttrs


parseErrors : Ghttp.Error a -> List ( String, String )
parseErrors error =
    case error of
        Ghttp.GraphqlError possiblyParsedData errors ->
            (case possiblyParsedData of
                Graphql.Http.GraphqlError.UnparsedData unparsed ->
                    [("GraphQL errors:" ++ Debug.toString errors, "Unable to parse data, got: " ++ Debug.toString unparsed)]

                Graphql.Http.GraphqlError.ParsedData parsedData ->
                    [("Parsed error data", "Parsed error data, so I can extract the name from the structured data... ")]
            
            )

        Ghttp.HttpError httpError ->
            [("HttpError", "Http error " ++ Debug.toString httpError)]

parseHttpError : Http.Error -> ( String, String )
parseHttpError error =
    case error of
        Http.BadUrl msg ->
            ( "BadUrl", msg )

        Http.Timeout ->
            ( "Timeout", "The operation timed out" )

        Http.NetworkError ->
            ( "Network Error", "There is an error with the network" )

        Http.BadStatus status ->
            ( "Bad status" , String.fromInt status )

        Http.BadBody err ->
            ( "Bad body", err )


parseGraphqlErrors : List GraphqlError -> List ( String, String )
parseGraphqlErrors errors =
    errors
        |> List.map
            (\err ->
                ( "GraphQL Error", err.message )
            )


title : String -> Attribute variations Msg
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
        |> Result.map (format { usLocale | decimals = (Exact precision) })
        |> Result.toMaybe
        |> Maybe.withDefault "Err!"

convertVal: Maybe Float -> (Result String Float)
convertVal mFlt = 
    case mFlt of 
        Just flt ->
            Ok flt
        _ ->
            Err "failed"
parseDecimal : Int -> Scalar.Decimal -> Result String Float
parseDecimal precision (Scalar.Decimal decimal) =
    let
        multiplier =
            List.repeat precision 10
                |> List.foldr (*) 1
    in
        decimal
            |> String.toFloat
            |> convertVal
            |> Result.map
                (\num ->
                    num
                        * multiplier
                        |> round
                        |> toFloat
                        |> Flip.flip (/) multiplier
                )

adjustOnHeight : ( Float, Float ) -> Device -> Float
adjustOnHeight range device =
    responsive (toFloat device.height) ( 600, 1200 ) range


adjustOnWidth : ( Float, Float ) -> Device -> Float
adjustOnWidth range device =
    responsive (toFloat device.width) ( 1200, 1800 ) range

