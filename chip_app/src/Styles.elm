module Styles exposing (..)

import Color as OriColor exposing (Color, hsla, rgba, toHsla, toRgba)
import Color.Manipulate as CEx
import Style exposing (..)
import Style.Color as StyleColor
import Style.Border as Border
import Style.Font as Font
import Style.Transition as Transition
import Style.Scale as Scale
import Style.Background as Background
import Element.Input as Input exposing (ChoiceState)
import Element exposing (Device)
import View.Helpers exposing (adjustOnHeight, adjustOnWidth)
import Html exposing (b)


scaled =
    Scale.modular 18 1.375


{-| Palette colors named using <http://chir.ag/projects/name-that-color>
-}
palette =
    { elephant = createStyleColor 10 40 51
    , chambray = createStyleColor 54 77 127
    , havelockBlue = createStyleColor 85 126 216
    , malibu = createStyleColor 93 151 255
    , mySin = createStyleColor 255 182 18
    , persimmon = createStyleColor 255 85 85
    , walnut = createStyleColor 108 67 26
    , red = createStyleColor 255 18 18
    , hippieBlue = createStyleColor 83 168 172
    , mediumRedViolet = createStyleColor 165 56 165
    , apple = createStyleColor 112 173 71
    , cadetBlue = createStyleColor 155 166 191
    , blueStone = createStyleColor 25 52 70
    , alto = createStyleColor 218 218 218
    , shadedScale = createStyleColor 41 48 58
    }
colorPalette =
    { elephant = createOriColor 10 40 51
    , chambray = createOriColor 54 77 127
    , havelockBlue = createOriColor 85 126 216
    , malibu = createOriColor 93 151 255
    , mySin = createOriColor 255 182 18
    , persimmon = createOriColor 255 85 85
    , walnut = createOriColor 108 67 26
    , red = createOriColor 255 18 18
    , hippieBlue = createOriColor 83 168 172
    , mediumRedViolet = createOriColor 165 56 165
    , apple = createOriColor 112 173 71
    , cadetBlue = createOriColor 155 166 191
    , blueStone = createOriColor 25 52 70
    , alto = createOriColor 218 218 218
    , shadedScale = createOriColor 41 48 58
    }
styleWhite : Style.Color
styleWhite =
    createStyleColor 255 255 255
styleRed : Style.Color
styleRed =
    createStyleColor 255 0 0
styleOrange : Style.Color
styleOrange =
    createStyleColor 255 215 0
styleBlack : Style.Color
styleBlack =
    createStyleColor 0 0 0
scaleFrom255 : Int -> Float
scaleFrom255 c =
    toFloat c / 255
createStyleColor : Int -> Int -> Int -> Style.Color
createStyleColor r g b =
     Style.rgb (scaleFrom255 r) (scaleFrom255 g) (scaleFrom255 b)

createStyleColorWithAlpha : Int -> Int -> Int -> Float -> Style.Color
createStyleColorWithAlpha r g b a =
     Style.rgba (scaleFrom255 r) (scaleFrom255 g) (scaleFrom255 b) a

createOriColor : Int -> Int -> Int -> OriColor.Color
createOriColor r g b =
     OriColor.rgb (scaleFrom255 r) (scaleFrom255 g) (scaleFrom255 b) 


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
    | OutputValueMedium
    | OutputSmall
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
    | Category1
    | Category2
    | Category3
    | Category4
    | Category5
    | Category6
    | Category7
    | Category8
    | Category9

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
fadeColor : Float -> OriColor.Color -> Style.Color
fadeColor alpha color =
    let
        c = OriColor.toRgba color
    in
    Style.rgba c.red c.green c.blue alpha

darkenColor : Float -> OriColor.Color -> Style.Color
darkenColor val color =
    let
        c = OriColor.toRgba color
    in
    OriColor.fromRgba c
        |> CEx.darken val
        |> convertColor

convertColor : OriColor.Color -> Style.Color
convertColor color =
    OriColor.toRgba color
        |> (\{ red, green, blue, alpha } ->
                Style.rgba red green blue alpha
           )

        
