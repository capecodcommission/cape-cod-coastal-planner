module View.Helpers exposing (..)

import Http
import Graphqelm.Http exposing (Error(..))
import Graphqelm.Http.GraphqlError exposing (GraphqlError)


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
