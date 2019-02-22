module Main exposing (..)

import Navigation
import Element.Events exposing (onClick)
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
import Keyboard.Key exposing (Key(Up, Down, Left, Right, Enter, Escape))
import Types exposing (..)
import AdaptationStrategy.AdaptationInfo as Info exposing (AdaptationInfo)
import AdaptationStrategy.CoastalHazards as Hazards exposing (CoastalHazards, CoastalHazard)
import AdaptationStrategy.Strategies as Strategies exposing (Strategies, Strategy)
import AdaptationOutput as Output exposing (AdaptationOutput(..), OutputError(..))
import AdaptationMath as Maths
import AdaptationHexes as AH
import ShorelineLocation as SL exposing (..)
import Message exposing (..)
import Request exposing (..)
import Routes exposing (Route(..), parseRoute)
import View.Dropdown as Dropdown exposing (Dropdown)
import View.BaselineInfo as BaselineInfo exposing (..)
import View.RightSidebar as RSidebar
import View.LeftSidebar as LSidebar
import View.ZoneOfImpact as ZOI
import View.PlanningLayers as PL
import View.StrategyResults as Results
import View.StrategiesModal as StrategiesModal
import View.Helpers exposing (..)
import Styles exposing (..)
import ChipApi.Scalar as Scalar
import Ports exposing (..)
import View.Tray as Tray


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
    , adaptationInfo : GqlData AdaptationInfo
    , strategiesModalOpenness : Openness
    , shorelineLocations : GqlData ShorelineExtents
    , shorelineLocationsDropdown : Dropdown ShorelineExtent
    , baselineInformation : BaselineInformation
    , baselineModal : GqlData (Maybe BaselineInfo)
    , zoneOfImpact : Maybe ZoneOfImpact
    , adaptationHexes : WebData AH.AdaptationHexes
    , calculationOutput : Maybe (Result OutputError AdaptationOutput)
    , rightSidebarOpenness : Openness
    , rightSidebarFx : Animation.State
    , rightSidebarToggleFx : Animation.State
    , leftSidebarOpenness : Openness
    , leftSidebarFx : Animation.State
    , leftSidebarToggleFx : Animation.State
    , slrPath : String
    , wetPath : String
    , paths : Paths
    , slrOpenness : Openness
    , slrFx : Animation.State
    , slrToggleFx : Animation.State
    , infraOpenness : Openness
    , infraFx : Animation.State
    , infraToggleFx : Animation.State
    , erosionSectionOpenness : Openness
    , erosionFx : Animation.State
    , erosionToggleFx : Animation.State
    , critFacClicked : Openness
    , dr1ftClicked : Openness
    , slr2ftClicked : Openness
    , mopClicked : Openness
    , pprClicked : Openness
    , spClicked : Openness
    , cdsClicked : Openness
    , fzClicked : Openness
    , sloshClicked : Openness
    , slr1ftClicked : Openness
    , slr3ftClicked : Openness
    , slr4ftClicked : Openness
    , slr5ftClicked : Openness
    , slr6ftClicked : Openness
    , dr2ftClicked : Openness
    , dr3ftClicked : Openness
    , dr4ftClicked : Openness
    , dr5ftClicked : Openness
    , dr6ftClicked : Openness
    , structuresClicked : Openness
    , erosionOpenness : Openness
    , fourtyYearClicked : Openness
    , stiClicked : Openness
    , fzFx : Animation.State
    , fzToggleFx : Animation.State
    , sloshFx : Animation.State
    , sloshToggleFx : Animation.State
    , shorelineSelected : Openness
    , layerClicked : Openness
    , titleRibbonFX : Animation.State
    , outputDetails : AdaptationOutput
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
        -- Adaptation Info (Categories, Hazards, Strategies)
        Loading
        -- Adaptation Strategy Modal Openness
        Closed
        -- Shoreline Location + Menu
        Loading
        { menu = Input.dropMenu Nothing SelectLocationInput
        , isOpen = False
        , name = "Shoreline Location"
        }
        -- Baseline Information
        Dict.empty
        -- Baseline Modal
        NotAsked
        -- Zone of Impact data
        Nothing
        -- Adapation Hex data
        NotAsked
        -- Calculation Output
        Nothing
        -- right sidebar
        Closed
        (Animation.style <| .closed <| Animations.rightSidebarStates)
        (Animation.style <| .rotateNeg180 <| Animations.toggleStates)
        -- left sidebar
        Closed
        (Animation.style <| .closed <| Animations.leftSidebarStates)
        (Animation.style <| .rotateZero <| Animations.toggleStates)
        -- slr image
        flags.slrPath
        -- wetlands image
        flags.wetPath
        -- paths object
        flags.paths
        -- SLR Section
        Closed
        (Animation.style <| .closed <| Animations.slrStates)
        (Animation.style <| .rotate180 <| Animations.toggleStates)
        -- Infrastructure Section
        Closed
        (Animation.style <| .closed <| Animations.infraStates)
        (Animation.style <| .rotate180 <| Animations.toggleStates)
        -- Erosion Section
        Closed
        (Animation.style <| .closed <| Animations.erosionStates)
        (Animation.style <| .rotate180 <| Animations.toggleStates)
        -- Critical Facilities Layer clicked
        Closed
        -- Discon Roads 1ft clicked
        Closed
        -- SLR 2ft clicked
        Closed
        -- Muni properties clicked
        Closed
        -- Public/private roads clicked
        Closed
        -- Sewered parcels clicked
        Closed
        -- Coastal defense structures clicked
        Closed
        -- Flood zone clicked
        Closed
        -- Slosh clicked
        Closed
        -- SLR 1ft clicked
        Closed
        -- SLR 3ft clicked
        Closed
        -- SLR 4ft clicked
        Closed
        -- SLR 5ft clicked
        Closed
        -- SLR 6ft clicked
        Closed
        -- Discon roads 2ft clicked
        Closed
        -- Discon roads 3ft clicked
        Closed
        -- Discon roads 4ft clicked
        Closed
        -- Discon roads 5ft clicked
        Closed
        -- Discon roads 6ft clicked
        Closed
        -- Structures clicked
        Closed
        -- Erosion clicked
        Closed
        -- 40-yr erosion layer clicked
        Closed
        -- Sediment transport clicked
        Closed
        -- Flood zone legend fx
        (Animation.style <| .closed <| Animations.fzStates)
        -- Flood zone legend button toggle fx
        (Animation.style <| .rotate180 <| Animations.toggleStates)
        -- Slosh legend fx
        (Animation.style <| .closed <| Animations.sloshStates)
        -- Slosh legend button toggle fx
        (Animation.style <| .rotate180 <| Animations.toggleStates)
        -- Shoreline Dropdown item selected
        Closed
        -- Any layer activated
        Closed
        -- Title Ribbon activated
        (Animation.style <| .closed <| Animations.titleStates)
        -- AdaptationOutput
        NotCalculated

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
                        [ getAdaptationInfo
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

        GotAdaptationInfo response ->
            ( { model | adaptationInfo = response }, Cmd.none )

                              
        GotShorelineExtents response ->
            response
                |> transformLocationsResponse
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
                                                [ olCmd <| encodeOpenLayersCmd (ZoomToShorelineLocation selection)
                                                , sendGetVulnRibbonRequest model.env selection
                                                ]
                                        else
                                            Cmd.none
                                in
                                ( nl, Cmd.batch [ nc1, nc2 ] )
                            )
                        |> Maybe.withDefault ( model.shorelineLocations, Cmd.none )
            in
                ( model
                    |> collapseRightSidebar
                    |> collapseLeftSidebar
                    |> \m ->
                        { m
                            | shorelineLocationsDropdown = updatedLocationsDropdown 
                            , shorelineLocations = newLocations
                            , zoneOfImpact = Nothing
                            , calculationOutput = Nothing
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
                        ( model
                            |> collapseRightSidebar
                            |> \m -> 
                                { m 
                                    | shorelineLocationsDropdown = updatedLocationsDropdown
                                    , zoneOfImpact = Nothing
                                    , calculationOutput = Nothing
                                }
                        , Cmd.batch
                            [ olCmd <| encodeOpenLayersCmd (ZoomToShorelineLocation selection)
                            , sendGetVulnRibbonRequest model.env selection
                            ]
                        )

                Nothing ->
                    ( model, Cmd.none )

        LoadVulnerabilityRibbonResponse response ->
            ( model
                |> \m ->
                    { m 
                        | shorelineSelected = Open
                        , titleRibbonFX =
                            Animation.interrupt
                                [ Animation.to <| .open <| Animations.titleStates ]
                                model.titleRibbonFX
                    }
            , olCmd <| encodeOpenLayersCmd (RenderVulnerabilityRibbon response)
            )

        GotHexesResponse response ->
            let
                newModel = { model | adaptationHexes = response }
            in
            ( { newModel | calculationOutput = Just <| runCalculations newModel }
            , Cmd.none
            )

        UpdateZoneOfImpact zoi ->
            ( model
                |> expandRightSidebar
                |> \m -> 
                    { m 
                        | zoneOfImpact = Just zoi 
                        , calculationOutput = Nothing
                    }
            , Cmd.none
            )

        CancelZoneOfImpactSelection ->
            ( model
                |> collapseRightSidebar
                |> \m -> 
                    { m 
                        | zoneOfImpact = Nothing
                        , calculationOutput = Nothing
                        , adaptationHexes = NotAsked
                    }
            , olCmd <| encodeOpenLayersCmd ClearZoneOfImpact
            )

        PickStrategy ->
            case model.adaptationInfo of
                NotAsked ->
                    ( model
                        |> collapseRightSidebar
                        |> collapseLeftSidebar
                        |> \m -> { m | adaptationInfo = Loading, strategiesModalOpenness = Open }
                    , getAdaptationInfo
                    )

                Loading ->
                    ( model
                        |> collapseRightSidebar
                        |> collapseLeftSidebar
                        |> \m -> { m | strategiesModalOpenness = Open }
                    , Cmd.none
                    )

                Success info ->
                    let
                        cmds =
                            model.adaptationInfo
                                |> Remote.toMaybe
                                |> Maybe.map changeStrategyCmds
                                |> Maybe.withDefault Cmd.none
                    in
                        ( model
                            |> collapseRightSidebar
                            |> collapseLeftSidebar
                            |> \m -> { m | strategiesModalOpenness = Open }
                        , cmds
                        )

                Failure err ->
                    ( model
                        |> collapseRightSidebar
                        |> collapseLeftSidebar
                        |> \m -> 
                            { m | strategiesModalOpenness = Open }
                    , Cmd.none
                    )


        CancelPickStrategy ->
            ( model
                |> expandRightSidebar
                |> \m -> 
                    { m 
                        | strategiesModalOpenness = Closed
                        , calculationOutput = Nothing
                    }
            , Cmd.none
            )

        SelectPreviousHazard ->
            model.adaptationInfo
                |> updateHazardsWith ZipHelp.tryPreviousOrLast
                |> \(info, cmd) ->
                    ( { model | adaptationInfo = info }, cmd )

        SelectNextHazard ->
            model.adaptationInfo
                |> updateHazardsWith ZipHelp.tryNextOrFirst
                |> \(info, cmd) ->
                    ( { model | adaptationInfo = info }, cmd )

        SelectStrategy id ->
            model.adaptationInfo
                |> updateHazardsWith
                    (Hazards.updateStrategyIds 
                        (ZipHelp.tryFindFirst <| ZipHelp.matches id)
                    )
                |> \(info, cmd) ->
                    ( { model | adaptationInfo = info }, cmd )
            
        HandleStrategyKeyboardEvent evt ->
            case evt.keyCode of
                Down ->
                    model.adaptationInfo
                        |> updateHazardsWith (selectNextStrategy model)
                        |> \(info, cmd) ->
                            ( { model | adaptationInfo = info }, cmd )

                Up ->
                    model.adaptationInfo
                        |> updateHazardsWith (selectPreviousStrategy model)
                        |> \(info, cmd) ->
                            ( { model | adaptationInfo = info }, cmd )

                Left ->
                    model.adaptationInfo
                        |> updateHazardsWith ZipHelp.tryPreviousOrLast
                        |> \(info, cmd) ->
                            ( {model | adaptationInfo = info }, cmd )

                Right ->
                    model.adaptationInfo
                        |> updateHazardsWith ZipHelp.tryNextOrFirst
                        |> \(info, cmd) ->
                            ( { model | adaptationInfo = info }, cmd )

                Enter ->
                    applyStrategy model

                Escape ->
                    ( model
                        |> expandRightSidebar
                        |> \m -> { m | strategiesModalOpenness = Closed }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        GotStrategyDetails id response ->
            model.adaptationInfo
                |> Remote.update
                    (\info ->
                        info.strategies
                            |> Strategies.updateStrategyDetails id response
                            |> \newStrategies -> ( { info | strategies = newStrategies }, Cmd.none )
                    )
                |> \(info, cmd) -> 
                    ( { model | adaptationInfo = info }, cmd )

        ApplyStrategy appliedStrategy maybeEvt ->
            maybeEvt
                |> Maybe.map
                    (\{ keyCode } ->
                        case keyCode of
                            Enter ->
                                applyStrategy model

                            Escape ->
                                ( model
                                    |> expandRightSidebar
                                    |> \m -> { m | strategiesModalOpenness = Closed }
                                , Cmd.none
                                )

                            _ ->
                                ( model, Cmd.none )
                    )
                |> Maybe.withDefault (applyStrategy model)

        ShowStrategyOutput ( noActionOutput, strategyOutput ) ->
            ( { model | calculationOutput = Just ( Ok <| ShowStrategy noActionOutput strategyOutput ) }
            , Cmd.none
            )

        ShowNoActionOutput ( noActionOutput, strategyOutput ) ->
            ( { model | calculationOutput = Just ( Ok <| ShowNoAction noActionOutput strategyOutput ) }
            , Cmd.none
            )

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
                , leftSidebarFx = Animation.update animMsg model.leftSidebarFx
                , leftSidebarToggleFx = Animation.update animMsg model.leftSidebarToggleFx
                , slrFx = Animation.update animMsg model.slrFx
                , slrToggleFx = Animation.update animMsg model.slrToggleFx
                , infraFx = Animation.update animMsg model.infraFx
                , infraToggleFx = Animation.update animMsg model.infraToggleFx
                , erosionFx = Animation.update animMsg model.erosionFx
                , erosionToggleFx = Animation.update animMsg model.erosionToggleFx
                , fzFx = Animation.update animMsg model.fzFx
                , fzToggleFx = Animation.update animMsg model.fzToggleFx
                , sloshFx = Animation.update animMsg model.sloshFx
                , sloshToggleFx = Animation.update animMsg model.sloshToggleFx
                , titleRibbonFX = Animation.update animMsg model.titleRibbonFX
            }
            , Cmd.none
            )

        Resize size ->
            ( { model | device = classifyDevice size }
            , Cmd.none
            )

        ToggleLeftSidebar ->
            case model.leftSidebarOpenness of
                Open ->
                    ( model |> collapseLeftSidebar, Cmd.none )

                Closed ->
                    ( model |> expandLeftSidebar, Cmd.none )

        ToggleCritFac ->
            case model.critFacClicked of 
                Open ->
                    ( model 
                        |> \m -> 
                            { m 
                                | critFacClicked = Closed 
                            }
                    , olCmd <| encodeOpenLayersCmd (DisableCritFac) 
                    )
                Closed ->
                    ( model 
                        |> \m -> 
                            { m 
                                | critFacClicked = Open 
                                , layerClicked = Open
                            }
                    , olCmd <| encodeOpenLayersCmd (RenderCritFac) 
                    )

        ToggleDR level ->
            case level of 
                "1" ->
                    case model.dr1ftClicked of 
                        Open ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | dr1ftClicked = Closed 
                                    }
                            , olCmd <| encodeOpenLayersCmd (DisableDR level) 
                            )
                        Closed ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | dr1ftClicked = Open 
                                    }
                            , olCmd <| encodeOpenLayersCmd (RenderDR level) 
                            )
                "2" ->
                    case model.dr2ftClicked of 
                        Open ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | dr2ftClicked = Closed 
                                    }
                            , olCmd <| encodeOpenLayersCmd (DisableDR level) 
                            )
                        Closed ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | dr2ftClicked = Open 
                                    }
                            , olCmd <| encodeOpenLayersCmd (RenderDR level) 
                            )

                "3" ->
                    case model.dr3ftClicked of 
                        Open ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | dr3ftClicked = Closed 
                                    }
                            , olCmd <| encodeOpenLayersCmd (DisableDR level) 
                            )
                        Closed ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | dr3ftClicked = Open 
                                    }
                            , olCmd <| encodeOpenLayersCmd (RenderDR level) 
                            )

                "4" ->
                    case model.dr4ftClicked of 
                        Open ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | dr4ftClicked = Closed 
                                    }
                            , olCmd <| encodeOpenLayersCmd (DisableDR level) 
                            )
                        Closed ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | dr4ftClicked = Open 
                                    }
                            , olCmd <| encodeOpenLayersCmd (RenderDR level) 
                            )

                "5" ->
                    case model.dr5ftClicked of 
                        Open ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | dr5ftClicked = Closed 
                                    }
                            , olCmd <| encodeOpenLayersCmd (DisableDR level) 
                            )
                        Closed ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | dr5ftClicked = Open 
                                    }
                            , olCmd <| encodeOpenLayersCmd (RenderDR level) 
                            )

                "6" ->
                    case model.dr6ftClicked of 
                        Open ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | dr6ftClicked = Closed 
                                    }
                            , olCmd <| encodeOpenLayersCmd (DisableDR level) 
                            )
                        Closed ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | dr6ftClicked = Open 
                                    }
                            , olCmd <| encodeOpenLayersCmd (RenderDR level) 
                            )
                
                _ ->
                    (model, Cmd.none)

        ToggleSLRLayer level ->
            case level of 
                "1" -> 
                    case model.slr1ftClicked of 
                        Open ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | slr1ftClicked = Closed 
                                        , dr1ftClicked = Closed
                                    }
                            , olCmd <| encodeOpenLayersCmd (DisableSLR level) 
                            )
                        Closed ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | slr1ftClicked = Open  
                                        , dr1ftClicked = Open
                                        , layerClicked = Open
                                        , slr2ftClicked = Closed
                                        , slr3ftClicked = Closed
                                        , slr4ftClicked = Closed
                                        , slr5ftClicked = Closed
                                        , slr6ftClicked = Closed
                                        , dr2ftClicked = Closed
                                        , dr3ftClicked = Closed
                                        , dr4ftClicked = Closed
                                        , dr5ftClicked = Closed
                                        , dr6ftClicked = Closed
                                    }
                            , olCmd <| encodeOpenLayersCmd (RenderSLR level) 
                            )
                "2" -> 
                    case model.slr2ftClicked of 
                        Open ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | slr2ftClicked = Closed 
                                        , dr2ftClicked = Closed
                                    }
                            , olCmd <| encodeOpenLayersCmd (DisableSLR level) 
                            )
                        Closed ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | slr2ftClicked = Open 
                                        , dr2ftClicked = Open
                                        , layerClicked = Open
                                        , slr1ftClicked = Closed
                                        , slr3ftClicked = Closed
                                        , slr4ftClicked = Closed
                                        , slr5ftClicked = Closed
                                        , slr6ftClicked = Closed
                                        , dr1ftClicked = Closed
                                        , dr3ftClicked = Closed
                                        , dr4ftClicked = Closed
                                        , dr5ftClicked = Closed
                                        , dr6ftClicked = Closed
                                    }
                            , olCmd <| encodeOpenLayersCmd (RenderSLR level) 
                            )

                "3" -> 
                    case model.slr3ftClicked of 
                        Open ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | slr3ftClicked = Closed 
                                        , dr3ftClicked = Closed
                                    }
                            , olCmd <| encodeOpenLayersCmd (DisableSLR level) 
                            )
                        Closed ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | slr3ftClicked = Open 
                                        , dr3ftClicked = Open
                                        , layerClicked = Open
                                        , slr1ftClicked = Closed
                                        , slr2ftClicked = Closed
                                        , slr4ftClicked = Closed
                                        , slr5ftClicked = Closed
                                        , slr6ftClicked = Closed
                                        , dr1ftClicked = Closed
                                        , dr2ftClicked = Closed
                                        , dr4ftClicked = Closed
                                        , dr5ftClicked = Closed
                                        , dr6ftClicked = Closed
                                    }
                            , olCmd <| encodeOpenLayersCmd (RenderSLR level) 
                            )

                "4" -> 
                    case model.slr4ftClicked of 
                        Open ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | slr4ftClicked = Closed 
                                        , dr4ftClicked = Closed
                                    }
                            , olCmd <| encodeOpenLayersCmd (DisableSLR level) 
                            )
                        Closed ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | slr4ftClicked = Open 
                                        , dr4ftClicked = Open
                                        , layerClicked = Open
                                        , slr1ftClicked = Closed
                                        , slr2ftClicked = Closed
                                        , slr3ftClicked = Closed
                                        , slr5ftClicked = Closed
                                        , slr6ftClicked = Closed
                                        , dr1ftClicked = Closed
                                        , dr2ftClicked = Closed
                                        , dr3ftClicked = Closed
                                        , dr5ftClicked = Closed
                                        , dr6ftClicked = Closed
                                    }
                            , olCmd <| encodeOpenLayersCmd (RenderSLR level) 
                            )

                "5" -> 
                    case model.slr5ftClicked of 
                        Open ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | slr5ftClicked = Closed 
                                        , dr5ftClicked = Closed
                                    }
                            , olCmd <| encodeOpenLayersCmd (DisableSLR level) 
                            )
                        Closed ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | slr5ftClicked = Open 
                                        , dr5ftClicked = Open
                                        , layerClicked = Open
                                        , slr1ftClicked = Closed
                                        , slr2ftClicked = Closed
                                        , slr3ftClicked = Closed
                                        , slr4ftClicked = Closed
                                        , slr6ftClicked = Closed
                                        , dr1ftClicked = Closed
                                        , dr2ftClicked = Closed
                                        , dr3ftClicked = Closed
                                        , dr4ftClicked = Closed
                                        , dr6ftClicked = Closed
                                    }
                            , olCmd <| encodeOpenLayersCmd (RenderSLR level) 
                            )

                "6" -> 
                    case model.slr6ftClicked of 
                        Open ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | slr6ftClicked = Closed 
                                        , dr6ftClicked = Closed
                                    }
                            , olCmd <| encodeOpenLayersCmd (DisableSLR level) 
                            )
                        Closed ->
                            ( model 
                                |> \m -> 
                                    { m 
                                        | slr6ftClicked = Open 
                                        , dr6ftClicked = Open
                                        , layerClicked = Open
                                        , slr1ftClicked = Closed
                                        , slr2ftClicked = Closed
                                        , slr3ftClicked = Closed
                                        , slr4ftClicked = Closed
                                        , slr5ftClicked = Closed
                                        , dr1ftClicked = Closed
                                        , dr2ftClicked = Closed
                                        , dr3ftClicked = Closed
                                        , dr4ftClicked = Closed
                                        , dr5ftClicked = Closed
                                    }
                            , olCmd <| encodeOpenLayersCmd (RenderSLR level) 
                            )
                _ ->
                    (model, Cmd.none)

        LoadCritFacResponse response ->
            ( model
            , olCmd <| encodeOpenLayersCmd (RenderCritFac)
            )

        -- LoadDRResponse response ->
        --     ( model
        --     , olCmd <| encodeOpenLayersCmd (RenderDR)
        --     )

        -- LoadSLRResponse response ->
        --     ( model
        --     , olCmd <| encodeOpenLayersCmd (RenderSLR)
        --     )

        LoadMOPResponse response ->
            ( model
            , olCmd <| encodeOpenLayersCmd (RenderMOP)
            )

        ToggleSLRSection ->
            case model.slrOpenness of
                Open ->
                    ( model |> collapseSLRLayer, Cmd.none )

                Closed ->
                    ( model |> expandSLRLayer, Cmd.none )

        ToggleInfraSection ->
            case model.infraOpenness of
                Open ->
                    ( model |> collapseInfraLayer, Cmd.none )

                Closed ->
                    ( model |> expandInfraLayer, Cmd.none )

        ToggleErosionSection ->
            case model.erosionSectionOpenness of
                Open ->
                    ( model |> collapseErosionSection, Cmd.none )

                Closed ->
                    ( model |> expandErosionSection, Cmd.none )

        ToggleMOPLayer ->
            case model.mopClicked of 
                Open ->
                    ( model 
                        |> \m -> 
                            { m 
                                | mopClicked = Closed 
                            }
                    , olCmd <| encodeOpenLayersCmd (DisableMOP) 
                    )
                Closed ->
                    ( model 
                        |> \m -> 
                            { m 
                                | mopClicked = Open 
                                , layerClicked = Open
                            }
                    , olCmd <| encodeOpenLayersCmd (RenderMOP) 
                    )

        TogglePPRLayer ->
            case model.pprClicked of 
                Open ->
                    ( model 
                        |> \m -> 
                            { m 
                                | pprClicked = Closed 
                            }
                    , olCmd <| encodeOpenLayersCmd (DisablePPR) 
                    )
                Closed ->
                    ( model 
                        |> \m -> 
                            { m 
                                | pprClicked = Open 
                                , layerClicked = Open
                            }
                    , olCmd <| encodeOpenLayersCmd (RenderPPR) 
                    )

        ToggleSPLayer ->
            case model.spClicked of 
                Open ->
                    ( model 
                        |> \m -> 
                            { m 
                                | spClicked = Closed 
                            }
                    , olCmd <| encodeOpenLayersCmd (DisableSP) 
                    )
                Closed ->
                    ( model 
                        |> \m -> 
                            { m 
                                | spClicked = Open 
                                , layerClicked = Open
                            }
                    , olCmd <| encodeOpenLayersCmd (RenderSP) 
                    )

        ToggleCDSLayer ->
            case model.cdsClicked of 
                Open ->
                    ( model 
                        |> \m -> 
                            { m 
                                | cdsClicked = Closed 
                            }
                    , olCmd <| encodeOpenLayersCmd (DisableCDS) 
                    )
                Closed ->
                    ( model 
                        |> \m -> 
                            { m 
                                | cdsClicked = Open 
                                , layerClicked = Open
                            }
                    , olCmd <| encodeOpenLayersCmd (RenderCDS) 
                    )

        ToggleFZLayer ->
            case model.fzClicked of 
                Open ->
                    ( model 
                        |> collapseFZSection 
                    , olCmd <| encodeOpenLayersCmd (DisableFZ) 
                    )
                Closed ->
                    ( model 
                        |> expandFZSection
                        |> \m ->
                            { m
                                | layerClicked = Open
                            }
                    , olCmd <| encodeOpenLayersCmd (RenderFZ) 
                    )

        ToggleSloshLayer ->
            case model.sloshClicked of 
                Open ->
                    ( model |> collapseSloshSection
                    , olCmd <| encodeOpenLayersCmd (DisableSlosh) 
                    )
                Closed ->
                    ( model 
                        |> expandSloshSection
                        |> \m ->
                            { m
                                | layerClicked = Open
                            }
                    , olCmd <| encodeOpenLayersCmd (RenderSlosh) 
                    )

        ToggleFourtyYearLayer ->
            case model.fourtyYearClicked of 
                Open ->
                    ( model 
                        |> \m -> 
                            { m 
                                | fourtyYearClicked = Closed 
                            }
                    , olCmd <| encodeOpenLayersCmd (DisableFourtyYears) 
                    )
                Closed ->
                    ( model 
                        |> \m -> 
                            { m 
                                | fourtyYearClicked = Open 
                                , layerClicked = Open
                            }
                    , olCmd <| encodeOpenLayersCmd (RenderFourtyYears) 
                    )

        ToggleSTILayer ->
            case model.stiClicked of 
                Open ->
                    ( model 
                        |> \m -> 
                            { m 
                                | stiClicked = Closed 
                            }
                    , olCmd <| encodeOpenLayersCmd (DisableSTI) 
                    )
                Closed ->
                    ( model 
                        |> \m -> 
                            { m 
                                | stiClicked = Open 
                                , layerClicked = Open
                            }
                    , olCmd <| encodeOpenLayersCmd (RenderSTI) 
                    )

        ToggleStructuresLayer ->
            case model.structuresClicked of 
                Open ->
                    ( model 
                        |> \m -> 
                            { m 
                                | structuresClicked = Closed 
                            }
                    , olCmd <| encodeOpenLayersCmd (DisableStructures) 
                    )
                Closed ->
                    ( model 
                        |> \m -> 
                            { m 
                                | structuresClicked = Open 
                                , layerClicked = Open
                            }
                    , olCmd <| encodeOpenLayersCmd (RenderStructures) 
                    )


        ClearAllLayers ->
            ( model 
                |> \m -> 
                    { m 
                        | layerClicked = Closed 
                        , stiClicked = Closed 
                        , fourtyYearClicked = Closed
                        , sloshClicked = Closed
                        , fzClicked = Closed
                        , cdsClicked = Closed
                        , spClicked = Closed
                        , pprClicked = Closed
                        , mopClicked = Closed
                        , slr6ftClicked = Closed 
                        , dr6ftClicked = Closed
                        , slr5ftClicked = Closed 
                        , dr5ftClicked = Closed
                        , slr4ftClicked = Closed 
                        , dr4ftClicked = Closed
                        , slr3ftClicked = Closed 
                        , dr3ftClicked = Closed
                        , slr2ftClicked = Closed 
                        , dr2ftClicked = Closed
                        , slr1ftClicked = Closed 
                        , dr1ftClicked = Closed
                        , critFacClicked = Closed
                        , structuresClicked = Closed 
                    }
            , olCmd <| encodeOpenLayersCmd (ClearLayers)
            )

        ResetAll ->
            ( model 
                |> \m -> 
                    { m 
                        | shorelineSelected = Closed
                        , shorelineLocationsDropdown = 
                            { menu = Input.dropMenu Nothing SelectLocationInput
                            , isOpen = False
                            , name = "Shoreline Location"
                            }
                        , layerClicked = Closed 
                        , stiClicked = Closed 
                        , fourtyYearClicked = Closed
                        , sloshClicked = Closed
                        , fzClicked = Closed
                        , cdsClicked = Closed
                        , spClicked = Closed
                        , pprClicked = Closed
                        , mopClicked = Closed
                        , slr6ftClicked = Closed 
                        , dr6ftClicked = Closed
                        , slr5ftClicked = Closed 
                        , dr5ftClicked = Closed
                        , slr4ftClicked = Closed 
                        , dr4ftClicked = Closed
                        , slr3ftClicked = Closed 
                        , dr3ftClicked = Closed
                        , slr2ftClicked = Closed 
                        , dr2ftClicked = Closed
                        , slr1ftClicked = Closed 
                        , dr1ftClicked = Closed
                        , critFacClicked = Closed
                        , structuresClicked = Closed 
                        , strategiesModalOpenness = Closed
                        , calculationOutput = Nothing
                        , zoneOfImpact = Nothing
                        , calculationOutput = Nothing
                        , adaptationHexes = NotAsked
                        , titleRibbonFX =
                            Animation.interrupt
                                [ Animation.to <| .closed <| Animations.titleStates ]
                                model.titleRibbonFX
                    }
            , olCmd <| encodeOpenLayersCmd (ResetAllOL)
            )

        ZoomIn -> 
            ( model
            , olCmd <| encodeOpenLayersCmd (ZoomInOL) 
            )

        ZoomOut -> 
            ( model
            , olCmd <| encodeOpenLayersCmd (ZoomOutOL) 
            )

        GetLocation -> 
            ( model
            , olCmd <| encodeOpenLayersCmd (GetLocOL) 
            )


        


