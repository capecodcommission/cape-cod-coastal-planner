module Styles exposing (..)

import Color exposing (..)
import Color.Manipulate exposing (..)
import Style exposing (..)
import Style.Color as Color
import Style.Border as Border
import Style.Font as Font
import Style.Transition as Transition
import Style.Scale as Scale
import Style.Background as Background
import Element.Input as Input exposing (ChoiceState)
import Element exposing (Device)
import View.Helpers exposing (adjustOnHeight, adjustOnWidth)


scaled =
    Scale.modular 18 1.375


{-| Palette colors named using <http://chir.ag/projects/name-that-color>
-}
palette =
    { elephant = rgb 10 40 51
    , chambray = rgb 54 77 127
    , havelockBlue = rgb 85 126 216
    , malibu = rgb 93 151 255
    , mySin = rgb 255 182 18
    , persimmon = rgb 255 85 85
    , walnut = rgb 108 67 26
    , red = rgb 255 18 18
    , hippieBlue = rgb 83 168 172
    , mediumRedViolet = rgb 165 56 165
    , apple = rgb 112 173 71
    , cadetBlue = rgb 155 166 191
    , blueStone = rgb 25 52 70
    , alto = rgb 218 218 218
    , shadedScale = rgb 41 48 58
    }


fontstack : List Font
fontstack =
    [ Font.font "Montserrat", Font.font "Open Sans", Font.font "Tahoma", Font.sansSerif ]


fontstack2 : List Font
fontstack2 =
    [ Font.font "Montserrat" ]

type MainStyles
    = NoStyle
    | MainContent
    | Header HeaderStyles
    | Baseline BaselineStyles
    | AddStrategies StrategiesStyles
    | ShowOutput OutputStyles
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
    | Hairline
    | MethodsResourcesBackgroundLine
    | CircleBullet
    | Test
    | PL PlanningLayerStyles
    | Rbn RibbonStyles
    | SelectShorelineButton
    | MenuButton
    | MenuContainer


type ModalStyles
    = ModalBackground
    | ModalContainer
    | IntroHeader
    | IntroBody
    | IntroWelcome
    | IntroDisclaimer
    | MethodsResourcesBackground
    | MethodsResourcesModal
    | MethodsResourcesModalHeading


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
    | HeaderBackgroundRounded
    | ScaleHeader


type BaselineStyles
    = BaselineInfoBtn
    | BaselineInfoHeader
    | BaselineInfoText
    | BaselineInfoBtnClicked
    | BaselineInfoImage


type SidebarStyles
    = SidebarContainer
    | SidebarHeader
    | SidebarToggle
    | SidebarFooter
    | SidebarLeftToggle


type OutputStyles
    = OutputToggleBtn
    | OutputToggleLbl
    | OutputHeader
    | OutputDivider
    | OutputSmallItalic
    | OutputH6Bold
    | OutputImpact
    | OutputMultiImpact
    | OutputAddresses
    | OutputHazard
    | ScenarioLabel
    | ScenarioBold
    | OutputValue
    | OutputValueLbl
    | OutputValueBox
    | OutputInfoIcon

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
    | StrategiesDetailsHeading
    | StrategiesDetailsHazards
    | StrategiesDetailsHazardsCircle
    | StrategiesDetailsBenefits
    | StrategiesDetailsDescription
    | StrategiesDetailsTextList


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
    | Quaternary
    | Disabled

type PlanningLayerStyles 
    = Line
    | Clicked
    | RoadsPrivate
    | RoadsPublic
    | Groins
    | Revetment
    | Jetty
    | Accretion
    | Erosion
    | FZA
    | FZAE
    | FZAO
    | FZVE
    | CAT1
    | CAT2
    | CAT3
    | CAT4

type RibbonStyles
    = LessThanZero
    | OneToFive
    | SixPlus


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


