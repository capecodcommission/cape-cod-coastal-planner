module Main exposing (..)

import Navigation
import Html exposing (Html)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Color exposing (..)
import Animation
import Routes exposing (Route(..), parseRoute)
import Ports exposing (..)


---- MODEL ----


type alias Model =
    { urlState : Maybe Route
    , planningLayersOpenness : Openness
    , planningLayersAnimations : Animation.State
    , drawerOpenness : Openness
    , drawerAnimations : Animation.State
    }


type Openness
    = Open
    | Closed


type alias PlanningLayersAnimations =
    { openFull : List Animation.Property
    , closedFull : List Animation.Property
    , openShort : List Animation.Property
    , closedShort : List Animation.Property
    }


planningLayersAnimations : PlanningLayersAnimations
planningLayersAnimations =
    { openFull =
        [ Animation.left (Animation.px 0.0), Animation.paddingBottom (Animation.px 0.0) ]
    , closedFull =
        [ Animation.left (Animation.px -70.0), Animation.paddingBottom (Animation.px 0.0) ]
    , openShort =
        [ Animation.left (Animation.px 0.0), Animation.paddingBottom (Animation.px 100.0) ]
    , closedShort =
        [ Animation.left (Animation.px -70.0), Animation.paddingBottom (Animation.px 100.0) ]
    }


type alias DrawerAnimations =
    { open : List Animation.Property
    , closed : List Animation.Property
    }


drawerAnimations : DrawerAnimations
drawerAnimations =
    { open =
        [ Animation.top (Animation.px 0.0) ]
    , closed =
        [ Animation.top (Animation.px 100.0) ]
    }


defaultModel : Model
defaultModel =
    Model
        (Just Blank)
        Open
        (Animation.style planningLayersAnimations.openFull)
        Closed
        (Animation.style drawerAnimations.closed)


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
        ( updatedModel
        , msgs
        )



---- UPDATE ----


type Msg
    = Noop
    | UrlChange Navigation.Location
    | TogglePlanningLayers
    | ToggleDrawer
    | Animate Animation.Msg


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

        TogglePlanningLayers ->
            case model.planningLayersOpenness of
                Open ->
                    ( collapsePlanningLayers model, Cmd.none )

                Closed ->
                    ( expandPlanningLayers model, Cmd.none )

        ToggleDrawer ->
            case model.drawerOpenness of
                Open ->
                    ( collapseDrawer model, Cmd.none )

                Closed ->
                    ( expandDrawer model, Cmd.none )

        Animate animMsg ->
            ( { model
                | planningLayersAnimations = Animation.update animMsg model.planningLayersAnimations
                , drawerAnimations = Animation.update animMsg model.drawerAnimations
              }
            , Cmd.none
            )


expandPlanningLayers : Model -> Model
expandPlanningLayers model =
    let
        animations =
            case model.drawerOpenness of
                Open ->
                    planningLayersAnimations.openShort

                Closed ->
                    planningLayersAnimations.openFull
    in
    { model
        | planningLayersOpenness = Open
        , planningLayersAnimations =
            Animation.interrupt
                [ Animation.to animations ]
                model.planningLayersAnimations
    }


collapsePlanningLayers : Model -> Model
collapsePlanningLayers model =
    let
        animations = 
            case model.drawerOpenness of
                Open ->
                    planningLayersAnimations.closedShort

                Closed ->
                    planningLayersAnimations.closedFull
    in
    { model
        | planningLayersOpenness = Closed
        , planningLayersAnimations =
            Animation.interrupt
                [ Animation.to animations ]
                model.planningLayersAnimations
    }


expandDrawer : Model -> Model
expandDrawer model =
    { model
        | drawerOpenness = Open
        , drawerAnimations =
            Animation.interrupt
                [ Animation.to drawerAnimations.open ]
                model.drawerAnimations
        , planningLayersAnimations =
            let
                animations =
                    case model.planningLayersOpenness of
                        Open -> 
                            planningLayersAnimations.openShort

                        Closed ->
                            planningLayersAnimations.closedShort
            in
            Animation.interrupt
                [ Animation.to animations ]
                model.planningLayersAnimations
    }


collapseDrawer : Model -> Model
collapseDrawer model =
    { model
        | drawerOpenness = Closed
        , drawerAnimations =
            Animation.interrupt
                [ Animation.to drawerAnimations.closed ]
                model.drawerAnimations
        , planningLayersAnimations =
            let
                animations =
                    case model.planningLayersOpenness of
                        Open ->
                            planningLayersAnimations.openFull

                        Closed ->
                            planningLayersAnimations.closedFull

            in
            Animation.interrupt
                [ Animation.to animations ]
                model.planningLayersAnimations
    }



---- VIEW ----


type MainStyles
    = None
    | Body
    | Header
    | PlanningLayers
    | Drawer
    | Toggle


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
        , Style.style Drawer
            [ Color.background <| Color.rgba 0 0 0 0.3
            ]
        , Style.style Toggle
            [ Color.background white
            , Style.cursor "pointer"
            ]
        ]


renderAnimation : Animation.State -> List (Element.Attribute variation Msg) -> List (Element.Attribute variation Msg)
renderAnimation animations otherAttrs =
    (List.map Element.Attributes.toAttr <| Animation.render animations) ++ otherAttrs


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
                        |> within
                            [ planningLayersView model
                            , drawerView model
                            ]
                    ]
            ]


planningLayersView : Model -> Element MainStyles variation Msg
planningLayersView model =
    el None
        (renderAnimation model.planningLayersAnimations
            [ height fill
            , width content
            , paddingTop 20.0
            ]
        )
        (sidebar PlanningLayers
            [ height fill, width (px 100) ]
            [ el Toggle
                [ height (px 30)
                , width (px 30)
                , alignRight
                , onClick TogglePlanningLayers
                ]
                empty
            ]
        )


drawerView : Model -> Element MainStyles variation Msg
drawerView model =
    footer Drawer
        (renderAnimation model.drawerAnimations
            [ width fill
            , height content
            , alignBottom
            ]
        )
        (column None [ width fill, height (px 100) ] [ empty ]
            |> above [ el Toggle [ height (px 30), width (px 60), center, onClick ToggleDrawer ] empty ]
        )



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate
        [ model.planningLayersAnimations
        , model.drawerAnimations
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