applyStrategy : Model -> ( Model, Cmd Msg )
applyStrategy model =
    case Remote.isSuccess model.adaptationHexes of
        True ->
            let
                output = runCalculations model
            in
            ( model
                |> expandRightSidebar
                |> \m -> 
                    { m 
                        | strategiesModalOpenness = Closed
                        , calculationOutput = Just output 
                    }
            , Cmd.none 
            )
        False ->
            ( model
                |> expandRightSidebar
                |> \m -> 
                    { m 
                        | strategiesModalOpenness = Closed
                        , adaptationHexes = Loading
                        , calculationOutput = Just <| Ok CalculatingOutput
                    }
            , sendGetHexesRequest model.env model.zoneOfImpact 
            )


runCalculations : Model -> Result OutputError AdaptationOutput
runCalculations model =
    let
        location = 
            Input.selected model.shorelineLocationsDropdown.menu

        currentHazard = 
            model.adaptationInfo
                |> Remote.toMaybe
                |> Info.currentHazard

        noActionStrategyWithDetails = 
            model.adaptationInfo
                |> Remote.toMaybe
                |> Info.noActionStrategyWithDetails

        currentStrategyWithDetails =
            model.adaptationInfo
                |> Remote.toMaybe
                |> Info.currentStrategyWithDetails
    in
    Maybe.map5 (Maths.calculate model.adaptationHexes)
        location 
        model.zoneOfImpact 
        currentHazard 
        noActionStrategyWithDetails 
        currentStrategyWithDetails
        |> Maybe.withDefault (Err <| BadInput "Cannot calculate output with missing input data.")

    


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


