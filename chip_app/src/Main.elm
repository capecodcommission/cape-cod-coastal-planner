module Main exposing (..)

import Navigation
import Html exposing (Html)
import Dict
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Element.Input as Input exposing (..)
import Style exposing (..)
import Style.Color as Color
import Style.Border as Border
import Style.Font as Font
import Color exposing (..)
import Animation
import Routes exposing (Route(..), parseRoute)
import Ports exposing (..)


---- MODEL ----

type Hazard
    = SeaLevelRise
    | StormSurge
    | Erosion

type alias Model =
    { urlState : Maybe Route
    , hazardMenu : SelectWith Hazard Msg
    , numHazards : Int
    }


defaultModel : Model
defaultModel =
    Model
        (Just Blank)
        (Input.dropMenu Nothing SelectHazard)
        3


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
    | SelectHazard (Input.SelectMsg Hazard)
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

        SelectHazard msg ->
            ( { model | hazardMenu = Input.updateSelection msg model.hazardMenu }
            , Cmd.none
            )

        Animate animMsg ->
            ( model, Cmd.none )
            -- ( { model
            --     | planningLayersAnimations = Animation.update animMsg model.planningLayersAnimations
            --     , drawerAnimations = Animation.update animMsg model.drawerAnimations
            --   }
            -- , Cmd.none
            -- )


---- VIEW ----


-- Palette colors named using http://chir.ag/projects/name-that-color
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
            ]
        , Style.style (Header HeaderMenu)
            [ Color.background <| rgba 0 0 0 0.4
            , Color.text white
            , Font.size 24.0
            , Font.typeface fontstack
            , Border.rounded 8.0
            ]
        , Style.style (Header HeaderSubMenu)
            [ Style.opacity 0.65
            ]
        , Style.style (Header HeaderMenuItem)
            [ Color.text white
            , Font.size 18.0
            , Font.typeface fontstack
            , variation Input.Idle
                [ Color.background black ]
            , variation Input.Selected
                [ Color.background red ]
            , variation Input.Focused
                [ Color.background green ]
            , variation Input.SelectedInBox
                [ Color.background orange ]
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


headerView : Model -> Element MainStyles ChoiceState Msg
headerView model =
    header (Header HeaderBackground) [ height (px 80) ] <|
        row NoStyle [ height fill, paddingXY 54.0 0.0, spacingXY 54.0 0.0 ] <|
            [ column NoStyle [ verticalCenter ] 
                [ h1 (Header HeaderTitle) [] <| Element.text "Coastal Hazard Impact Planner" ]
            , column NoStyle [ verticalCenter, alignRight, width fill ] 
                [ row NoStyle [] [ headerDropdownView model ] ]
            ]


headerDropdownView : Model -> Element MainStyles ChoiceState Msg
headerDropdownView model =
    Input.select (Header HeaderMenu) 
        [ height (px 42), width (px 327) ]
        { label = Input.placeholder <|
            { text = "select an option"
            , label = Input.hiddenLabel "Select Hazard"
            }
        , with = model.hazardMenu
        , max = model.numHazards
        , options = []
        , menu =            
            Input.menu (Header HeaderSubMenu)
                [ width (px 327) ]
                [ Input.styledSelectChoice SeaLevelRise <| headerMenuItemView "Sea Level Rise"
                , Input.styledSelectChoice StormSurge <| headerMenuItemView "Storm Surge"
                , Input.styledSelectChoice Erosion <| headerMenuItemView "Erosion"
                ]
        }


headerMenuItemView : String -> ChoiceState -> Element MainStyles ChoiceState Msg
headerMenuItemView itemText state =
    el (Header HeaderMenuItem) [ vary state True ] <| Element.text itemText
        


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
