module Main exposing (..)

import Navigation
import Html exposing (Html)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events as Events exposing (..)
import Element.Input as Input exposing (..)
import Style exposing (..)
import Style.Color as Color
import Style.Border as Border
import Style.Font as Font
import Color exposing (..)
import Animation
import RemoteData exposing (RemoteData(..))
import Maybe
import Maybe.Extra as MEx
import Types exposing (..)
import Message exposing (..)
import Request exposing (..)
import Routes exposing (Route(..), parseRoute)
import Ports exposing (..)


---- MODEL ----


type alias Model =
    { urlState : Maybe Route
    , coastalHazards : GqlData CoastalHazardsResponse
    , hazardMenu : SelectWith CoastalHazard Msg
    , isHazardMenuOpen : Bool
    , numHazards : Int
    }


defaultModel : Model
defaultModel =
    Model
        (Just Blank)
        RemoteData.Loading
        (Input.dropMenu Nothing SelectHazard)
        False
        3


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( updatedModel, routeFx ) =
            update (UrlChange location) defaultModel

        msgs =
            Cmd.batch
                [ getCoastalHazards
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


{-| Palette colors named using <http://chir.ag/projects/name-that-color>
-}
palette =
    { cornflowerBlue = rgb 97 149 237
    , mySin = rgb 255 182 18
    }


fontstack : List Font
fontstack =
    [ Font.font "Tahoma", Font.font "Verdana", Font.font "Segoe", Font.sansSerif ]


type MainStyles
    = NoStyle
    | Header HeaderStyles


type HeaderStyles
    = HeaderBackground
    | HeaderTitle
    | HeaderMenu
    | HeaderSubMenu
    | HeaderMenuItem


type Variations
    = InputIdle
    | InputSelected
    | InputFocused
    | InputSelectedInBox
    | SelectMenuOpen


choiceStateToVariation : ChoiceState -> Variations
choiceStateToVariation state =
    case state of
        Input.Idle ->
            InputIdle

        Input.Selected ->
            InputSelected

        Input.Focused ->
            InputFocused

        Input.SelectedInBox ->
            InputSelectedInBox


stylesheet =
    Style.styleSheet
        [ Style.style NoStyle []
        , Style.style (Header HeaderBackground)
            [ Color.background palette.cornflowerBlue
            ]
        , Style.style (Header HeaderTitle)
            [ Color.text white
            , Font.size 24.0
            , Font.bold
            , Font.typeface fontstack
            , Font.letterSpacing 1.0
            ]
        , Style.style (Header HeaderMenu)
            [ Color.background <| rgba 0 0 0 0.4
            , Color.text white
            , Font.size 22.0
            , Font.typeface fontstack
            , Border.rounded 8.0
            , Style.focus
                [ Border.roundBottomLeft 0.0
                , Border.roundBottomRight 0.0
                ]
            , variation SelectMenuOpen
                [ Border.roundBottomLeft 0.0
                , Border.roundBottomRight 0.0
                ]
            ]
        , Style.style (Header HeaderSubMenu)
            [ Style.opacity 0.85
            ]
        , Style.style (Header HeaderMenuItem)
            [ Color.text white
            , Font.size 18.0
            , Font.typeface fontstack
            , Style.hover
                [ Color.background green ]
            , variation InputIdle
                [ Color.background black ]
            , variation InputSelected
                [ Color.background red ]
            , variation InputFocused []
            , variation InputSelectedInBox
                [ Style.hover
                    [ Color.background <| rgba 0 0 0 0.0 ]
                ]
            ]
        ]


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
                [ row NoStyle [] [ headerDropdownView model ] ]
            ]


headerDropdownView : Model -> Element MainStyles Variations Msg
headerDropdownView model =
    case model.coastalHazards of
        NotAsked ->
            Input.select (Header HeaderMenu)
                [ height (px 42)
                , width (px 327)
                , paddingXY 10.0 0.0
                , vary SelectMenuOpen model.isHazardMenuOpen
                ]
                { label =
                    Input.placeholder <|
                        { text = ""
                        , label = Input.hiddenLabel "Select Hazard"
                        }
                , with = model.hazardMenu
                , max = model.numHazards
                , options = [ Input.disabled ]
                , menu =
                    Input.menu (Header HeaderSubMenu)
                        [ width (px 327) ]
                        []
                }

        Loading ->
            Input.select (Header HeaderMenu)
                [ height (px 42)
                , width (px 327)
                , paddingXY 10.0 0.0
                , vary SelectMenuOpen model.isHazardMenuOpen
                ]
                { label =
                    Input.placeholder <|
                        { text = "loading hazards..."
                        , label = Input.hiddenLabel "Select Hazard"
                        }
                , with = model.hazardMenu
                , max = model.numHazards
                , options = [ Input.disabled ]
                , menu =
                    Input.menu (Header HeaderSubMenu)
                        [ width (px 327) ]
                        []
                }

        Failure err ->
            Input.select (Header HeaderMenu)
                [ height (px 42)
                , width (px 327)
                , paddingXY 10.0 0.0
                , vary SelectMenuOpen model.isHazardMenuOpen
                ]
                { label =
                    Input.placeholder <|
                        { text = ""
                        , label = Input.hiddenLabel "Select Hazard"
                        }
                , with = model.hazardMenu
                , max = model.numHazards
                , options = [ Input.disabled, Input.errorAbove <| Element.text "Failure to load hazards" ]
                , menu =
                    Input.menu (Header HeaderSubMenu)
                        [ width (px 327) ]
                        []
                }

        Success data ->
            let
                hazards : List CoastalHazard
                hazards =
                    data.hazards
                        |> List.map (\h -> Maybe.withDefault (CoastalHazard "") h)
                        |> List.filter (\h -> h.name /= "")
            in
                Input.select (Header HeaderMenu)
                    [ height (px 42)
                    , width (px 327)
                    , paddingXY 10.0 0.0
                    , vary SelectMenuOpen model.isHazardMenuOpen
                    ]
                    { label =
                        Input.placeholder <|
                            { text = "select hazard"
                            , label = Input.hiddenLabel "Select Hazard"
                            }
                    , with = model.hazardMenu
                    , max = model.numHazards
                    , options = []
                    , menu =
                        Input.menu (Header HeaderSubMenu)
                            [ width (px 327) ]
                            (hazards |> List.map headerMenuItemView)
                    }


headerMenuItemView : CoastalHazard -> Input.Choice CoastalHazard MainStyles Variations Msg
headerMenuItemView hazard =
    Input.styledSelectChoice hazard <|
        (\state ->
            el (Header HeaderMenuItem)
                [ vary (choiceStateToVariation state) True
                , padding 5.0
                ]
                (Element.text hazard.name)
        )



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