updateHazardsWith : 
    (CoastalHazards -> CoastalHazards) 
    -> GqlData AdaptationInfo 
    -> ( GqlData AdaptationInfo, Cmd Msg )
updateHazardsWith zipMapFn info =
    Remote.update
        (\info ->
            let
                newHazards = zipMapFn info.hazards

                newInfo = { info | hazards = newHazards }
            in
            ( newInfo, changeStrategyCmds newInfo )
        )
        info


selectNextStrategy : Model -> CoastalHazards -> CoastalHazards
selectNextStrategy { adaptationInfo, zoneOfImpact } =
    adaptationInfo
        |> Info.isStrategyApplicableToZoneOfImpact zoneOfImpact
        |> ZipHelp.tryNextUntil
        |> Hazards.updateStrategyIds


selectPreviousStrategy : Model -> CoastalHazards -> CoastalHazards
selectPreviousStrategy { adaptationInfo, zoneOfImpact } =
    adaptationInfo
        |> Info.isStrategyApplicableToZoneOfImpact zoneOfImpact
        |> ZipHelp.tryPreviousUntil
        |> Hazards.updateStrategyIds



changeStrategyCmds : AdaptationInfo -> Cmd Msg
changeStrategyCmds info =
   Cmd.batch
    [ focusStrategyCmd info
    , fetchStrategyDetailsCmd info
    ]


