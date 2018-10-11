module Main exposing (..)

import Navigation
import Html exposing (Html)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input exposing (..)
import RemoteData exposing (WebData)
import Animation
import Animations
import Window
import RemoteData as Remote exposing (RemoteData(..))
import Json.Decode as D exposing (..)
import Dict exposing (Dict)
import Maybe
import Dom
import Task
import List.Extra as LEx
import List.Zipper as Zipper
import Keyboard.Key exposing (Key(Up, Down, Enter, Escape))
import Types exposing (..)
import AdaptationStrategy as AS exposing (Strategy(..), Strategies, StrategyDetails)
import Message exposing (..)
import Request exposing (..)
import Routes exposing (Route(..), parseRoute)
import View.Dropdown as Dropdown exposing (Dropdown)
import View.BaselineInfo as BaselineInfo exposing (..)
import View.RightSidebar as RSidebar
import View.ZoneOfImpact as ZOI
import View.StrategiesModal as StrategiesModal
import View.Helpers exposing (..)
import Styles exposing (..)
import ChipApi.Scalar as Scalar
import Ports exposing (..)


---- MODEL ----


type App
    = Loaded Model
    | Failed String


type alias Model =
    { env : Env
    , urlState : Maybe Route
    , device : Device
    , closePath : String
    , trianglePath : String
    , zoiPath : String
    , coastalHazards : Dropdown CoastalHazards Types.CoastalHazard
    , shorelineLocations : Dropdown ShorelineExtents ShorelineExtent
    , baselineInformation : BaselineInformation
    , baselineModal : GqlData (Maybe BaselineInfo)
    , vulnerabilityRibbon : WebData D.Value
    , zoneOfImpact : Maybe ZoneOfImpact
    , rightSidebarOpenness : Openness
    , rightSidebarFx : Animation.State
    , rightSidebarToggleFx : Animation.State
    , strategies : GqlData Strategies
    , strategiesModalOpenness : Openness
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
        -- image paths
        flags.closePath
        flags.trianglePath
        flags.zoiPath
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
        -- Zone of Impact data        
        Nothing
        -- right sidebar
        Closed
        (Animation.style <| .closed <| Animations.rightSidebarStates)
        (Animation.style <| .rotateNeg180 <| Animations.toggleStates)
        -- strategies
        NotAsked
        Closed


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
            ( Failed err, Cmd.none )



---- UPDATE ----


update : Msg -> App -> ( App, Cmd Msg )
update msg app =
    case app of
        Loaded model ->
            updateModel msg model
                |> (\( model, cmds ) -> ( Loaded model, cmds ))

        Failed err ->
            ( Failed err, Cmd.none )


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

        GotCoastalHazards response ->
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

        GotShorelineExtents response ->
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

        GotBaselineInfo response ->
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
                            , sendGetHexesRequest model.env selection
                            ]
                        )

                Nothing ->
                    ( model, Cmd.none )

        LoadVulnerabilityRibbonResponse response ->
            ( model
            , olCmd <| encodeOpenLayersCmd (RenderVulnerabilityRibbon response)
            )

        LoadLocationHexesResponse response ->
            ( model
            , olCmd <| encodeOpenLayersCmd (RenderLocationHexes response)
            )

        UpdateZoneOfImpact zoi ->
            ( model
                |> expandRightSidebar
                |> \m -> { m | zoneOfImpact = Just zoi }
            , Cmd.none
            )

        CancelZoneOfImpactSelection ->
            ( model
                |> collapseRightSidebar
                |> \m -> { m | zoneOfImpact = Nothing }
            , olCmd <| encodeOpenLayersCmd ClearZoneOfImpact
            )

        PickStrategy ->
            case model.strategies of
                Success (Just strategies) ->
                    let
                        newCmd =
                            case AS.getSelectedStrategyHtmlId (Just strategies) of
                                Just id -> focus id

                                Nothing -> Cmd.none
                    in
                    ( model
                        |> collapseRightSidebar
                        |> \m -> 
                            { m | 
                                strategiesModalOpenness = Open
                            }
                    , newCmd
                    )

                _ ->
                    ( model
                        |> collapseRightSidebar
                        |> \m -> { m | strategies = Loading, strategiesModalOpenness = Open }
                    , getActiveAdaptationStrategies
                    )

        CloseStrategyModal ->
            ( model
                |> expandRightSidebar
                |> \m -> { m | strategiesModalOpenness = Closed }
            , Cmd.none
            )

        GotActiveStrategies response ->
            case response of
                NotAsked ->
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                Success activeStrategies ->
                    let
                        ( newStrategies, newCmd ) =
                            activeStrategies
                                |> AS.mapStrategiesFromActiveStrategies
                                |> Success
                                |> Remote.update selectFirstStrategy                                
                    in
                    ( { model | strategies = newStrategies }, newCmd )

                Failure err ->
                    ( { model | strategies = Failure <| AS.mapErrorFromActiveStrategies err } , Cmd.none)                
                    
        SelectStrategy id ->
            let
                ( newStrategies, newCmd ) =
                    Remote.update (selectStrategy id) model.strategies
            in
            ( { model | strategies = newStrategies }, newCmd )
            

        HandleStrategyKeyboardEvent evt ->
            case evt.keyCode of
                Down ->
                    let
                        ( newStrategies, newCmd ) =
                            Remote.update selectNextStrategy model.strategies
                    in
                    ( { model | strategies = newStrategies }, newCmd )

                Up ->
                    let
                        ( newStrategies, newCmd ) =
                            Remote.update selectPreviousStrategy model.strategies
                    in
                    ( { model | strategies = newStrategies }, newCmd )

                Enter ->
                    ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        GotStrategyDetails id response ->
            let
                ( newStrategies, newCmd ) =
                    Remote.update (updateStrategiesWithStrategyDetails id response) model.strategies
            in
            ( { model | strategies = newStrategies }, newCmd )


        ToggleRightSidebar ->
            case model.rightSidebarOpenness of
                Open ->
                    ( model |> collapseRightSidebar, Cmd.none )

                Closed ->
                    ( model |> expandRightSidebar, Cmd.none )


        Animate animMsg ->
            ( { model
                | rightSidebarFx = Animation.update animMsg model.rightSidebarFx
                , rightSidebarToggleFx = Animation.update animMsg model.rightSidebarToggleFx
            }
            , Cmd.none
            )

        Resize size ->
            ( { model | device = classifyDevice size }
            , Cmd.none
            )


