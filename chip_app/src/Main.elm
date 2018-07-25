module Main exposing (..)

import Navigation
import Html exposing (Html)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input exposing (..)
import Animation
import RemoteData exposing (RemoteData(..))
import Maybe
import Types exposing (..)
import Message exposing (..)
import Request exposing (..)
import Routes exposing (Route(..), parseRoute)
import View.SelectHazard as SelectHazard
import View.SelectLocation as SelectLocation
import Styles exposing (..)
import Ports exposing (..)


---- MODEL ----


type alias Model =
    { urlState : Maybe Route

    -- coastal hazard data
    , coastalHazards : GqlData CoastalHazardsResponse
    , hazardMenu : SelectWith CoastalHazard Msg
    , isHazardMenuOpen : Bool
    , numHazards : Int

    -- shoreline location data
    , shorelineLocations : GqlData ShorelineLocationsResponse
    , locationMenu : SelectWith ShorelineLocation Msg
    , isLocationMenuOpen : Bool
    , numLocations : Int
    }


defaultModel : Model
defaultModel =
    Model
        (Just Blank)
        -- coastal hazard defaults
        RemoteData.Loading
        (Input.dropMenu Nothing SelectHazard)
        False
        0
        -- shoreline location defaults
        RemoteData.Loading
        (Input.dropMenu Nothing SelectLocation)
        False
        0


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( updatedModel, routeFx ) =
            update (UrlChange location) defaultModel

        msgs =
            Cmd.batch
                [ getCoastalHazards
                , getShorelineLocations
                , olCmd <| encodeOpenLayersCmd InitMap
                , routeFx
                ]
    in
        ( updatedModel
        , msgs
        )



---- UPDATE ----


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
                ( { model | urlState = newState }
                , Cmd.none
                )

        HandleCoastalHazardsResponse response ->
            case response of
                NotAsked ->
                    ( { model | coastalHazards = response }, Cmd.none )

                Loading ->
                    ( { model | coastalHazards = response }, Cmd.none )

                Success data ->
                    ( { model | coastalHazards = response, numHazards = List.length data.hazards }
                    , Cmd.none
                    )

                Failure err ->
                    ( { model | coastalHazards = response }, Cmd.none )

        SelectHazard msg ->
            let
                updatedMenu =
                    Input.updateSelection msg model.hazardMenu
            in
                case parseSelectMenuChange msg of
                    Just val ->
                        ( { model | hazardMenu = updatedMenu, isHazardMenuOpen = val }, Cmd.none )

                    Nothing ->
                        ( { model | hazardMenu = updatedMenu }, Cmd.none )

        HandleShorelineLocationsResponse response ->
            case response of
                NotAsked ->
                    ( { model | shorelineLocations = response }, Cmd.none )

                Loading ->
                    ( { model | shorelineLocations = response }, Cmd.none )

                Success data ->
                    ( { model | shorelineLocations = response, numLocations = List.length data.locations }
                    , Cmd.none
                    )

                Failure err ->
                    ( { model | shorelineLocations = response }, Cmd.none )

        SelectLocation msg ->
            let
                updatedMenu =
                    Input.updateSelection msg model.locationMenu
            in
                case parseSelectMenuChange msg of
                    Just val ->
                        ( { model | locationMenu = updatedMenu, isLocationMenuOpen = val }, Cmd.none )

                    Nothing ->
                        ( { model | locationMenu = updatedMenu }, Cmd.none )

        Animate animMsg ->
            ( model, Cmd.none )


{-| This is sort of a hack to get around the opaque implementations of
Input.SelectMsg and Input.SelectMenu.
-}
parseSelectMenuChange : Input.SelectMsg a -> Maybe Bool
parseSelectMenuChange message =
    let
        msg =
            toString message
    in
        if String.contains "OpenMenu" msg then
            Just True
        else if String.contains "CloseMenu" msg then
            Just False
        else
            Nothing



---- VIEW ----


renderAnimation : Animation.State -> List (Element.Attribute variation Msg) -> List (Element.Attribute variation Msg)
renderAnimation animations otherAttrs =
    (List.map Element.Attributes.toAttr <| Animation.render animations) ++ otherAttrs


view : Model -> Html Msg
view model =
    Element.viewport stylesheet <|
        column NoStyle
            [ height (percent 100) ]
            [ headerView model
            , mainContent NoStyle [ height fill, clip ] <|
                column NoStyle [ height fill ] <|
                    [ el NoStyle [ id "map", height fill ] empty
                        |> within []
                    ]
            ]


headerView : Model -> Element MainStyles Variations Msg
headerView model =
    header (Header HeaderBackground) [ height (px 80) ] <|
        row NoStyle [ height fill, paddingXY 54.0 0.0, spacingXY 54.0 0.0 ] <|
            [ column NoStyle
                [ verticalCenter ]
                [ h1 (Header HeaderTitle) [] <| Element.text "Coastal Hazard Impact Planner" ]
            , column NoStyle
                [ verticalCenter, alignRight, width fill ]
                [ row NoStyle
                    []
                    [ SelectHazard.view model
                    , SelectLocation.view model
                    ]
                ]
            ]



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate []



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