focusStrategyCmd : AdaptationInfo -> Cmd Msg
focusStrategyCmd info =
    info
        |> Info.getSelectedStrategyHtmlId
        |> Maybe.map focus
        |> Maybe.withDefault Cmd.none

    
fetchStrategyDetailsCmd : AdaptationInfo -> Cmd Msg
fetchStrategyDetailsCmd info =
    Just info
        |> Info.currentStrategy
        |> Maybe.map 
            (\s ->  
                s.details 
                    |> Remote.isSuccess
                    |> \isSuccess ->
                        if isSuccess then 
                            Cmd.none 
                        else 
                            getStrategyDetailsById s.id
            )
        |> Maybe.withDefault Cmd.none


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
                [ Animation.toWith (Animation.speed { perSecond = 10.0 }) <| .rotateNeg180 <| Animations.toggleStates ]
                model.rightSidebarToggleFx
    }

collapseLeftSidebar : Model -> Model
collapseLeftSidebar model =
    { model
        | leftSidebarOpenness = Closed
        , leftSidebarFx =
            Animation.interrupt
                [ Animation.to <| .closed <| Animations.leftSidebarStates ]
                model.leftSidebarFx
        , leftSidebarToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 10.0 }) <| .rotateZero <| Animations.toggleStates ]
                model.leftSidebarToggleFx
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
                [ Animation.toWith (Animation.speed { perSecond = 10.0 }) <| .rotateZero <| Animations.toggleStates ]
                model.rightSidebarToggleFx
    }

