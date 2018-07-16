module Styles exposing (..)

import Color exposing (..)
import Style exposing (..)
import Style.Color as Color
import Style.Border as Border
import Style.Font as Font
import Element.Input as Input exposing (ChoiceState)


{-| Palette colors named using <http://chir.ag/projects/name-that-color>
-}
palette =
    { cornflowerBlue = rgb 97 149 237
    , mySin = rgb 255 182 18
    }


fontstack : List Font
fontstack =
    [ Font.font "Segoe", Font.font "Tahoma", Font.font "Verdana", Font.sansSerif ]


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
