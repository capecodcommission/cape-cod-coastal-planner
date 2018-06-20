module Main exposing (..)

import Navigation
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Routes exposing (Route(..), parseRoute)
import Ports exposing (..)


---- MODEL ----


type alias Model =
    { state : Maybe Route
    }


defaultModel : Model
defaultModel =
    Model <| Just Blank


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( updatedModel, routeFx ) =
            update (UrlChange location) defaultModel

        msgs =
            Cmd.batch
                [ Cmd.none --initMapCmd ()
                , routeFx
                ]
    in
        ( updatedModel, msgs )



---- UPDATE ----


type Msg
    = NoOp
    | UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UrlChange location ->
            let
                newState =
                    parseRoute location
            in
                ( { model | state = newState }
                , Cmd.none
                )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