expandLeftSidebar : Model -> Model
expandLeftSidebar model =
    { model
        | leftSidebarOpenness = Open
        , leftSidebarFx =
            Animation.interrupt
                [ Animation.to <| .open <| Animations.leftSidebarStates ]
                model.leftSidebarFx
        , leftSidebarToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 10.0 }) <| .rotateNeg180 <| Animations.toggleStates ]
                model.leftSidebarToggleFx
    }

expandSLRLayer : Model -> Model
expandSLRLayer model =
    { model
        | slrOpenness = Open
        , slrFx =
            Animation.interrupt
                [ Animation.to <| .open <| Animations.slrStates ]
                model.slrFx
        , slrToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 5.0 }) <| .rotate90 <| Animations.toggleStates ]
                model.slrToggleFx
    }

collapseSLRLayer : Model -> Model
collapseSLRLayer model =
    { model
        | slrOpenness = Closed
        , slrFx =
            Animation.interrupt
                [ Animation.to <| .closed <| Animations.slrStates ]
                model.slrFx
        , slrToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 20.0 }) <| .rotate180 <| Animations.toggleStates ]
                model.slrToggleFx
    }

expandInfraLayer : Model -> Model
expandInfraLayer model =
    { model
        | infraOpenness = Open
        , infraFx =
            Animation.interrupt
                [ Animation.to <| .open <| Animations.infraStates ]
                model.infraFx
        , infraToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 5.0 }) <| .rotate90 <| Animations.toggleStates ]
                model.infraToggleFx
    }

