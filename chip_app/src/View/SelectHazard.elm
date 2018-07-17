module View.SelectHazard exposing (..)

import Maybe
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input exposing (..)
import RemoteData exposing (RemoteData(..))
import Message exposing (..)
import Types exposing (..)
import Styles exposing (..)
import View.SelectError as SelectError


view :
    { model
        | coastalHazards : GqlData CoastalHazardsResponse
        , hazardMenu : SelectWith CoastalHazard Msg
        , isHazardMenuOpen : Bool
        , numHazards : Int
    }
    -> Element MainStyles Variations Msg
view model =
    Input.select (Header HeaderMenu)
        [ height (px 42)
        , width (px 327)
        , paddingXY 10.0 0.0
        , vary SelectMenuOpen model.isHazardMenuOpen
        ]
        { label = hazardPlaceholder model.coastalHazards
        , with = model.hazardMenu
        , max = model.numHazards
        , options = hazardOptions model.coastalHazards
        , menu =
            Input.menu (Header HeaderSubMenu)
                [ width (px 327) ]
                (hazardMenuItems model.coastalHazards)
        }


hazardPlaceholder : GqlData CoastalHazardsResponse -> Label MainStyles Variations Msg
hazardPlaceholder response =
    let
        placeholderText =
            case response of
                NotAsked ->
                    ""

                Loading ->
                    "loading hazards..."

                Failure _ ->
                    ""

                Success _ ->
                    "select hazard"
    in
        Input.placeholder
            { text = placeholderText
            , label = Input.hiddenLabel "select_hazard"
            }


hazardOptions : GqlData CoastalHazardsResponse -> List (Input.Option MainStyles Variations Msg)
hazardOptions response =
    case response of
        NotAsked ->
            [ Input.disabled ]

        Loading ->
            [ Input.disabled ]

        Failure err ->
            [ Input.disabled
            , SelectError.view err
            ]

        Success _ ->
            []


hazardMenuItems : GqlData CoastalHazardsResponse -> List (Input.Choice CoastalHazard MainStyles Variations Msg)
hazardMenuItems response =
    case response of
        Success data ->
            data.hazards
                |> List.map (\h -> Maybe.withDefault (CoastalHazard "") h)
                |> List.filter (\h -> h.name /= "")
                |> List.map hazardMenuItemView

        _ ->
            []


hazardMenuItemView : CoastalHazard -> Input.Choice CoastalHazard MainStyles Variations Msg
hazardMenuItemView hazard =
    Input.styledSelectChoice hazard <|
        (\state ->
            el (Header HeaderMenuItem)
                [ vary (choiceStateToVariation state) True
                , padding 5.0
                ]
                (Element.text hazard.name)
        )
