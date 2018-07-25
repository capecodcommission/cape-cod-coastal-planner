module View.Helpers exposing (..)

import Http
import Graphqelm.Http exposing (Error(..))
import Graphqelm.Http.GraphqlError exposing (GraphqlError)
import Element
import Element.Attributes exposing (..)
import Styles exposing (..)
import Message exposing (..)


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


{-| `forceTransparent` is a hack to...force transparency...generally on select menus due to
the fact that the value is hardcoded to be `white`. See the link below for details (line 1883).

Additionally, we must also supply all other values that are inlined so as to keep
the correct functionality, since using `attribute` in this way seems to overwrite
`Element.Attributes.inlineStyle` as used in the source.

<https://github.com/mdgriffith/style-elements/blob/4.3.0/src/Element/Input.elm>

-}
forceTransparent : Float -> Element.Attribute Variations Msg
forceTransparent width =
    let
        inlineStyles =
            [ "pointer-events:auto"
            , "display:flex"
            , "flex-direction:column"
            , "width:" ++ toString width ++ "px"
            , "position:relative"
            , "top:calc(100%+0px)"
            , "left:0px"
            , "box-sizing:border-box"
            , "cursor:pointer"
            , "z-index: 20"
            , "background:transparent"
            ]
                |> String.join ";"
    in
        attribute "style" inlineStyles
