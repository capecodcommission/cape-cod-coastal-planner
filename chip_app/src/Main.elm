module Main exposing (..)

import Navigation
import Html exposing (Html)
import Element exposing (..)
import Element.Attributes exposing (..)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Color exposing (..)
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
                [ olCmd <| encodeOpenLayersCmd InitMap
                , routeFx
                ]
    in
        ( updatedModel, msgs )



---- UPDATE ----


type Msg
    = Noop
    | UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
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


type MainStyles
    = None
    | Body
    | Header
    | PlanningLayers


stylesheet =
    Style.styleSheet
        [ Style.style None []
        , Style.style Body
            [ Color.background black
            ]
        , Style.style Header
            [ Color.text white
            , Color.background darkGrey
            , Font.size 35
            ]
        , Style.style PlanningLayers
            [ Color.background <| Color.rgba 0 0 0 0.7

            ]        
        ]


view : Model -> Html Msg
view model =
    Element.viewport stylesheet <|
        column Body
            [ height (percent 100) ]
            [ header Header [ height (px 45) ] <|
                text "Example"
            , mainContent None [ height fill, clip ] <|
                column None [ height fill ] <|
                    [ el None [ id "map", height fill ] empty
                    , screen (sidebar PlanningLayers [ height fill, width (px 100) ] [ empty ])
                    ]
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
