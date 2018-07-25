module View.SelectLocation exposing (..)

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
        | shorelineLocations : GqlData ShorelineLocationsResponse
        , locationMenu : SelectWith ShorelineLocation Msg
        , isLocationMenuOpen : Bool
        , numLocations : Int
    }
    -> Element MainStyles Variations Msg
view model =
    Input.select (Header HeaderMenu)
        [ height (px 42)
        , width (px 327)
        , paddingXY 10.0 0.0
        , vary SelectMenuOpen model.isLocationMenuOpen
        , vary SelectMenuError <| RemoteData.isFailure model.shorelineLocations
        ]
        { label = locationPlaceholder model.shorelineLocations
        , with = model.locationMenu
        , max = model.numLocations
        , options = locationOptions model.shorelineLocations
        , menu =
            Input.menu (Header HeaderSubMenu)
                [ width (px 327), forceTransparent 327 ]
                (locationMenuItems model.shorelineLocations)
        }


locationPlaceholder : GqlData ShorelineLocationsResponse -> Label MainStyles Variations Msg
locationPlaceholder response =
    let
        ( placeholderText, hiddenText ) =
            case response of
                NotAsked ->
                    ( "", "Select Shoreline Location" )

                Loading ->
                    ( "loading locations...", "Select Shoreline Location" )

                Failure err ->
                    err |> SelectError.errorText |> Tuple.mapFirst (\e -> "(" ++ e ++ ")") |> Tuple.mapSecond (\e -> "Select Shoreline Location: " ++ e)

                Success _ ->
                    ( "select shoreline location", "Select Shoreline Location" )
    in
        Input.placeholder
            { text = placeholderText
            , label = Input.hiddenLabel hiddenText
            }


locationOptions : GqlData ShorelineLocationsResponse -> List (Input.Option MainStyles Variations Msg)
locationOptions response =
    case response of
        Success _ ->
            []

        _ ->
            [ Input.disabled ]


locationMenuItems : GqlData ShorelineLocationsResponse -> List (Input.Choice ShorelineLocation MainStyles Variations Msg)
locationMenuItems response =
    case response of
        Success data ->
            data.locations
                |> List.indexedMap (locationMenuItemView ((List.length data.locations) - 1))

        _ ->
            []


locationMenuItemView : Int -> Int -> ShorelineLocation -> Input.Choice ShorelineLocation MainStyles Variations Msg
locationMenuItemView lastIndex currentIndex location =
    Input.styledSelectChoice location <|
        (\state ->
            el (Header HeaderMenuItem)
                [ vary (choiceStateToVariation state) True
                , vary LastMenuItem (lastIndex == currentIndex)
                , padding 5.0
                ]
                (Element.text location.name)
        )
