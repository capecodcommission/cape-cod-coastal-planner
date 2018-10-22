module Styles exposing (..)

import Color exposing (..)
import Color.Manipulate exposing (..)
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
    , malibu = rgb 93 151 255
    , mySin = rgb 255 182 18
    , persimmon = rgb 255 85 85
    , walnut = rgb 108 67 26
    , red = rgb 255 18 18
    , jaffa = rgb 237 127 52
    , ming = rgb 59 130 132
    , mediumRedViolet = rgb 165 56 165
    }


fontstack : List Font
fontstack =
    [ Font.font "Segoe UI", Font.font "Tahoma", Font.font "Verdana", Font.sansSerif ]


fontstack2 : List Font
fontstack2 =
    [ Font.font "Tahoma" ]

type MainStyles
    = NoStyle
    | Header HeaderStyles
    | Baseline BaselineStyles
    | AddStrategies StrategiesStyles
    | Headings HeadingStyles
    | Sidebar SidebarStyles
    | Popup
    | Modal ModalStyles
    | Zoi ZoneOfImpactStyles
    | ActionButton
    | CancelButton
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


type SidebarStyles
    = SidebarContainer
    | SidebarHeader
    | SidebarToggle
    | SidebarFooter

type StrategiesStyles
    = StrategiesSidebar
    | StrategiesSidebarHeader
    | StrategiesHazardPicker
    | StrategiesSidebarList
    | StrategiesSidebarListBtn
    | StrategiesSidebarListBtnDisabled
    | StrategiesSidebarListBtnSelected
    | StrategiesSidebarFooter
    | StrategiesDetailsHeader
    | StrategiesSheetHeading
    | StrategiesSubHeading
    | StrategiesMainHeading
    | StrategiesDetailsCategories
    | StrategiesDetailsCategoryCircle
    | StrategiesDetailsMain

type ZoneOfImpactStyles
    = ZoiText
    | ZoiCallout
    | ZoiStat


type Variations
    = InputIdle
    | InputSelected
    | InputFocused
    | InputSelectedInBox
    | LastMenuItem
    | SelectMenuOpen
    | SelectMenuError
    | Secondary
    | Tertiary
    | Disabled


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
            , Font.center
            , Border.roundTopLeft 4
            ]
        , Style.style (AddStrategies StrategiesHazardPicker)
            [ Style.cursor "pointer"
            , variation Secondary
                [ Style.rotate pi
                ]
            ]
        , Style.style (AddStrategies StrategiesSidebarList)
            [ Font.size 20
            ]
        , Style.style (AddStrategies StrategiesSidebarListBtn)
            [ Color.background <| rgba 0 0 0 0
            , Color.text white
            , Font.alignLeft
            ]
        , Style.style (AddStrategies StrategiesSidebarListBtnDisabled)
            [ Color.background <| rgba 0 0 0 0
            , Color.text <| rgba 255 255 255 0.5
            , Font.alignLeft
            ]
        , Style.style (AddStrategies StrategiesSidebarListBtnSelected)
            [ Color.background <| fadeOut 0.7 palette.havelockBlue
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
        , Style.style (AddStrategies StrategiesSheetHeading)
            [ Font.typeface fontstack
            , Font.size 18
            , Font.letterSpacing 2.6
            , Font.lineHeight 1.4
            ]
        , Style.style (AddStrategies StrategiesSubHeading)
            [ Font.typeface fontstack
            , Font.letterSpacing 2.6
            , Font.lineHeight 1.4
            , Font.size 26
            ]
        , Style.style (AddStrategies StrategiesMainHeading)
            [ Font.typeface fontstack
            , Font.letterSpacing 2.6
            , Font.lineHeight 1.4
            , Font.size 36
            ]
        , Style.style (AddStrategies StrategiesDetailsCategories)
            [ Color.text white
            , Font.typeface fontstack
            , Font.size 10
            , Font.bold
            , Font.letterSpacing 1.44
            , variation Disabled
                [ Color.text palette.malibu
                ]
            ]
        , Style.style (AddStrategies StrategiesDetailsCategoryCircle)
            [ Color.background palette.jaffa
            , Color.border palette.jaffa
            , Border.all 1.5
            , Border.solid
            , variation Secondary
                [ Color.background palette.ming
                , Color.border palette.ming
                ]
            , variation Tertiary
                [ Color.background palette.mediumRedViolet
                , Color.border palette.mediumRedViolet
                ]
            , variation Disabled
                [ Color.background <| rgba 0 0 0 0
                , Color.border palette.malibu
                ]
            ]
        , Style.style (AddStrategies StrategiesDetailsMain)
            [ Color.text white
            ]
        , Style.style (Zoi ZoiText)
            [ Font.size 18
            , Font.lineHeight 1.4
            ]
        , Style.style (Zoi ZoiCallout)
            [ Color.text palette.havelockBlue
            , Font.bold 
            ]
        , Style.style (Zoi ZoiStat)
            [ Font.size 22
            , Color.text palette.havelockBlue
            , Font.letterSpacing 1
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
        , Style.style (Sidebar SidebarContainer)
            [ Color.background <| Color.rgba 0 0 0 0.7
            , Color.text white
            , Font.typeface fontstack
            ]
        , Style.style (Sidebar SidebarHeader)
            [ Color.background palette.havelockBlue
            ]
        , Style.style (Sidebar SidebarToggle)
            [ Color.background palette.havelockBlue
            , Border.roundTopLeft 36
            , Border.roundBottomLeft 36
            , Style.cursor "pointer"
            ]
        , Style.style (Sidebar SidebarFooter)
            [ Color.background black
            , Font.typeface fontstack
            ]
        , Style.style ActionButton
            [ Font.typeface fontstack
            , Font.uppercase
            , Font.bold
            , Font.size 14
            , Font.lineHeight 1.4
            , Font.letterSpacing 2.33
            , Color.text palette.walnut
            , Color.background palette.mySin
            , Border.rounded 8            
            , variation Disabled
                [ Color.background <| darken 0.15 palette.mySin
                , Color.text <| lighten 0.45 palette.walnut
                , Style.hover []
                ]
            ]
        , Style.style CancelButton
            [ Font.typeface fontstack
            , Font.uppercase
            , Font.bold
            , Font.size 14
            , Font.lineHeight 1.4
            , Font.letterSpacing 2.33
            , Color.text white
            , Color.background palette.red
            , Border.rounded 8
            , variation Disabled
                [ Color.background <| darken 0.15 palette.red
                , Color.text <| lighten 0.15 palette.red
                , Style.hover []
                ]
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
    , Font.lineHeight 1.4
    , variation Secondary
        [ Color.text palette.havelockBlue
        , Font.weight 400
        ]
    ]
