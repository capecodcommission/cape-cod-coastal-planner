module Styles exposing (..)

import Color exposing (..)
import Color.Manipulate exposing (fadeOut)
import Style exposing (..)
import Style.Color as Color
import Style.Border as Border
import Style.Font as Font
import Style.Transition as Transition
import Element.Input as Input exposing (ChoiceState)


{-| Palette colors named using <http://chir.ag/projects/name-that-color>
-}
palette =
    { chambray = rgb 54 77 127
    , havelockBlue = rgb 85 126 216
    , mySin = rgb 255 182 18
    , persimmon = rgb 255 85 85
    }


fontstack : List Font
fontstack =
    [ Font.font "Segoe UI", Font.font "Tahoma", Font.font "Verdana", Font.sansSerif ]


type MainStyles
    = NoStyle
    | Header HeaderStyles


type HeaderStyles
    = HeaderBackground
    | HeaderTitle
    | HeaderMenu
    | HeaderSubMenu
    | HeaderMenuItem
    | HeaderMenuError
    | BaselineInfoBtn


type Variations
    = InputIdle
    | InputSelected
    | InputFocused
    | InputSelectedInBox
    | LastMenuItem
    | SelectMenuOpen
    | SelectMenuError


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
            [ Color.background palette.chambray
            ]
        , Style.style (Header HeaderTitle)
            [ Color.text white
            , Font.size 24.0
            , Font.bold
            , Font.typeface fontstack
            , Font.letterSpacing 1.0
            ]
        , Style.style (Header HeaderMenu)
            [ Color.background <| rgba 0 0 0 0.7
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
            , variation SelectMenuError
                [ Color.text palette.persimmon
                ]
            ]
        , Style.style (Header HeaderSubMenu)
            [ Color.background <| rgba 0 0 0 0.7
            ]
        , Style.style (Header HeaderMenuItem)
            [ Color.text white
            , Font.size 18.0
            , Font.typeface fontstack
            , Style.hover
                [ Color.background <| fadeOut 0.7 palette.havelockBlue ]
            , variation InputIdle
                [ Color.background <| rgba 0 0 0 0.7 ]
            , variation InputSelected
                [ Color.text palette.havelockBlue
                , Color.background <| rgba 0 0 0 0.7
                , Style.hover
                    [ Color.text white ]
                ]
            , variation InputFocused []
            , variation InputSelectedInBox
                [ Style.hover
                    [ Color.background <| rgba 0 0 0 0.0 ]
                ]
            , variation LastMenuItem
                [ Border.roundBottomLeft 8.0
                , Border.roundBottomRight 8.0
                ]
            ]
        , Style.style (Header HeaderMenuError)
            [ Color.text palette.persimmon
            , Font.size 14.0
            , Font.typeface fontstack
            ]
        , Style.style (Header BaselineInfoBtn)
            [ Color.background <| rgba 0 0 0 0
            , Color.text white
            , Color.border white
            , Font.size 22.0
            , Font.typeface fontstack
            , Font.italic
            , Border.rounded 50.0
            , Border.all 2
            , Transition.all
            , Style.hover
                [ Color.text palette.mySin
                , Color.border palette.mySin
                , Transition.all
                ]
            ]
        ]
