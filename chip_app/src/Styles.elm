module Styles exposing (..)

import Color exposing (..)
import Color.Manipulate exposing (fadeOut)
import Style exposing (..)
import Style.Color as Color
import Style.Border as Border
import Style.Font as Font
import Style.Transition as Transition
import Style.Scale as Scale
import Element.Input as Input exposing (ChoiceState)


scaled =
    Scale.modular 18 1.375


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
    | Baseline BaselineStyles
    | AddStrategies StrategiesStyles
    | Headings HeadingStyles
    | Sidebar
    | Popup
    | Modal ModalStyles    
    | CloseIcon
    | FontLeft
    | FontRight


type ModalStyles
    = ModalBackground
    | ModalContainer


type HeadingStyles
    = H1
    | H2
    | H3
    | H4
    | H5
    | H6


type HeaderStyles
    = HeaderBackground
    | HeaderTitle
    | HeaderMenu
    | HeaderSubMenu
    | HeaderMenuItem
    | HeaderMenuError


type BaselineStyles
    = BaselineInfoBtn
    | BaselineInfoHeader
    | BaselineInfoText


type StrategiesStyles
    = StrategiesSidebar
    | StrategiesSidebarHeader
    | StrategiesSidebarList
    | StrategiesSidebarListBtn
    | StrategiesSidebarFooter
    | StrategiesDetailsHeader
    | StrategiesDetailsMain


type Variations
    = InputIdle
    | InputSelected
    | InputFocused
    | InputSelectedInBox
    | LastMenuItem
    | SelectMenuOpen
    | SelectMenuError
    | Secondary


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
        , Style.style (Baseline BaselineInfoBtn)
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
        , Style.style (Baseline BaselineInfoHeader)
            [ Color.background palette.chambray
            , Color.text white
            , Font.typeface fontstack
            , Border.roundTopLeft 4
            , Border.roundTopRight 4
            ]
        , Style.style (Baseline BaselineInfoText)
            [ Color.text white
            , Font.size 16
            , Font.typeface fontstack
            , Font.lineHeight 1.29
            ]
        , Style.style (AddStrategies StrategiesSidebar)
            [ Color.text white
            , Color.border white
            , Border.right 1
            , Border.solid
            , Font.typeface fontstack
            , Font.lineHeight 1.4
            ]
        , Style.style (AddStrategies StrategiesSidebarHeader)
            [ Color.background palette.havelockBlue
            , Font.size 24
            , Border.roundTopLeft 4
            ]
        , Style.style (AddStrategies StrategiesSidebarList)
            [ Font.size 20
            ]
        , Style.style (AddStrategies StrategiesSidebarListBtn)
            [ Color.background <| rgba 0 0 0 0
            , Color.text white
            , Font.alignLeft
            ]
        , Style.style (AddStrategies StrategiesSidebarFooter)
            [ Color.background black
            , Border.roundBottomLeft 4
            ]
        , Style.style (AddStrategies StrategiesDetailsHeader)
            [ Color.background palette.chambray
            , Color.text white
            , Border.roundTopRight 4
            ]
        , Style.style (AddStrategies StrategiesDetailsMain)
            [ Color.text white
            ]
        , Style.style (Headings H1) <| headingStyle 6
        , Style.style (Headings H2) <| headingStyle 5
        , Style.style (Headings H3) <| headingStyle 4
        , Style.style (Headings H4) <| headingStyle 3
        , Style.style (Headings H5) <| headingStyle 2
        , Style.style (Headings H6) <| headingStyle 1
        , Style.style Popup
            [ Color.background palette.chambray
            , Color.text white
            ]
        , Style.style (Modal ModalBackground)
            [ Color.background <| rgba 0 0 0 0.59 ]
        , Style.style (Modal ModalContainer)
            [ Color.background <| rgba 0 0 0 0.7
            , Border.rounded 4
            ]
        , Style.style Sidebar
            [ Color.background <| Color.rgba 0 0 0 0.7
            , Color.text white
            , Font.typeface fontstack
            ]
        , Style.style CloseIcon
            [ Style.cursor "pointer" ]
        , Style.style FontLeft [ Font.alignLeft ]
        , Style.style FontRight [ Font.alignRight ]
        ]


headingStyle scale =
    [ Color.text white
    , Font.size (scaled scale)
    , Font.typeface fontstack
    , Font.weight 300
    , variation Secondary
        [ Color.text palette.havelockBlue
        , Font.weight 400
        ]
    ]