collapseInfraLayer : Model -> Model
collapseInfraLayer model =
    { model
        | infraOpenness = Closed
        , infraFx =
            Animation.interrupt
                [ Animation.to <| .closed <| Animations.infraStates ]
                model.infraFx
        , infraToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 5.0 }) <| .rotate180 <| Animations.toggleStates ]
                model.infraToggleFx
    }

expandErosionSection : Model -> Model
expandErosionSection model =
    { model
        | erosionSectionOpenness = Open
        , erosionFx =
            Animation.interrupt
                [ Animation.to <| .open <| Animations.erosionStates ]
                model.erosionFx
        , erosionToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 5.0 }) <| .rotate90 <| Animations.toggleStates ]
                model.erosionToggleFx
    }

collapseErosionSection : Model -> Model
collapseErosionSection model =
    { model
        | erosionSectionOpenness = Closed
        , erosionFx =
            Animation.interrupt
                [ Animation.to <| .closed <| Animations.erosionStates ]
                model.erosionFx
        , erosionToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 5.0 }) <| .rotate180 <| Animations.toggleStates ]
                model.erosionToggleFx
    }

expandFZSection : Model -> Model
expandFZSection model =
    { model
        | fzClicked = Open
        , fzFx =
            Animation.interrupt
                [ Animation.to <| .open <| Animations.fzStates ]
                model.fzFx
        , fzToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 5.0 }) <| .rotate90 <| Animations.toggleStates ]
                model.fzToggleFx
    }

