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
import View.Helpers exposing (..)


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
        , vary SelectMenuError <| RemoteData.isFailure model.coastalHazards
        ]
        { label = hazardPlaceholder model.coastalHazards
        , with = model.hazardMenu
        , max = model.numHazards
        , options = hazardOptions model.coastalHazards
        , menu =
            Input.menu (Header HeaderSubMenu)
                [ width (px 327), forceTransparent 327 ]
                (hazardMenuItems model.coastalHazards)
        }


hazardPlaceholder : GqlData CoastalHazardsResponse -> Label MainStyles Variations Msg
hazardPlaceholder response =
    let
        ( placeholderText, hiddenText ) =
            case response of
                NotAsked ->
                    ( "", "Select Hazard" )

                Loading ->
                    ( "loading hazards...", "Select Hazard" )

                Failure err ->
                    err |> SelectError.errorText |> Tuple.mapFirst (\e -> "(" ++ e ++ ")") |> Tuple.mapSecond (\e -> "Select Hazard: " ++ e)

                Success _ ->
                    ( "select hazard", "Select Hazard" )
    in
        Input.placeholder
            { text = placeholderText
            , label = Input.hiddenLabel hiddenText
            }


hazardOptions : GqlData CoastalHazardsResponse -> List (Input.Option MainStyles Variations Msg)
hazardOptions response =
    case response of
        Success _ ->
            []

        _ ->
            [ Input.disabled ]


hazardMenuItems : GqlData CoastalHazardsResponse -> List (Input.Choice CoastalHazard MainStyles Variations Msg)
hazardMenuItems response =
    case response of
        Success data ->
            data.hazards
                |> List.indexedMap (hazardMenuItemView ((List.length data.hazards) - 1))

        _ ->
            []


hazardMenuItemView : Int -> Int -> CoastalHazard -> Input.Choice CoastalHazard MainStyles Variations Msg
hazardMenuItemView lastIndex currentIndex hazard =
    Input.styledSelectChoice hazard <|
        (\state ->
            el (Header HeaderMenuItem)
                [ vary (choiceStateToVariation state) True
                , vary LastMenuItem (lastIndex == currentIndex)
                , padding 5.0
                ]
                (Element.text hazard.name)
        )
