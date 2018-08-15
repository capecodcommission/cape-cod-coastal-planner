module Main exposing (..)

import Navigation
import Http
import Html exposing (Html)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input exposing (..)
import Animation
import Window
import RemoteData exposing (RemoteData(..))
import Json.Decode as D exposing (..)
import Dict exposing (Dict)
import Maybe
import Types exposing (..)
import Message exposing (..)
import Request exposing (..)
import Routes exposing (Route(..), parseRoute)
import View.Dropdown as Dropdown exposing (Dropdown)
import View.BaselineInfo as BaselineInfo exposing (..)
import View.Helpers exposing (..)
import Styles exposing (..)
import ChipApi.Scalar as Scalar
import Ports exposing (..)


---- MODEL ----


type alias Model =
    { urlState : Maybe Route
    , device : Device
    , coastalHazards : Dropdown CoastalHazards CoastalHazard
    , shorelineLocations : Dropdown ShorelineExtents ShorelineExtent
    , baselineInformation : BaselineInformation
    , baselineModal : GqlData (Maybe BaselineInfo)
    , closePath : String
    }


defaultModel : Model
defaultModel =
    Model
        -- Initial Route State
        (Just Blank)
        -- Default (no) device
        { width = 0
        , height = 0
        , phone = False
        , tablet = False
        , desktop = False
        , bigDesktop = False
        , portrait = False
        }
        -- Coastal Hazard Dropdown
        { data = RemoteData.Loading
        , menu = Input.dropMenu Nothing SelectHazard
        , isOpen = False
        , name = "Hazard"
        }
        -- Shoreline Location Dropdown
        { data = RemoteData.Loading
        , menu = Input.dropMenu Nothing SelectLocation
        , isOpen = False
        , name = "Shoreline Location"
        }
        -- Baseline Information
        Dict.empty
        -- Baseline Modal
        NotAsked
        -- closePath
        ""


type alias Flags =
    { closePath : String
    , size : Window.Size
    }


decodeWindowSize : Decoder Window.Size
decodeWindowSize =
    D.map2 Window.Size
        (D.field "width" D.int)
        (D.field "height" D.int)


decodeFlags : Decoder Flags
decodeFlags =
    D.map2 Flags
        (D.field "closePath" D.string)
        (D.field "size" decodeWindowSize)


init : D.Value -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    case D.decodeValue decodeFlags flags of
        Ok data ->
            let
                ( updatedModel, routeFx ) =
                    defaultModel
                        |> (\model ->
                                { model
                                    | closePath = data.closePath
                                    , device = classifyDevice data.size
                                }
                           )
                        |> update (UrlChange location)

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

        Err err ->
            ( defaultModel, Cmd.none )



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
                                    ZoomToShorelineLocation l
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
            case getCachedBaselineInfo model of
                Just info ->
                    ( { model | baselineModal = Success (Just info) }, Cmd.none )

                Nothing ->
                    case getRemoteBaselineInfo model of
                        Just command ->
                            ( { model | baselineModal = Loading }, command )

                        Nothing ->
                            ( model, Cmd.none )

        HandleBaselineInfoResponse response ->
            case response of
                Success (Just info) ->
                    ( { model
                        | baselineInformation = cacheBaselineInfo info.id info model.baselineInformation
                        , baselineModal = response
                      }
                    , Cmd.none
                    )

                _ ->
                    ( { model | baselineModal = response }, Cmd.none )

        CloseBaselineInfo ->
            ( { model | baselineModal = NotAsked }, Cmd.none )

        LoadLittoralCells extent ->
            ( model
            , sendGetLittoralCellsRequest extent
            )

        LoadLittoralCellsResponse value ->
            ( model
            , olCmd <| encodeOpenLayersCmd (LittoralCellsLoaded value)
            )

        Animate animMsg ->
            ( model, Cmd.none )

        Resize size ->
            ( { model | device = classifyDevice size }
            , Cmd.none
            )


getCachedBaselineInfo : Model -> Maybe BaselineInfo
getCachedBaselineInfo { shorelineLocations, baselineInformation } =
    shorelineLocations
        |> getSelectedLocationId
        |> Maybe.andThen
            (\(Scalar.Id id) ->
                Dict.get id baselineInformation
            )


cacheBaselineInfo : Scalar.Id -> BaselineInfo -> BaselineInformation -> BaselineInformation
cacheBaselineInfo (Scalar.Id id) info dict =
    Dict.insert id info dict


getRemoteBaselineInfo : Model -> Maybe (Cmd Msg)
getRemoteBaselineInfo { shorelineLocations } =
    shorelineLocations
        |> getSelectedLocationId
        |> Maybe.map (\id -> getBaselineInfo id)


getSelectedLocationId : Dropdown ShorelineExtents ShorelineExtent -> Maybe Scalar.Id
getSelectedLocationId dropdown =
    dropdown.menu
        |> Input.selected
        |> Maybe.map .id


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
headerView ({ device } as model) =
    header (Header HeaderBackground) [ height (px <| adjustOnHeight ( 60, 80 ) device) ] <|
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
                    , BaselineInfo.view model
                    ]
                ]
            ]



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Animation.subscription Animate []
        , Window.resizes Resize
        , olSub decodeOpenLayersSub
        ]



---- PROGRAM ----


main : Program D.Value Model Msg
main =
    Navigation.programWithFlags UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
