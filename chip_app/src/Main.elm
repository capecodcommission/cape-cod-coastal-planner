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
import View.Dropdown as Dropdown exposing (Dropdown)
import View.BaselineInfo as BaselineInfo
import Styles exposing (..)
import Ports exposing (..)


---- MODEL ----


type alias Model =
    { urlState : Maybe Route
    , coastalHazards : Dropdown CoastalHazards CoastalHazard
    , shorelineLocations : Dropdown ShorelineExtents ShorelineExtent
    }


defaultModel : Model
defaultModel =
    Model
        (Just Blank)
        { data = RemoteData.Loading
        , menu = Input.dropMenu Nothing SelectHazard
        , isOpen = False
        , name = "Hazard"
        }
        { data = RemoteData.Loading
        , menu = Input.dropMenu Nothing SelectLocation
        , isOpen = False
        , name = "Shoreline Location"
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( updatedModel, routeFx ) =
            update (UrlChange location) defaultModel

        msgs =
            Cmd.batch
                [ getCoastalHazards
                , getShorelineExtents
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
            let
                updatedHazards =
                    model.coastalHazards
                        |> (\hazards -> { hazards | data = response })
            in
                ( { model | coastalHazards = updatedHazards }
                , Cmd.none
                )

        SelectHazard msg ->
            let
                updatedHazards =
                    case parseMenuOpeningOrClosing msg of
                        Just val ->
                            model.coastalHazards
                                |> (\hazards ->
                                        { hazards
                                            | menu = Input.updateSelection msg hazards.menu
                                            , isOpen = val
                                        }
                                   )

                        Nothing ->
                            model.coastalHazards
                                |> (\hazards ->
                                        { hazards
                                            | menu = Input.updateSelection msg hazards.menu
                                        }
                                   )
            in
                ( { model | coastalHazards = updatedHazards }
                , Cmd.none
                )

        HandleShorelineExtentsResponse response ->
            let
                updatedLocations =
                    model.shorelineLocations
                        |> (\locs -> { locs | data = response })
            in
                ( { model | shorelineLocations = updatedLocations }
                , Cmd.none
                )

        SelectLocation msg ->
            let
                updatedMenu =
                    Input.updateSelection msg model.shorelineLocations.menu

                selectedLocation =
                    Input.selected updatedMenu

                selectedLocationFx =
                    selectedLocation
                        |> Maybe.map
                            (\l ->
                                if shouldLocationMenuChangeTriggerZoomTo msg then
                                    ZoomToShorelineLocation encodeShorelineExtent l
                                        |> encodeOpenLayersCmd
                                        |> olCmd
                                else
                                    Cmd.none
                            )
                        |> Maybe.withDefault Cmd.none

                updatedLocations =
                    model.shorelineLocations
                        |> (\l ->
                                case parseMenuOpeningOrClosing msg of
                                    Just val ->
                                        { l | menu = updatedMenu, isOpen = val }

                                    Nothing ->
                                        { l | menu = updatedMenu }
                           )
            in
                ( { model | shorelineLocations = updatedLocations }
                , selectedLocationFx
                )

        GetBaselineInfo ->
            let
                cmd =
                    model.shorelineLocations
                        |> .menu
                        |> Input.selected
                        |> Maybe.map (\l -> getBaselineInfo l.id)
                        |> Maybe.withDefault Cmd.none
            in
                ( model, cmd )

        HandleBaselineInfoResponse response ->
            ( model, Cmd.none )

        Animate animMsg ->
            ( model, Cmd.none )


{-| This is sort of a hack to get around the opaque implementations of
Input.SelectMsg and Input.SelectMenu.
-}
parseMenuOpeningOrClosing : Input.SelectMsg a -> Maybe Bool
parseMenuOpeningOrClosing message =
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


{-| This is sort of a hack to get around the opaque implementations of
Input.SelectMsg and Input.SelectMenu.
-}
shouldLocationMenuChangeTriggerZoomTo : Input.SelectMsg a -> Bool
shouldLocationMenuChangeTriggerZoomTo message =
    let
        msg =
            toString message
    in
        String.contains "SelectValue" msg



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
                    [ spacingXY 16 0 ]
                    [ Dropdown.view model.coastalHazards
                    , Dropdown.view model.shorelineLocations
                    , BaselineInfo.view
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