stylesheet : Device -> StyleSheet MainStyles Variations
stylesheet device =
    Style.styleSheet
        [ Style.style NoStyle []
        , Style.style Test [ Color.background palette.mySin ]
        , Style.style MainContent
            [ Color.background palette.elephant
            , Style.hover
                [ Style.cursor "default" ]
            ]
        , Style.style (Header HeaderBackground)
            [ Color.background palette.blueStone
            ]
        , Style.style (Header HeaderBackgroundRounded)
            [ Color.background palette.blueStone
            , Border.rounded 20.0
            ]
        , Style.style (Header HeaderTitle)
            [ Color.text white
            , Font.size 24.0
            , Font.bold
            , Font.typeface fontstack
            , Font.letterSpacing 1.0
            ]
        , Style.style (Header ScaleHeader)
            [ Color.text white
            , Font.size 18.0
            , Font.bold
            , Font.typeface fontstack
            , Font.letterSpacing 1.0
            ]
        , Style.style (Header HeaderMenu)
            [ Color.background <| rgba 0 0 0 0.9
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
            [ Color.background <| rgba 0 0 0 0.9
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
            , Border.rounded 50.0
            , Border.all 2
            , Transition.all
            , Style.hover
                [ Color.text palette.mySin
                , Color.border palette.mySin
                , Transition.all
                ]
            ] 
        , Style.style MenuButton
            [ Color.background <| rgba 0 0 0 0
            , Color.text white
            , Font.size 30.0
            , Font.typeface fontstack
            , Transition.all
            , Style.hover
                [ Color.text palette.mySin
                , Color.border palette.mySin
                , Transition.all
                ]
            ]    
        , Style.style (Baseline BaselineInfoBtnClicked)
            [ Color.background <| rgba 0 0 0 0
            , Color.text orange
            , Color.border orange
            , Font.size 22.0
            , Font.typeface fontstack
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
            [ Color.background palette.blueStone
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
        , Style.style (Baseline BaselineInfoImage)
            [ Background.gradientRight [Background.step white, Background.step black]
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
            [ Color.background palette.hippieBlue
            , Font.size 24
            , Font.center
            , Font.typeface fontstack
            , Border.roundTopLeft 4
            , Style.hover
                [ Style.cursor "default" ]
            ]
        , Style.style (AddStrategies StrategiesHazardPicker)
            [ Style.cursor "pointer"
            , variation Secondary
                [ Style.rotate pi
                ]
            ]
        , Style.style (AddStrategies StrategiesSidebarList)
            [ Font.size 20
            , Font.typeface fontstack
            ]
        , Style.style (AddStrategies StrategiesSidebarListBtn)
            [ Color.background <| rgba 0 0 0 0
            , Color.text white
            , Font.alignLeft
            , Font.typeface fontstack
            ]
        , Style.style (AddStrategies StrategiesSidebarListBtnDisabled)
            [ Color.background <| rgba 0 0 0 0
            , Color.text <| rgba 255 255 255 0.5
            , Font.alignLeft
            , Font.typeface fontstack
            ]
        , Style.style (AddStrategies StrategiesSidebarListBtnSelected)
            [ Color.background <| fadeOut 0.7 palette.havelockBlue
            , Color.text white
            , Font.alignLeft
            , Font.typeface fontstack
            ]
        , Style.style (AddStrategies StrategiesSidebarFooter)
            [ Color.background black
            , Border.roundBottomLeft 4
            ]
        , Style.style (AddStrategies StrategiesDetailsHeader)
            [ Color.background palette.blueStone
            , Color.text white
            , Border.roundTopRight 4
            , Style.hover
                [ Style.cursor "default" ]
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
            , Font.size 30
            , Font.uppercase
            , Font.bold
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
        -- Updated these colors, but this does not style the types of selected adaptation strategy icons on the 'StrategiesModal' as they are hard-coded
        , Style.style (AddStrategies StrategiesDetailsCategoryCircle)
            [ Color.background white
            , Color.border white
            , Border.all 1.5
            , Border.solid
            , variation Secondary
                [ Color.background white
                , Color.border white
                ]
            , variation Tertiary
                [ Color.background white
                , Color.border white
                ]
            , variation Disabled
                [ Color.background <| rgba 0 0 0 0
                , Color.border palette.alto
                ]
            ]
        , Style.style (AddStrategies StrategiesDetailsMain)
            [ Color.text white
            , Font.typeface fontstack
            , Style.hover
                [ Style.cursor "default" ]
            ]
        , Style.style (AddStrategies StrategiesDetailsHeading)
            [ Color.text palette.hippieBlue
            , Font.typeface fontstack
            , Font.size (scaled 1)
            , Font.weight 800
            , Font.lineHeight 1.4
            ]
        , Style.style (AddStrategies StrategiesDetailsHazards)
            [ Font.size 14
            , Font.letterSpacing 1.24
            , Font.weight 400
            , Font.typeface fontstack
            , Color.text white
            , variation Disabled
                [ Color.text <| rgba 255 255 255 0.5 ]
            ]
        , Style.style (AddStrategies StrategiesDetailsHazardsCircle)
            [ Color.border white
            , Border.all 1.2
            , Border.solid
            , variation Disabled
                [ Color.border <| rgba 255 255 255 0.5 ]
            ]
        , Style.style (AddStrategies StrategiesDetailsBenefits)
            [ Font.size 11
            , Font.weight 400
            , Font.typeface fontstack
            , Color.text white
            , variation Disabled
                [ Color.text <| rgba 255 255 255 0.5 ]
            ]
        , Style.style (AddStrategies StrategiesDetailsDescription)
            [ Color.text white
            , Font.typeface fontstack
            , Font.size 16
            , Font.lineHeight 1.4
            , variation Secondary
                [ Color.text palette.havelockBlue
                , Font.bold
                ]
            ]
        , Style.style (AddStrategies StrategiesDetailsTextList)
            [ Color.text white
            , Font.typeface fontstack
            , Font.size 16
            , Font.lineHeight 1.5
            , variation Secondary
                [ Color.text palette.havelockBlue
                , Font.bold
                , Font.size 18
                ]
            ]
        , Style.style (Zoi ZoiText)
            [ Font.size <| adjustOnHeight ( 12, 18 ) device
            , Font.lineHeight <| adjustOnHeight ( 1.2, 2.0 ) device
            , Font.typeface fontstack
            ]
        , Style.style (Zoi ZoiCallout)
            [ Color.text palette.havelockBlue
            , Font.bold
            , Font.typeface fontstack
            ]
        , Style.style (Zoi ZoiStat)
            [ Font.size 20
            , Color.text palette.havelockBlue
            , Font.letterSpacing 1
            , Font.typeface fontstack
            ]
        , Style.style (ShowOutput OutputToggleBtn)
            [ Font.letterSpacing 2.33
            , Color.background palette.alto
            , Font.typeface fontstack
            ]
        , Style.style (ShowOutput OutputToggleLbl)
            [ Font.center
            , Font.letterSpacing 2.33
            , Font.typeface fontstack
            , Color.background <| rgba 19 39 52 1
            ]
        , Style.style (ShowOutput OutputHeader)
            [ Color.background <| rgba 19 39 52 1
            ]
        , Style.style (ShowOutput OutputDivider)
            [ Border.right 2
            , Border.solid
            , Color.border white
            ]
        , Style.style (ShowOutput OutputH6Bold)
            [ Font.size <| scaled 1
            , Font.weight 500
            , Font.typeface fontstack
            ]
        , Style.style (ShowOutput OutputSmallItalic)
            [ Font.size 14
            , Font.italic
            , Font.typeface fontstack
            ]
        , Style.style (ShowOutput OutputImpact)
            [ Font.size 12
            , Font.lineHeight 1.4
            , Font.center
            , Font.typeface fontstack
            , Color.text white
            , Font.weight 600
            , Color.background palette.hippieBlue
            , variation Secondary
                [ Color.background palette.hippieBlue ]
            ]
        , Style.style (ShowOutput OutputMultiImpact)
            [ Font.size 11
            , Font.lineHeight 1.4
            , Font.center
            , Font.typeface fontstack
            , Color.text palette.chambray
            , Color.background <| rgba 255 255 255 0.9
            , Border.solid
            , Color.border palette.chambray
            , Border.right 1
            , Border.bottom 1
            , variation Secondary 
                [ Border.right 0
                , Border.bottom 0
                ]
            , variation Tertiary
                [ Border.bottom 0
                , Border.right 0
                ]
            , variation Quaternary
                [ Border.right 0
                , Border.bottom 0
                ]
            , variation Disabled
                [ Color.background <| rgba 41 48 58 0.9
                , Color.text <| rgba 255 255 255 0.5
                ]
            ]
        , Style.style (ShowOutput OutputAddresses)
            [ Font.size 13
            , Font.typeface fontstack
            ]
        , Style.style (ShowOutput OutputHazard)
            [ Font.size 16
            , Font.bold
            , Font.typeface fontstack
            ]
        , Style.style (ShowOutput ScenarioLabel)
            [ Font.size 14
            , Font.typeface fontstack
            ]
        , Style.style (ShowOutput ScenarioBold)
            [ Font.bold
            , Font.typeface fontstack
            ]
        , Style.style (ShowOutput OutputValue)
            [ Font.size 22
            , Font.weight 500
            , Font.typeface fontstack
            , Color.text <| rgba 255 255 255 0.5
            , variation Secondary
                [ Color.text palette.mySin ]
            , variation Tertiary
                [ Color.text palette.havelockBlue ]
            ]
        , Style.style (ShowOutput OutputValueLbl)
            [ Font.size 12
            , Font.letterSpacing 2.33
            , Font.typeface fontstack
            , Color.text <| rgba 255 255 255 0.5
            , variation Secondary
                [ Color.text palette.mySin ]
            , variation Tertiary
                [ Color.text palette.havelockBlue ]
            ]
        , Style.style (ShowOutput OutputValueBox)
            [ Border.all 2
            , Border.solid
            , Border.rounded 8
            , Color.border <| rgba 255 255 255 0.5
            , Color.background <| rgba 0 0 0 0
            , Font.weight 500
            , Font.typeface fontstack
            , variation Secondary
                [ Color.background palette.mySin 
                , Color.border palette.mySin
                , Color.text <| rgba 0 0 0 0.9
                ]
            , variation Tertiary
                [ Color.background palette.havelockBlue 
                , Color.border palette.havelockBlue
                ]
            ]
        , Style.style (ShowOutput OutputInfoIcon)
            [ Color.background palette.cadetBlue
            , Color.text white
            , Font.size 8
            , Font.lineHeight 1
            , Font.center
            , Font.weight 500
            , Font.italic
            , Font.typeface fontstack
            , Style.hover
                [ Style.cursor "pointer" ]
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
        , Style.style (Modal MethodsResourcesBackground)
            [ Color.background <| rgba 25 52 70 0.75 ]
        , Style.style (Modal ModalContainer)
            [ Color.background <| rgba 0 0 0 0.9
            , Border.rounded 4
            ]
        , Style.style (Modal IntroHeader)
            [ Color.background <| rgba 41 84 112 1
            , Border.rounded 4
            ]
        , Style.style (Modal IntroBody)
            [ Color.background palette.blueStone
            , Border.rounded 4     
            ]
        , Style.style (Modal IntroWelcome)
            [ Color.text white
            , Font.size 20
            , Font.justify
            , Font.typeface fontstack
            ]
        , Style.style (Modal IntroDisclaimer)
            [ Color.text palette.alto
            , Font.size 15
            , Font.justify
            , Font.typeface fontstack
            ]
        , Style.style (Modal MethodsResourcesModal)
            [ Color.text white
            , Font.size 14
            , Font.typeface fontstack
            , Font.justify
            ]
        , Style.style (Modal MethodsResourcesModalHeading)
            [ Color.text palette.hippieBlue
            , Font.size 18
            , Font.center
            , Font.weight 800
            , Font.typeface fontstack
            ]
        , Style.style (Sidebar SidebarContainer)
            [ Color.background <| Color.rgba 0 0 0 0.9
            , Color.text white
            , Font.typeface fontstack
            ]
        , Style.style MenuContainer
            [ Color.background palette.blueStone
            , Color.text white
            , Font.typeface fontstack
            , Font.size 25
            ]
        , Style.style (Sidebar SidebarHeader)
            [ Color.background palette.blueStone
            ]
        , Style.style (Sidebar SidebarToggle)
            [ Color.background palette.blueStone
            , Border.roundTopLeft 36
            , Border.roundBottomLeft 36
            , Style.cursor "pointer"
            ]
        , Style.style (Sidebar SidebarFooter)
            [ Color.background black
            , Font.typeface fontstack
            ]
        , Style.style (Sidebar SidebarLeftToggle)
            [ Color.background palette.blueStone
            , Border.roundTopRight 36
            , Border.roundBottomRight 36
            , Style.cursor "pointer"
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
            , Transition.all
            , variation Disabled
                [ Color.background <| darken 0.15 palette.mySin
                , Color.text <| lighten 0.45 palette.walnut
                , Transition.all
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
            , Transition.all
            , variation Disabled
                [ Color.background <| darken 0.15 palette.red
                , Color.text <| lighten 0.15 palette.red
                , Transition.all
                ]
            ]
        , Style.style SelectShorelineButton
            [ Font.typeface fontstack
            , Font.uppercase
            , Font.bold
            , Font.size 14
            , Font.lineHeight 1.4
            , Font.letterSpacing 2.33
            , Font.center
            , Color.text white
            , Color.background <| palette.hippieBlue
            , Border.rounded 8
            , Transition.all
            , variation Disabled
                [ Color.background <| darken 0.15 palette.mySin
                , Color.text <| lighten 0.45 palette.walnut
                , Transition.all
                ]
            ]
        , Style.style CloseIcon
            [ Style.cursor "pointer" ]
        , Style.style FontLeft [ Font.alignLeft ]
        , Style.style FontRight [ Font.alignRight ]
        , Style.style Hairline [ Color.background palette.chambray ]
        , Style.style MethodsResourcesBackgroundLine [ Color.background <| rgba 54 77 127 0.75 ]
        , Style.style CircleBullet
            [ Color.background white
            , Color.border white
            ]
        , Style.style (PL Line) 
            [ Color.background white
            ]
        , Style.style (PL Clicked) 
            [ Color.background red
            , Border.rounded 8
            ]
        , Style.style (PL RoadsPrivate) 
            [ Color.background <| Color.rgba 156 156 156 1
            , Border.rounded 8
            ]
        , Style.style (PL RoadsPublic) 
            [ Color.background <| Color.rgba 0 0 0 1
            , Border.rounded 8
            ]
        , Style.style (PL Groins) 
            [ Color.background <| Color.rgba 117 112 179 1
            , Border.rounded 8
            ]
        , Style.style (PL Revetment) 
            [ Color.background <| Color.rgba 27 158 119 1
            , Border.rounded 8
            ]
        , Style.style (PL Jetty) 
            [ Color.background <| Color.rgba 217 95 2 1
            , Border.rounded 8
            ]
        , Style.style (PL Accretion) 
            [ Color.background <| Color.rgba 209 255 115 1
            , Border.rounded 8
            ]
        , Style.style (PL Erosion) 
            [ Color.background <| Color.rgba 255 127 127 1
            , Border.rounded 8
            ]
        , Style.style (PL FZA) 
            [ Color.background <| Color.rgba 255 170 0 1
            , Border.rounded 8
            ]
        , Style.style (PL FZAE) 
            [ Color.background <| Color.rgba 255 170 0 1
            , Border.rounded 8
            ]
        , Style.style (PL FZAO) 
            [ Color.background <| Color.rgba 255 170 0 1
            , Border.rounded 8
            ]
        , Style.style (PL FZVE) 
            [ Color.background <| Color.rgba 230 0 0 1
            , Border.rounded 8
            ]
        , Style.style (PL CAT1) 
            [ Color.background <| Color.rgba 255 190 232 1
            , Border.rounded 8
            ]
        , Style.style (PL CAT2) 
            [ Color.background <| Color.rgba 255 0 197 1
            , Border.rounded 8
            ]
        , Style.style (PL CAT3) 
            [ Color.background <| Color.rgba 168 0 132 1
            , Border.rounded 8
            ]
        , Style.style (PL CAT4) 
            [ Color.background <| Color.rgba 197 0 255 1
            , Border.rounded 8
            ]
        , Style.style (Rbn LessThanZero) 
            [ Color.background <| Color.rgba 245 200 171 1
            , Border.rounded 8
            ]
        , Style.style (Rbn OneToFive) 
            [ Color.background <| Color.rgba 243 117 92 1
            , Border.rounded 8
            ]
        , Style.style (Rbn SixPlus) 
            [ Color.background <| Color.rgba 164 27 30 1
            , Border.rounded 8
            ]
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
