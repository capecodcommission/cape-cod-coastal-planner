module View.Inundation exposing (..)

import Animation
import View.ToggleButton as Toggle exposing (..)
import Types exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import View.Helpers exposing (title, adjustOnHeight, renderAnimation)
import Styles exposing (..)
import ShorelineLocation as SL


view :
  { config
        | fzClicked : Openness
        , inundationFx : Animation.State
        , inundationToggleFx : Animation.State
        , inundationClicked : Openness
        , sloshClicked : Openness
    } 
    -> Device 
    -> Paths 
    -> String 
    -> Msg 
    -> Element MainStyles Variations Msg
view config device paths titleText func =
  column NoStyle
    [paddingXY 0 0]
    [ row CloseIcon 
        [ verticalCenter, spread, width fill, paddingXY 10 20, onClick func ]
        [ headerView titleText 
        , buttonView config.inundationClicked paths.trianglePath config.inundationToggleFx
        ] 
    , row NoStyle 
        ( renderAnimation config.inundationFx 
          [width fill, paddingXY 0 0]
        ) 
        ( 
          [ case config.inundationClicked of 
              Open -> 
                erosionDetails config paths 
              Closed ->
                (el NoStyle [] empty )
          ] 
        ) 
    ]

headerView : String -> Element MainStyles Variations Msg
headerView titleText =
    header (Sidebar SidebarHeader) 
        [ height (px 45), width fill ] <| 
            h5 (Headings H5) 
                [ center, verticalCenter ] 
                (text titleText)
     

buttonView : Openness -> String -> Animation.State -> Element MainStyles Variations Msg
buttonView inundationClicked togglePath fx =
    el (Sidebar SidebarLeftToggle) 
        [ height (px 45), width (px 45)] <| 
            decorativeImage NoStyle
                ( renderAnimation fx
                    [height (px 35), width (px 35), moveDown 5]
                )
                { src = togglePath } 

fzLegend : Paths -> Element MainStyles Variations Msg
fzLegend paths =
    textLayout 
        (Zoi ZoiText) 
        [ verticalCenter, spacing 5, paddingXY 32 0 ]
        [ paragraph 
            NoStyle 
            []
            [ button
                (PL FZA)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                (Element.text "")
            , text "A   "
            , button
                (PL FZAE)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                (Element.text "")
            , text "AE   "
            , button
                (PL FZAO)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                (Element.text "")
            , text "AO    "
            , button
                (PL FZVE)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                (Element.text "")
            , text "VE"
            ]
        ]

infoIconView : Maybe String -> Element MainStyles Variations Msg
infoIconView maybeHelpText =
    case maybeHelpText of
        Just helpText ->
            circle 6 (ShowOutput OutputInfoIcon) 
                [ title helpText, alignRight, moveRight 18 ] <| 
                    el NoStyle [verticalCenter, center] (text "i")

        Nothing ->
            empty   


erosionDetails :
    { config
        | fzClicked : Openness
        , inundationFx : Animation.State
        , inundationToggleFx : Animation.State
        , sloshClicked : Openness
    } 
    -> Paths 
    -> Element MainStyles Variations Msg
erosionDetails config paths =
    textLayout (Zoi ZoiText)
        [ verticalCenter, spacing 0, paddingXY 20 0 ]
        [ paragraph CloseIcon [ onClick ToggleFZLayer ] 
            [ decorativeImage
                ( case config.fzClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Flood Zone" |> within [ infoIconView (Just "This layer displays flood zone areas denoted by 2013 data from FEMA.") ]
            ]
        , case config.fzClicked of 
            Open ->
                fzLegend paths
            Closed -> 
                (el NoStyle [] empty )
        , paragraph CloseIcon [onClick ToggleSloshLayer] 
            [ decorativeImage 
                ( case config.sloshClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "SLOSH" |> within [ infoIconView (Just "SLOSH mapping represents potential flooding from worst-case combinations of hurricane direction, forward speed, landfall point, and high astronomical tide, developed by the National Weather Service.") ]
            ]
        , case config.sloshClicked of 
            Open ->
                sloshLegend paths
            Closed -> 
                (el NoStyle [] empty )
        ]


sloshLegend : Paths -> Element MainStyles Variations Msg
sloshLegend paths =
    textLayout 
        (Zoi ZoiText) 
        [ verticalCenter, spacing 5, paddingXY 32 0 ]
        [ paragraph 
            NoStyle 
            []
            [ button
                (PL CAT1)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                (Element.text "")
            , text "CAT1   "
            , button
                (PL CAT2)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                (Element.text "")
            , text "CAT2   "
            , button
                (PL CAT3)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                (Element.text "")
            , text "CAT3    "
            , button
                (PL CAT4)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                (Element.text "")
            , text "CAT4"
            ]
        ]