stylesheet : Device -> StyleSheet MainStyles Variations
stylesheet device =
    Style.styleSheet
        [ Style.style NoStyle []
        , Style.style Test [ StyleColor.background palette.mySin ]
        , Style.style MainContent
            [ StyleColor.background palette.elephant
            , Style.hover
                [ Style.cursor "default" ]
            ]
        , Style.style (Header HeaderBackground)
            [ StyleColor.background palette.blueStone
            ]
        , Style.style (Header HeaderBackgroundRounded)
            [ StyleColor.background palette.blueStone
            , Border.rounded 20.0
            ]
        , Style.style (Header HeaderTitle)
            [ StyleColor.text styleWhite
            , Font.size 24.0
            , Font.bold
            , Font.typeface fontstack
            , Font.letterSpacing 1.0
            ]
        , Style.style (Header ScaleHeader)
            [ StyleColor.text styleWhite
            , Font.size 18.0
            , Font.bold
            , Font.typeface fontstack
            , Font.letterSpacing 1.0
            ]
        , Style.style (Header HeaderMenu)
            [ StyleColor.background <| createStyleColorWithAlpha 83 168 172 0.4
            , StyleColor.text styleWhite
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
                [ StyleColor.text palette.persimmon
                ]
            ]
        , Style.style (Header HeaderSubMenu)
            [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 0.9
            , Style.pseudo "before"
                [ StyleColor.border styleWhite
                ]
            ]
        , Style.style (Header HeaderMenuItem)
            [ StyleColor.text styleWhite
            , Font.size 18.0
            , Font.typeface fontstack
            , Style.hover
                -- [ StyleColor.background <| fadeColor -0.7 colorPalette.havelockBlue ]
                [ StyleColor.background <| createStyleColorWithAlpha 85 126 216 0.7 ]
            , variation InputIdle
                [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 0.7 ]
            , variation InputSelected
                [ StyleColor.text palette.havelockBlue
                , StyleColor.background <| createStyleColorWithAlpha 0 0 0 0.7
                , Style.hover
                    [ StyleColor.text styleWhite ]
                ]
            , variation InputFocused []
            , variation InputSelectedInBox
                [ Style.hover
                    [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 0.0 ]
                ]
            , variation LastMenuItem
                [ Border.roundBottomLeft 8.0
                , Border.roundBottomRight 8.0
                ]
            ]
        , Style.style (Header HeaderMenuError)
            [ StyleColor.text palette.persimmon
            , Font.size 14.0
            , Font.typeface fontstack
            ]
        , Style.style (Baseline BaselineInfoBtn)
            [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 0
            , StyleColor.text styleWhite
            , StyleColor.border styleWhite
            , Font.size 22.0
            , Font.typeface fontstack
            , Border.rounded 50.0
            , Border.all 2
            , Transition.all
            , Style.hover
                [ StyleColor.text palette.mySin
                , StyleColor.border palette.mySin
                , Transition.all
                ]
            ] 
        , Style.style MenuButton
            [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 0
            , StyleColor.text styleWhite
            , Font.size 30.0
            , Font.typeface fontstack
            , Transition.all
            , Style.hover
                [ StyleColor.text palette.mySin
                , StyleColor.border palette.mySin
                , Transition.all
                ]
            ]    
        , Style.style (Baseline BaselineInfoBtnClicked)
            [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 0
            , StyleColor.text styleOrange
            , StyleColor.border styleOrange
            , Font.size 22.0
            , Font.typeface fontstack
            , Border.rounded 50.0
            , Border.all 2
            , Transition.all
            , Style.hover
                [ StyleColor.text palette.mySin
                , StyleColor.border palette.mySin
                , Transition.all
                ]
            ]      
        , Style.style (Baseline BaselineInfoHeader)
            [ StyleColor.background palette.blueStone
            , StyleColor.text styleWhite
            , Font.typeface fontstack
            , Border.roundTopLeft 4
            , Border.roundTopRight 4
            ]
        , Style.style (Baseline BaselineInfoText)
            [ StyleColor.text styleWhite
            , Font.size 16
            , Font.typeface fontstack
            , Font.lineHeight 1.29
            ]
        , Style.style (Baseline BaselineInfoImage)
            [ Background.gradientRight [Background.step styleWhite, Background.step styleBlack]
            ]
        , Style.style (AddStrategies StrategiesSidebar)
            [ StyleColor.text styleWhite
            , StyleColor.border styleWhite
            , Border.right 1
            , Border.solid
            , Font.typeface fontstack
            , Font.lineHeight 1.4
            ]
        , Style.style (AddStrategies StrategiesSidebarHeader)
            [ StyleColor.background palette.hippieBlue
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
            [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 0
            , StyleColor.text styleWhite
            , Font.alignLeft
            , Font.typeface fontstack
            ]
        , Style.style (AddStrategies StrategiesSidebarListBtnDisabled)
            [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 0
            , StyleColor.text <| createStyleColorWithAlpha 255 255 255 0.5
            , Font.alignLeft
            , Font.typeface fontstack
            ]
        , Style.style (AddStrategies StrategiesSidebarListBtnSelected)
            -- [ StyleColor.background <| fadeColor -0.7 colorPalette.havelockBlue
            [ StyleColor.background <| createStyleColorWithAlpha 85 126 216 0.7 
            , StyleColor.text styleWhite
            , Font.alignLeft
            , Font.typeface fontstack
            ]
        , Style.style (AddStrategies StrategiesSidebarFooter)
            [ StyleColor.background styleBlack
            , Border.roundBottomLeft 4
            ]
        , Style.style (AddStrategies StrategiesDetailsHeader)
            [ StyleColor.background palette.blueStone
            , StyleColor.text styleWhite
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
            [ StyleColor.text styleWhite
            , Font.typeface fontstack
            , Font.size 10
            , Font.bold
            , Font.letterSpacing 1.44
            , variation Disabled
                [ StyleColor.text palette.malibu
                ]
            ]
        , Style.style (AddStrategies StrategiesDetailsCategoryCircle)
            [ StyleColor.background styleWhite
            , StyleColor.border styleWhite
            , Border.all 1.5
            , Border.solid
            , variation Secondary
                [ StyleColor.background styleWhite
                , StyleColor.border styleWhite
                ]
            , variation Tertiary
                [ StyleColor.background styleWhite
                , StyleColor.border styleWhite
                ]
            , variation Disabled
                [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 0
                , StyleColor.border palette.alto
                ]
            ]
        , Style.style (AddStrategies StrategiesDetailsMain)
            [ StyleColor.text styleWhite
            , Font.typeface fontstack
            , Style.hover
                [ Style.cursor "default" ]
            ]
        , Style.style (AddStrategies StrategiesDetailsHeading)
            [ StyleColor.text palette.hippieBlue
            , Font.typeface fontstack
            , Font.size (scaled 1)
            , Font.weight 800
            , Font.lineHeight 1.4
            , variation Secondary
                [ StyleColor.text palette.hippieBlue
                ]
            ]
        , Style.style (AddStrategies StrategiesDetailsHazards)
            [ Font.size 14
            , Font.letterSpacing 1.24
            , Font.weight 400
            , Font.typeface fontstack
            , StyleColor.text styleWhite
            , variation Disabled
                [ StyleColor.text <| createStyleColorWithAlpha 255 255 255 0.5 ]
            ]
        , Style.style (AddStrategies StrategiesDetailsHazardsCircle)
            [ StyleColor.border styleWhite
            , Border.all 1.2
            , Border.solid
            , variation Disabled
                [ StyleColor.border <| createStyleColorWithAlpha 255 255 255 0.5 ]
            ]
        , Style.style (AddStrategies StrategiesDetailsBenefits)
            [ Font.size 11
            , Font.weight 400
            , Font.typeface fontstack
            , StyleColor.text styleWhite
            , variation Disabled
                [ StyleColor.text <| createStyleColorWithAlpha 255 255 255 0.5 ]
            ]
        , Style.style (AddStrategies StrategiesDetailsDescription)
            [ StyleColor.text styleWhite
            , Font.typeface fontstack
            , Font.size 16
            , Font.lineHeight 1.4
            , variation Secondary
                [ StyleColor.text palette.havelockBlue
                , Font.bold
                ]
            ]
        , Style.style (AddStrategies StrategiesDetailsTextList)
            [ StyleColor.text styleWhite
            , Font.typeface fontstack
            , Font.size 16
            , Font.lineHeight 1.5
            , variation Secondary
                [ StyleColor.text palette.havelockBlue
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
            [ StyleColor.text palette.havelockBlue
            , Font.bold
            , Font.typeface fontstack
            ]
        , Style.style (Zoi ZoiStat)
            [ Font.size 20
            , StyleColor.text palette.havelockBlue
            , Font.letterSpacing 1
            , Font.typeface fontstack
            ]
        , Style.style (ShowOutput OutputToggleBtn)
            [ Font.letterSpacing 2.33
            , StyleColor.background palette.alto
            , Font.typeface fontstack
            ]
        , Style.style (ShowOutput OutputToggleLbl)
            [ Font.center
            , Font.letterSpacing 2.33
            , Font.typeface fontstack
            , StyleColor.background <| createStyleColorWithAlpha 19 39 52 1
            ]
        , Style.style (ShowOutput OutputHeader)
            [ StyleColor.background <| createStyleColorWithAlpha 19 39 52 1
            ]
        , Style.style (ShowOutput OutputDivider)
            [ Border.right 2
            , Border.solid
            , StyleColor.border styleWhite
            ]
        , Style.style (ShowOutput OutputH6Bold)
            [ Font.size <| scaled 1
            , Font.weight 500
            , Font.typeface fontstack
            ]
        , Style.style (ShowOutput OutputValueMedium)
            [ Font.size 16
            , Font.weight 100
            , Font.typeface fontstack
            , StyleColor.text <| createStyleColorWithAlpha 255 255 255 0.5
            , variation Secondary
                [ StyleColor.text palette.mySin ]
            , variation Tertiary
                [ StyleColor.text palette.havelockBlue ]
            ]
        , Style.style (ShowOutput OutputSmall)
            [ Font.size 12
            , Font.weight 100
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
            , StyleColor.text styleWhite
            , Font.weight 600
            , StyleColor.background palette.hippieBlue
            , variation Secondary
                [ StyleColor.background palette.hippieBlue ]
            ]
        , Style.style (ShowOutput OutputMultiImpact)
            [ Font.size 11
            , Font.lineHeight 1.4
            , Font.center
            , Font.typeface fontstack
            , StyleColor.text palette.chambray
            , StyleColor.background <| createStyleColorWithAlpha 255 255 255 0.9
            , Border.solid
            , StyleColor.border palette.chambray
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
                [ StyleColor.background <| createStyleColorWithAlpha 41 48 58 0.9
                , StyleColor.text <| createStyleColorWithAlpha 255 255 255 0.5
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
            , StyleColor.text <| createStyleColorWithAlpha 255 255 255 0.5
            , variation Secondary
                [ StyleColor.text palette.mySin ]
            , variation Tertiary
                [ StyleColor.text palette.havelockBlue ]
            ]
        , Style.style (ShowOutput OutputValueLbl)
            [ Font.size 12
            , Font.letterSpacing 2.33
            , Font.typeface fontstack
            , StyleColor.text <| createStyleColorWithAlpha 255 255 255 0.5
            , variation Secondary
                [ StyleColor.text palette.mySin ]
            , variation Tertiary
                [ StyleColor.text palette.havelockBlue ]
            ]
        , Style.style (ShowOutput OutputValueBox)
            [ Border.all 2
            , Border.solid
            , Border.rounded 8
            , StyleColor.border <| createStyleColorWithAlpha 255 255 255 0.5
            , StyleColor.background <| createStyleColorWithAlpha 0 0 0 0
            , Font.weight 500
            , Font.typeface fontstack
            , variation Secondary
                [ StyleColor.background palette.mySin 
                , StyleColor.border palette.mySin
                , StyleColor.text <| createStyleColorWithAlpha 0 0 0 0.9
                ]
            , variation Tertiary
                [ StyleColor.background palette.havelockBlue 
                , StyleColor.border palette.havelockBlue
                ]
            ]
        , Style.style (ShowOutput OutputInfoIcon)
            [ StyleColor.background palette.cadetBlue
            , StyleColor.text styleWhite
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
            [ StyleColor.background palette.chambray
            , StyleColor.text styleWhite
            ]
        , Style.style (Modal ModalBackground)
            [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 0.59 ]
        , Style.style (Modal MethodsResourcesBackground)
            [ StyleColor.background <| createStyleColorWithAlpha 25 52 70 0.75 ]
        , Style.style (Modal ModalContainer)
            [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 0.9
            , Border.rounded 4
            ]
        , Style.style (Modal IntroHeader)
            [ StyleColor.background <| createStyleColorWithAlpha 41 84 112 1 
            , Border.rounded 4
            ]
        , Style.style (Modal IntroBody)
            [ StyleColor.background palette.blueStone
            , Border.rounded 4     
            ]
        , Style.style (Modal IntroWelcome)
            [ StyleColor.text styleWhite
            , Font.size 20
            , Font.justify
            , Font.typeface fontstack
            ]
        , Style.style (Modal IntroDisclaimer)
            [ StyleColor.text palette.alto
            , Font.size 15
            , Font.justify
            , Font.typeface fontstack
            ]
        , Style.style (Modal MethodsResourcesModal)
            [ StyleColor.text styleWhite
            , Font.size 14
            , Font.typeface fontstack
            , Font.justify
            ]
        , Style.style (Modal MethodsResourcesModalHeading)
            [ StyleColor.text palette.hippieBlue
            , Font.size 18
            , Font.center
            , Font.weight 800
            , Font.typeface fontstack
            ]
        , Style.style (Sidebar SidebarContainer)
            [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 0.9
            , StyleColor.text styleWhite
            , Font.typeface fontstack
            ]
        , Style.style MenuContainer
            [ StyleColor.background palette.blueStone
            , StyleColor.text styleWhite
            , Font.typeface fontstack
            , Font.size 25
            ]
        , Style.style (Sidebar SidebarHeader)
            [ StyleColor.background palette.blueStone
            ]
        , Style.style (Sidebar SidebarToggle)
            [ StyleColor.background palette.blueStone
            , Border.roundTopLeft 36
            , Border.roundBottomLeft 36
            , Style.cursor "pointer"
            ]
        , Style.style (Sidebar SidebarFooter)
            [ StyleColor.background styleBlack
            , Font.typeface fontstack
            ]
        , Style.style (Sidebar SidebarLeftToggle)
            [ StyleColor.background palette.blueStone
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
            , StyleColor.text palette.walnut
            , StyleColor.background palette.mySin
            , Border.rounded 8
            , Transition.all
            , variation Disabled
                [ StyleColor.background <| darkenColor 0.15 colorPalette.mySin
                , StyleColor.text <| darkenColor -0.45 colorPalette.walnut
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
            , StyleColor.text styleWhite
            , StyleColor.background palette.red
            , Border.rounded 8
            , Transition.all
            , variation Disabled
                [ StyleColor.background <| darkenColor 0.15 colorPalette.red
                , StyleColor.text <| darkenColor -0.15 colorPalette.red
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
            , StyleColor.text styleWhite
            , StyleColor.background <| palette.hippieBlue
            , Border.rounded 8
            , Transition.all
            , variation Disabled
                [ StyleColor.background <| darkenColor 0.15 colorPalette.mySin
                , StyleColor.text <| darkenColor 0.45 colorPalette.walnut
                , Transition.all
                ]
            ]
        , Style.style CloseIcon
            [ Style.cursor "pointer" ]
        , Style.style FontLeft [ Font.alignLeft ]
        , Style.style FontRight [ Font.alignRight ]
        , Style.style Hairline [ StyleColor.background palette.chambray ]
        , Style.style MethodsResourcesBackgroundLine [ StyleColor.background <| createStyleColorWithAlpha 54 77 127 0.75 ]
        , Style.style CircleBullet
            [ StyleColor.background styleWhite
            , StyleColor.border styleWhite
            ]
        , Style.style (PL Line) 
            [ StyleColor.background styleWhite
            ]
        , Style.style (PL Clicked) 
            [ StyleColor.background styleRed
            , Border.rounded 8
            ]
        , Style.style (PL RoadsPrivate) 
            [ StyleColor.background <| createStyleColorWithAlpha 156 156 156 1
            , Border.rounded 8
            ]
        , Style.style (PL RoadsPublic) 
            [ StyleColor.background <| createStyleColorWithAlpha 0 0 0 1
            , Border.rounded 8
            ]
        , Style.style (PL Groins) 
            [ StyleColor.background <| createStyleColorWithAlpha 117 112 179 1
            , Border.rounded 8
            ]
        , Style.style (PL Revetment) 
            [ StyleColor.background <| createStyleColorWithAlpha 27 158 119 1
            , Border.rounded 8
            ]
        , Style.style (PL Jetty) 
            [ StyleColor.background <| createStyleColorWithAlpha 217 95 2 1
            , Border.rounded 8
            ]
        , Style.style (PL Accretion) 
            [ StyleColor.background <| createStyleColorWithAlpha 209 255 115 1
            , Border.rounded 8
            ]
        , Style.style (PL Erosion) 
            [ StyleColor.background <| createStyleColorWithAlpha 255 127 127 1
            , Border.rounded 8
            ]
        , Style.style (PL FZA) 
            [ StyleColor.background <| createStyleColorWithAlpha 255 170 0 1
            , Border.rounded 8
            ]
        , Style.style (PL FZAE) 
            [ StyleColor.background <| createStyleColorWithAlpha 255 170 0 1
            , Border.rounded 8
            ]
        , Style.style (PL FZAO) 
            [ StyleColor.background <| createStyleColorWithAlpha 255 170 0 1
            , Border.rounded 8
            ]
        , Style.style (PL FZVE) 
            [ StyleColor.background <| createStyleColorWithAlpha 230 0 0 1
            , Border.rounded 8
            ]
        , Style.style (PL CAT1) 
            [ StyleColor.background <| createStyleColorWithAlpha 255 190 232 1
            , Border.rounded 8
            ]
        , Style.style (PL CAT2) 
            [ StyleColor.background <| createStyleColorWithAlpha 255 0 197 1
            , Border.rounded 8
            ]
        , Style.style (PL CAT3) 
            [ StyleColor.background <| createStyleColorWithAlpha 168 0 132 1
            , Border.rounded 8
            ]
        , Style.style (PL CAT4) 
            [ StyleColor.background <| createStyleColorWithAlpha 197 0 255 1
            , Border.rounded 8
            ]
        , Style.style (Rbn LessThanZero) 
            [ StyleColor.background <| createStyleColorWithAlpha 245 200 171 1
            , Border.rounded 8
            ]
        , Style.style (Rbn OneToFive) 
            [ StyleColor.background <| createStyleColorWithAlpha 243 117 92 1
            , Border.rounded 8
            ]
        , Style.style (Rbn SixPlus) 
            [ StyleColor.background <| createStyleColorWithAlpha 164 27 30 1
            , Border.rounded 8
            ]
        , Style.style (PL Category1) 
            [ StyleColor.background <| createStyleColorWithAlpha 255 255 127 1
            , Border.rounded 4
            ]
        , Style.style (PL Category2) 
            [ StyleColor.background <| createStyleColorWithAlpha 182 245 88 1
            , Border.rounded 4
            ]
        , Style.style (PL Category3) 
            [ StyleColor.background <| createStyleColorWithAlpha 111 235 43 1
            , Border.rounded 4
            ]
        , Style.style (PL Category4) 
            [ StyleColor.background <| createStyleColorWithAlpha 58 214 39 1
            , Border.rounded 4
            ]
        , Style.style (PL Category5) 
            [ StyleColor.background <| createStyleColorWithAlpha 61 184 103 1
            , Border.rounded 4
            ]
        , Style.style (PL Category6) 
            [ StyleColor.background <| createStyleColorWithAlpha 39 156 154 1
            , Border.rounded 4
            ]
        , Style.style (PL Category7) 
            [ StyleColor.background <| createStyleColorWithAlpha 31 108 159 1
            , Border.rounded 4
            ]
        , Style.style (PL Category8) 
            [ StyleColor.background <| createStyleColorWithAlpha 25 64 140 1
            , Border.rounded 4
            ]
        , Style.style (PL Category9) 
            [ StyleColor.background <| createStyleColorWithAlpha 7 7 121 1
            , Border.rounded 4
            ]
        ]


headingStyle scale =
    [ StyleColor.text styleWhite
    , Font.size (scaled scale)
    , Font.typeface fontstack
    , Font.weight 300
    , Font.lineHeight 1.4
    , variation Secondary
        [ StyleColor.text palette.havelockBlue
        , Font.weight 400
        ]
    ]
