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
import Maybe.Extra as MEx
import Dom
import Task
import List.Extra as LEx
import List.Zipper as Zipper
import ZipperHelpers as ZipHelp
import Keyboard.Key exposing (Key(Up, Down, Enter, Escape))
import Types exposing (..)
import AdaptationStrategy as AS exposing (..)
import ShorelineLocation as SL exposing (BaselineInfo, ShorelineExtent, ShorelineExtents)
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
    , categories : GqlData AS.Categories
    , benefits : GqlData AS.Benefits
    , hazards : GqlData AS.CoastalHazards
    , hazardSelections : Maybe AS.CoastalHazardZipper
    , strategies : GqlData AS.Strategies
    , strategiesByHazard : GqlData AS.StrategiesByHazard
    , strategySelections : Maybe AS.StrategyZipper
    , strategiesModalOpenness : Openness
    , shorelineLocations : GqlData ShorelineExtents
    , shorelineLocationsDropdown : Dropdown ShorelineExtent
    , baselineInformation : BaselineInformation
    , baselineModal : GqlData (Maybe BaselineInfo)
    , vulnerabilityRibbon : WebData D.Value
    , zoneOfImpact : Maybe ZoneOfImpact
    , rightSidebarOpenness : Openness
    , rightSidebarFx : Animation.State
    , rightSidebarToggleFx : Animation.State
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
        -- Adaptation Categories
        NotAsked
        -- Adaptation Benefits
        NotAsked
        -- Coastal Hazards
        NotAsked
        Nothing
        -- Adaptation Strategies
        NotAsked
        NotAsked
        Nothing
        -- Shoreline Location + Menu
        RemoteData.Loading
        { menu = Input.dropMenu Nothing SelectLocationInput
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
                        , getAdaptationCategories
                        , getAdaptationBenefits
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

        GotAdaptationCategories response ->
            response
                |> Remote.mapBoth
                    unwrapGqlList
                    (mapGqlError unwrapGqlList)
                |> \newCategories -> 
                    ({ model | adaptationCategories = newCategories }, Cmd.none )

        GotAdaptationBenefits response ->
            response
                |> Remote.mapBoth
                    unwrapGqlList
                    (mapGqlError unwrapGqlList)
                |> \newBenefits ->
                    ({ model | adaptationBenefits = newBenefits }, Cmd.none )

        GotCoastalHazards response ->
            let
                newHazards : GqlData AS.CoastalHazards
                newHazards =
                    response
                        |> Remote.mapBoth
                            (zipMapGqlList identity)
                            (mapGqlError <| zipMapGqlList identity)
                            
                updatedMenu =
                    newHazards
                        |> Remote.toMaybe
                        |> MEx.join
                        |> Maybe.map Zipper.current
                        |> \currentHazard ->
                                Input.dropMenu currentHazard SelectHazardInput

                updatedDropdown =
                    model.coastalHazardsDropdown
                        |> \l -> { l | menu = updatedMenu }
            in
                ( { model 
                    | coastalHazards = newHazards
                    , coastalHazardsDropdown = updatedDropdown
                  } 
                , Cmd.none 
                )

        SelectHazardInput msg ->
            let
                updatedMenu =
                    Input.updateSelection msg model.coastalHazardsDropdown.menu

                updatedHazardsDropdown =
                    model.coastalHazardsDropdown
                        |> \dd ->
                                case parseMenuOpeningOrClosing msg of
                                    Just val ->
                                        { dd | menu = updatedMenu, isOpen = val }

                                    Nothing ->
                                        { dd | menu = updatedMenu }

                ( newHazards, newHazardCmds ) =
                    updatedHazardsDropdown.menu
                        |> Input.selected 
                        |> Maybe.map 
                            (\{name} ->
                                Remote.update 
                                    (selectHazardByName name) 
                                    model.coastalHazards
                            )
                        |> Maybe.withDefault ( model.coastalHazards, Cmd.none )
            in
                ( { model 
                    | coastalHazardsDropdown = updatedHazardsDropdown 
                    , coastalHazards = newHazards
                  }
                , newHazardCmds
                )

        GotShorelineExtents response ->
            response
                |> Remote.mapBoth
                    (zipMapGqlList identity)
                    (mapGqlError <| zipMapGqlList identity)
                |> \newLocations ->
                    ({ model | shorelineLocations = newLocations }, Cmd.none)

        SelectLocationInput msg ->
            let
                updatedMenu =
                    Input.updateSelection msg model.shorelineLocationsDropdown.menu

                updatedLocationsDropdown =
                    model.shorelineLocationsDropdown
                        |> \dd ->
                                case parseMenuOpeningOrClosing msg of
                                    Just val ->
                                        { dd | menu = updatedMenu, isOpen = val }

                                    Nothing ->
                                        { dd | menu = updatedMenu }

                ( newLocations, newLocationsCmds ) =
                    updatedLocationsDropdown.menu
                        |> Input.selected
                        |> Maybe.map
                            (\selection ->
                                let 
                                    ( nl, nc1 ) =
                                        Remote.update
                                            (selectLocationByName selection.name)
                                            model.shorelineLocations

                                    nc2 =
                                        if shouldLocationMenuChangeTriggerZoomTo msg then
                                            Cmd.batch 
                                                [ ZoomToShorelineLocation selection
                                                    |> encodeOpenLayersCmd
                                                    |> olCmd
                                                , sendGetVulnRibbonRequest model.env selection
                                                ]
                                        else
                                            Cmd.none
                                in
                                ( nl, Cmd.batch [ nc1, nc2 ] )
                            )
                        |> Maybe.withDefault ( model.shorelineLocations, Cmd.none )
            in
                ( { model 
                    | shorelineLocationsDropdown = updatedLocationsDropdown 
                    , shorelineLocations = newLocations
                  }
                , newLocationsCmds
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
                            Input.dropMenu (Just selection) SelectLocationInput

                        updatedLocationsDropdown =
                            model.shorelineLocationsDropdown
                                |> (\l -> { l | menu = updatedMenu })
                    in
                        ( { model | shorelineLocationsDropdown = updatedLocationsDropdown }
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
            let
                ( hazardData, strategyData ) =
                    model.strategies
                        |> Maybe.map Zipper.current
                        |> Maybe.withDefault ( NotAsked, NotAsked )
            in
            case ( hazardData, strategyData ) of
                ( _, Success (Just strategies) ) ->
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

                ( _, Success (Just hazards) ) ->
                    ( model
                        |> collapseRightSidebar
                        |> \m -> { m | strategies = Loading, strategiesModalOpenness = Open }
                    , getActiveAdaptationStrategiesByHazard
                    )

        CloseStrategyModal ->
            ( model
                |> expandRightSidebar
                |> \m -> { m | strategiesModalOpenness = Closed }
            , Cmd.none
            )

        GotActiveStrategies response ->
            response
                |> Remote.mapBoth
                    (zipMapGqlList AS.newStrategy)
                    (mapGqlError <| zipMapGqlList AS.newStrategy)
                |> Remote.update selectFirstStrategy
                |> \(newStrategies, newCmd) ->
                        ( { model | strategies = newStrategies }, newCmd )
                    
        SelectStrategy id ->
            let
                ( newStrategies, newCmd ) =
                    Remote.update (selectStrategyById id) model.strategies
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
                |> ZipHelp.tryCurrent
                |> Maybe.map .id

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
                            (\s ->
                                if s.id == id then
                                    AS.updateStrategyDetails details s
                                else
                                    s
                            )
                        )
                    |> \z -> ( z, Cmd.none )
    in
    ( newStrategies, newCmd )


selectLocation : (ShorelineExtents -> ShorelineExtents) -> ShorelineExtents -> (ShorelineExtents, Cmd Msg)
selectLocation selectFn locations =
    let
        newLocations = selectFn locations

        newCmds = Cmd.none
    in
    (newLocations, newCmds)


selectLocationByName : String -> ShorelineExtents -> (ShorelineExtents, Cmd Msg)
selectLocationByName name locations =
    selectLocation (SL.findLocationByName name) locations


selectHazard : (CoastalHazards -> CoastalHazards) -> CoastalHazards -> (CoastalHazards, Cmd Msg)
selectHazard selectFn hazards =
    let
        newHazards = selectFn hazards

        newCmds = Cmd.none
    in
    (newHazards, newCmds)


selectHazardByName : String -> CoastalHazards -> (CoastalHazards, Cmd Msg)
selectHazardByName name hazards =
    selectHazard (ZipHelp.tryFindFirst <| ZipHelp.matchesName name) hazards


selectStrategy : (Strategies -> Strategies) -> Strategies -> (Strategies, Cmd Msg)
selectStrategy selectFn strategies =
    let
        selectedStrategies = selectFn strategies

        focusCmd = case AS.getSelectedStrategyHtmlId selectedStrategies of
            Just id -> focus id

            Nothing -> Cmd.none

        detailsUpdates : ( GqlData (Maybe StrategyDetails), Cmd Msg )
        detailsUpdates = 
            selectedStrategies
                |> ZipHelp.tryCurrent
                |> Maybe.andThen AS.loadDetailsFor
                |> Maybe.map 
                    (\( strategyId, details ) ->
                        case strategyId of 
                            Just id ->
                                ( details, getAdaptationStrategyDetailsById id )

                            Nothing ->
                                ( details, Cmd.none )
                    )
                |> Maybe.withDefault ( NotAsked, Cmd.none )

        newStrategies = 
            selectedStrategies
                |> Maybe.map
                    (\strats ->
                        Zipper.mapCurrent
                            (\current -> { current | details = Tuple.first detailsUpdates })
                            strats
                    )
                |> MEx.orElse selectedStrategies

        newCmds = Cmd.batch [ focusCmd, Tuple.second detailsUpdates ]
    in
    ( newStrategies, newCmds )
    

selectStrategyById : Scalar.Id -> Strategies -> (Strategies, Cmd Msg)
selectStrategyById id strategies =
    selectStrategy (ZipHelp.tryFindFirst <| ZipHelp.matchesId id) strategies


selectFirstStrategy : Strategies -> (Strategies, Cmd Msg)
selectFirstStrategy strategies =
    selectStrategy ZipHelp.tryFirst strategies


selectNextStrategy : Strategies -> (Strategies, Cmd Msg)
selectNextStrategy strategies =
    selectStrategy ZipHelp.tryNext strategies


selectPreviousStrategy : Strategies -> (Strategies, Cmd Msg)
selectPreviousStrategy strategies =
    selectStrategy ZipHelp.tryPrevious strategies


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
getCachedBaselineInfo { shorelineLocationsDropdown, baselineInformation } =
    shorelineLocationsDropdown
        |> getSelectedLocationId
        |> Maybe.andThen
            (\(Scalar.Id id) ->
                Dict.get id baselineInformation
            )


cacheBaselineInfo : Scalar.Id -> BaselineInfo -> BaselineInformation -> BaselineInformation
cacheBaselineInfo (Scalar.Id id) info dict =
    Dict.insert id info dict


getRemoteBaselineInfo : Model -> Maybe (Cmd Msg)
getRemoteBaselineInfo { shorelineLocationsDropdown } =
    shorelineLocationsDropdown
        |> getSelectedLocationId
        |> Maybe.map (\id -> getBaselineInfo id)


getSelectedLocationId : Dropdown ShorelineExtent -> Maybe Scalar.Id
getSelectedLocationId dropdown =
    dropdown.menu
        |> Input.selected
        |> Maybe.map .id


getLocationByName : String -> GqlData ShorelineExtents -> Maybe ShorelineExtent
getLocationByName name data =
    data
        |> Remote.withDefault Nothing
        |> Maybe.map Zipper.toList
        |> Maybe.andThen (LEx.find (\item -> item.name == name))


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
                            , case config.strategiesModalOpenness of
                                Closed ->
                                    el NoStyle [] empty

                                Open ->
                                    StrategiesModal.view model
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
                    [ Dropdown.view model.coastalHazardsDropdown model.coastalHazards
                    , Dropdown.view model.shorelineLocationsDropdown model.shorelineLocations
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