collapseFZSection : Model -> Model
collapseFZSection model =
    { model
        | fzClicked = Closed
        , fzFx =
            Animation.interrupt
                [ Animation.to <| .closed <| Animations.fzStates ]
                model.fzFx
        , fzToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 5.0 }) <| .rotate180 <| Animations.toggleStates ]
                model.fzToggleFx
    }

expandSloshSection : Model -> Model
expandSloshSection model =
    { model
        | sloshClicked = Open
        , sloshFx =
            Animation.interrupt
                [ Animation.to <| .open <| Animations.sloshStates ]
                model.sloshFx
        , sloshToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 5.0 }) <| .rotate90 <| Animations.toggleStates ]
                model.sloshToggleFx
    }

collapseSloshSection : Model -> Model
collapseSloshSection model =
    { model
        | sloshClicked = Closed
        , sloshFx =
            Animation.interrupt
                [ Animation.to <| .closed <| Animations.sloshStates ]
                model.sloshFx
        , sloshToggleFx =
            Animation.interrupt
                [ Animation.toWith (Animation.speed { perSecond = 5.0 }) <| .rotate180 <| Animations.toggleStates ]
                model.sloshToggleFx
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
            Element.viewport (stylesheet model.device) <|
                column NoStyle
                    [ height (percent 100), width fill ]
                    [ headerView model
                    , mainContent MainContent [ height fill, clip ] <|
                        column NoStyle [ height fill ] <|
                            [ el NoStyle [ id "map", height (percent 100) ] empty
                                |> within
                                    [ case model.zoneOfImpact of 
                                        Just zoi -> 
                                            RSidebar.view model <| getRightSidebarChildViews model
                                        Nothing ->
                                            el NoStyle [] empty
                                    , LSidebar.view model <| getLeftSidebarChildViews model
                                    , Tray.view model
                                    ]
                                    
                                    
                            -- strategiesModalOpenness should probably be refactored away
                            -- ie: modal should never be open when zone of impact is Nothing (make impossible states impossible)
                            , case ( model.zoneOfImpact, model.strategiesModalOpenness ) of
                                ( Just zoi, Open ) ->
                                    StrategiesModal.view model model.adaptationInfo zoi model.outputDetails

                                ( _, _ ) ->
                                    el NoStyle [] empty
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
    header (Header HeaderBackground) [ width fill, height (px <| adjustOnHeight ( 60, 80 ) device) ] <|
        row NoStyle [ height fill, width fill, paddingXY 54 0, spacingXY 54 0 ] <|
            [ column NoStyle
                [ verticalCenter, width fill ]
                [ h1 (Header HeaderTitle) [] <| Element.text "Cape Cod Coastal Planner" ]
            , column NoStyle
                [ verticalCenter, width fill ]
                [ row NoStyle
                    [ width fill, spacingXY 16 0, alignRight ]
                    [ el NoStyle [] <| Dropdown.view model.shorelineLocationsDropdown model.shorelineLocations
                    , case model.shorelineSelected of 
                        Open ->
                            BaselineInfo.view model
                        Closed ->
                            el NoStyle [] empty
                    , case model.shorelineSelected of
                        Open ->
                            button (Baseline BaselineInfoBtn)
                                [ height (px 42), width (px 42), title "Reset Scenario", onClick ResetAll ]
                                (Element.text "⟲")
                        Closed ->
                            el NoStyle [] empty
                    ]
                ]
            ]


getRightSidebarChildViews : Model -> (String, List (Element MainStyles Variations Msg))
getRightSidebarChildViews model =
    case model.zoneOfImpact of
        Just zoi ->
            model.calculationOutput
                |> Maybe.map 
                    (\output -> ( "STRATEGY OUTPUT", [ Results.view output ] ))
                |> Maybe.withDefault 
                    ("ZONE OF IMPACT"
                    , [ ZOI.view model.device model.zoiPath zoi ]
                    )

        Nothing ->
            ("", [ el NoStyle [] empty ])

getLeftSidebarChildViews : Model -> (String, List (Element MainStyles Variations Msg))
getLeftSidebarChildViews model =
    ("PLANNING LAYERS", [ PL.view model model.device model.paths ])


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
    [ model.rightSidebarFx
    , model.rightSidebarToggleFx
    , model.leftSidebarFx
    , model.leftSidebarToggleFx 
    , model.slrFx
    , model.slrToggleFx
    , model.infraFx
    , model.infraToggleFx
    , model.erosionFx
    , model.erosionToggleFx
    , model.fzFx
    , model.fzToggleFx
    , model.sloshFx
    , model.sloshToggleFx
    , model.titleRibbonFX
    ]
    



---- PROGRAM ----


main : Program D.Value App Msg
main =
    Navigation.programWithFlags UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
