module View.SelectError exposing (..)

import Maybe
import Graphqelm.Http exposing (Error(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input exposing (..)
import Message exposing (..)
import Styles exposing (..)
import View.Helpers exposing (parseErrors)


view : Graphqelm.Http.Error a -> Input.Option MainStyles Variations Msg
view error =
    error
        |> parseErrors
        |> List.head
        |> Maybe.withDefault ( "Failed to load hazards", "" )
        |> errorView


errorView : ( String, String ) -> Input.Option MainStyles Variations Msg
errorView ( error, message ) =
    Input.errorAbove <|
        el (Header HeaderMenuError)
            [ attribute "title" message
            , paddingXY 4.0 2.0
            ]
        <|
            Element.text error
