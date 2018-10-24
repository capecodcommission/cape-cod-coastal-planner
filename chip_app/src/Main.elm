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
import ZipperHelpers as ZipHelp
import Keyboard.Key exposing (Key(Up, Down, Left, Right, Enter, Escape))
import Types exposing (..)
import AdaptationStrategy as AS exposing (..)
import AdaptationHexes as AH
import ShorelineLocation as SL exposing (..)
import AdaptationMath as Maths
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
    , adaptationInfo : GqlData AS.AdaptationInfo
    , strategiesModalOpenness : Openness
    , shorelineLocations : GqlData ShorelineExtents
    , shorelineLocationsDropdown : Dropdown ShorelineExtent
    , baselineInformation : BaselineInformation
    , baselineModal : GqlData (Maybe BaselineInfo)
    , zoneOfImpact : Maybe ZoneOfImpact
    , adaptationHexes : WebData AH.AdaptationHexes
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

        LoadZoneOfImpactHexesResponse response ->
            ( { model | adaptationHexes = response }
            , Cmd.none
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
            case model.adaptationInfo of
                NotAsked ->
                    ( model
                        |> collapseRightSidebar
                        |> \m -> { m | adaptationInfo = Loading, strategiesModalOpenness = Open }
                    , getAdaptationInfo
                    )

                Loading ->
                    ( model
                        |> collapseRightSidebar
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
                            |> \m -> { m | strategiesModalOpenness = Open }
                        , cmds
                        )

                Failure err ->
                    ( model
                        |> collapseRightSidebar
                        |> \m -> 
                            { m | strategiesModalOpenness = Open }
                    , Cmd.none
                    )


        CloseStrategyModal ->
            ( model
                |> expandRightSidebar
                |> \m -> { m | strategiesModalOpenness = Closed }
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
                    (updateHazardStrategies 
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
                    ( model, sendGetHexesRequest model.env model.zoneOfImpact )

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
                            |> updateStrategyDetails id response
                            |> \newStrategies -> ( { info | strategies = newStrategies }, Cmd.none )
                    )
                |> \(info, cmd) -> 
                    ( { model | adaptationInfo = info }, cmd )

        ApplyStrategy maybeEvt ->
            maybeEvt
                |> Maybe.map
                    (\{ keyCode } ->
                        case keyCode of
                            Enter ->
                                ( model, sendGetHexesRequest model.env model.zoneOfImpact )

                            Escape ->
                                ( model
                                    |> expandRightSidebar
                                    |> \m -> { m | strategiesModalOpenness = Closed }
                                , Cmd.none
                                )

                            _ ->
                                ( model, Cmd.none )
                    )
                |> Maybe.withDefault ( model, sendGetHexesRequest model.env model.zoneOfImpact )

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
    (Maybe CoastalHazardZipper -> Maybe CoastalHazardZipper) 
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


selectNextStrategy : Model -> Maybe CoastalHazardZipper -> Maybe CoastalHazardZipper
selectNextStrategy { adaptationInfo, zoneOfImpact } =
    adaptationInfo
        |> canStrategyFromInfoBePlacedInZoneOfImpact zoneOfImpact
        |> ZipHelp.tryNextUntil
        |> updateHazardStrategies


selectPreviousStrategy : Model -> Maybe CoastalHazardZipper -> Maybe CoastalHazardZipper
selectPreviousStrategy { adaptationInfo, zoneOfImpact } =
    adaptationInfo
        |> canStrategyFromInfoBePlacedInZoneOfImpact zoneOfImpact
        |> ZipHelp.tryPreviousUntil
        |> updateHazardStrategies



changeStrategyCmds : AdaptationInfo -> Cmd Msg
changeStrategyCmds info =
   Cmd.batch
    [ focusStrategyCmd info.hazards
    , fetchStrategyDetailsCmd info
    ]


focusStrategyCmd : Maybe CoastalHazardZipper -> Cmd Msg
focusStrategyCmd hazards =
    hazards
        |> AS.getSelectedStrategyHtmlId
        |> Maybe.map focus
        |> Maybe.withDefault Cmd.none

    
fetchStrategyDetailsCmd : AdaptationInfo -> Cmd Msg
fetchStrategyDetailsCmd info =
    info
        |> AS.currentStrategy
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
                            -- strategiesModalOpenness should probably be refactored away
                            -- ie: modal should never be open when zone of impact is Nothing (make impossible states impossible)
                            , case ( model.zoneOfImpact, model.strategiesModalOpenness ) of
                                ( Just zoi, Open ) ->
                                    StrategiesModal.view model model.adaptationInfo zoi

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
    header (Header HeaderBackground) [ height (px <| adjustOnHeight ( 60, 80 ) device) ] <|
        row NoStyle [ height fill, paddingXY 54.0 0.0, spacingXY 54.0 0.0 ] <|
            [ column NoStyle
                [ verticalCenter ]
                [ h1 (Header HeaderTitle) [] <| Element.text "Coastal Hazard Impact Planner" ]
            , column NoStyle
                [ verticalCenter, alignRight, width fill ]
                [ row NoStyle
                    [ spacingXY 16 0 ]
                    [ Dropdown.view model.shorelineLocationsDropdown model.shorelineLocations
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
