module Main exposing (..)

import Navigation
import Html exposing (Html)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input exposing (..)
import RemoteData exposing (WebData)
import Animation
import Window
import RemoteData exposing (RemoteData(..))
import Json.Decode as D exposing (..)
import Dict exposing (Dict)
import Maybe
import List.Extra as LEx
import Types exposing (..)
import Message exposing (..)
import Request exposing (..)
import Routes exposing (Route(..), parseRoute)
import View.Dropdown as Dropdown exposing (Dropdown)
import View.BaselineInfo as BaselineInfo exposing (..)
import View.ZoneOfImpact as ZoneOfImpact
import View.Helpers exposing (..)
import Styles exposing (..)
import ChipApi.Scalar as Scalar
import Ports exposing (..)


---- MODEL ----


type App
    = Loaded Model
    | Failure String


type alias Model =
    { env : Env
    , urlState : Maybe Route
    , device : Device
    , closePath : String
    , coastalHazards : Dropdown CoastalHazards CoastalHazard
    , shorelineLocations : Dropdown ShorelineExtents ShorelineExtent
    , baselineInformation : BaselineInformation
    , baselineModal : GqlData (Maybe BaselineInfo)
    , vulnerabilityRibbon : WebData D.Value
    , zoneOfImpact : PopupState
    }


initialModel : Flags -> Model
initialModel flags =
    Model
        -- Environment variables
        flags.env
        -- Initial Route State
        (Just Blank)
        -- initial Device
        (classifyDevice flags.size)
        -- closePath
        flags.closePath
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
        -- Vulernability Ribbon segments
        NotAsked
        -- Zone of Impact popup
        PopupDisabled


init : D.Value -> Navigation.Location -> ( App, Cmd Msg )
init flags location =
    case D.decodeValue decodeFlags flags of
        Ok flagData ->
            let
                ( updatedApp, routeFx ) =
                    flagData
                        |> initialModel
                        |> Loaded
                        |> update (UrlChange location)

                msgs =
                    Cmd.batch
                        [ getCoastalHazards
                        , getShorelineExtents
                        , olCmd <| encodeOpenLayersCmd InitMap
                        , routeFx
                        ]
            in
                ( updatedApp
                , msgs
                )

        Err err ->
            ( Failure err, Cmd.none )



---- UPDATE ----


update : Msg -> App -> ( App, Cmd Msg )
update msg app =
    case app of
        Loaded model ->
            updateModel msg model
                |> (\( model, cmds ) -> ( Loaded model, cmds ))

        Failure err ->
            ( Failure err, Cmd.none )


updateModel : Msg -> Model -> ( Model, Cmd Msg )
updateModel msg model =
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
                            (\selection ->
                                if shouldLocationMenuChangeTriggerZoomTo msg then
                                    ZoomToShorelineLocation selection
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
            , sendGetLittoralCellsRequest model.env extent
            )

        LoadLittoralCellsResponse response ->
            ( model
            , olCmd <| encodeOpenLayersCmd (LittoralCellsLoaded response)
            )

        MapSelectLittoralCell name ->
            case getLocationByName name model.shorelineLocations of
                Just selection ->
                    let
                        updatedMenu =
                            Input.dropMenu (Just selection) SelectLocation

                        updatedLocations =
                            model.shorelineLocations
                                |> (\l -> { l | menu = updatedMenu })
                    in
                        ( { model | shorelineLocations = updatedLocations }
                        , Cmd.batch
                            [ ZoomToShorelineLocation selection
                                |> encodeOpenLayersCmd
                                |> olCmd
                            , sendGetVulnRibbonRequest model.env selection
                            ]
                        )

                Nothing ->
                    ( model, Cmd.none )

        LoadVulnerabilityRibbonResponse response ->
            ( model
            , olCmd <| encodeOpenLayersCmd (RenderVulnerabilityRibbon response)
            )

        ChangeZoneOfImpactState state ->
            ( { model | zoneOfImpact = state }
            , olCmd <| encodeOpenLayersCmd (PositionZoneOfImpactPopup state)
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


getLocationByName : String -> Dropdown ShorelineExtents ShorelineExtent -> Maybe ShorelineExtent
getLocationByName name dropdown =
    case dropdown.data of
        Success { items } ->
            LEx.find (\item -> item.name == name) items

        _ ->
            Nothing


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


view : App -> Html Msg
view app =
    case app of
        Loaded model ->
            Element.viewport stylesheet <|
                column NoStyle
                    [ height (percent 100) ]
                    [ headerView model
                    , mainContent NoStyle [ height fill, clip ] <|
                        column NoStyle [ height fill ] <|
                            [ el NoStyle [ id "map", height fill ] empty
                                |> within []
                            ]
                    , ZoneOfImpact.view model
                    ]

        Failure err ->
            Html.div []
                [ Html.div [] [ Html.text "FAILED TO LOAD APP!" ]
                , Html.div [] [ Html.text "TODO: Make prettier :D" ]
                , Html.div [] [ Html.text err ]
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


subscriptions : App -> Sub Msg
subscriptions app =
    case app of
        Loaded model ->
            Sub.batch
                [ Animation.subscription Animate []
                , Window.resizes Resize
                , olSub decodeOpenLayersSub
                ]

        Failure err ->
            Sub.none



---- PROGRAM ----


main : Program D.Value App Msg
main =
    Navigation.programWithFlags UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