updateStrategiesWithStrategyDetails : 
    Scalar.Id 
    -> (GqlData (Maybe StrategyDetails)) 
    -> Strategies 
    -> (Strategies, Cmd Msg)
updateStrategiesWithStrategyDetails id details strategies =
    let
        currentStrategyId = 
            strategies
                |> AS.currentStrategy
                |> Maybe.map (\(Strategy s) -> s.id)

        ( newStrategies, newCmd ) =
            if currentStrategyId == Just id then
                strategies 
                    |> Maybe.map 
                        (Zipper.mapCurrent <| 
                            AS.updateStrategyDetails details
                        )
                    |> \z -> ( z, Cmd.none )
            else
                strategies
                    |> Maybe.map
                        (Zipper.map <|
                            (\(Strategy s) ->
                                if s.id == id then
                                    AS.updateStrategyDetails details (Strategy s)
                                else
                                    Strategy s
                            )
                        )
                    |> \z -> ( z, Cmd.none )
    in
    ( newStrategies, newCmd )


selectStrategy : Scalar.Id -> Strategies -> (Strategies, Cmd Msg)
selectStrategy id strategies =
    let
        newStrategies = AS.findStrategy id strategies

        newCmd =
            case AS.getSelectedStrategyHtmlId newStrategies of
                Just id -> focus id

                Nothing -> Cmd.none
    in
    ( newStrategies, newCmd )


selectFirstStrategy : Strategies -> (Strategies, Cmd Msg)
selectFirstStrategy strategies =
    let
        newStrategies = AS.firstStrategy strategies

        newCmd =
            case AS.getSelectedStrategyHtmlId newStrategies of
                Just id -> focus id

                Nothing -> Cmd.none
    in
    ( newStrategies, newCmd )

selectNextStrategy : Strategies -> (Strategies, Cmd Msg)
selectNextStrategy strategies =
    let
        newStrategies = AS.nextStrategy strategies

        newCmd = 
            case AS.getSelectedStrategyHtmlId newStrategies of
                Just id -> focus id

                Nothing -> Cmd.none
    in
    ( newStrategies, newCmd )


selectPreviousStrategy : Strategies -> (Strategies, Cmd Msg)
selectPreviousStrategy strategies =
    let
        newStrategies = AS.previousStrategy strategies

        newCmd = 
            case AS.getSelectedStrategyHtmlId newStrategies of
                Just id -> focus id

                Nothing -> Cmd.none
    in
    ( newStrategies, newCmd )


collapseRightSidebar : Model -> Model
collapseRightSidebar model =
    { model
        | rightSidebarOpenness = Closed
        , rightSidebarFx =
            Animation.interrupt
                [ Animation.to <| .closed <| Animations.rightSidebarStates ]
                model.rightSidebarFx
        , rightSidebarToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 5.0 }) <| .rotateNeg180 <| Animations.toggleStates ]
                model.rightSidebarToggleFx
    }



expandRightSidebar : Model -> Model
expandRightSidebar model =
    { model
        | rightSidebarOpenness = Open
        , rightSidebarFx =
            Animation.interrupt
                [ Animation.to <| .open <| Animations.rightSidebarStates ]
                model.rightSidebarFx
        , rightSidebarToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 5.0 }) <| .rotateZero <| Animations.toggleStates ]
                model.rightSidebarToggleFx
    }


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


focus : String -> Cmd Msg
focus elementId =
    Task.attempt (\_ -> Noop) <|
        Dom.focus elementId


blur : String -> Cmd Msg
blur elementId =
    Task.attempt (\_ -> Noop) <|
        Dom.blur elementId


---- VIEW ----


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
                                |> within
                                    [ getRightSidebarChildViews model
                                        |> RSidebar.view model
                                    ]
                            , StrategiesModal.view model
                            ]
                    ]

        Failed err ->
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


getRightSidebarChildViews : Model -> (String, List (Element MainStyles Variations Msg))
getRightSidebarChildViews model =
    case model.zoneOfImpact of
        Just zoi ->
            ("ZONE OF IMPACT", [ ZOI.view model.trianglePath model.zoiPath zoi ])

        Nothing ->
            ("", [ el NoStyle [] empty ])



---- SUBSCRIPTIONS ----


subscriptions : App -> Sub Msg
subscriptions app =
    case app of
        Loaded model ->
            Sub.batch
                [ Animation.subscription Animate (animations model)
                , Window.resizes Resize
                , olSub decodeOpenLayersSub
                ]

        Failed err ->
            Sub.none


animations : Model -> List Animation.State
animations model =
    [ model.rightSidebarFx, model.rightSidebarToggleFx ]



---- PROGRAM ----


main : Program D.Value App Msg
main =
    Navigation.programWithFlags UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
