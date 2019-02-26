module View.FloodZone exposing (..)

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
        , fzFx : Animation.State
        , fzToggleFx : Animation.State
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
        , buttonView config.fzClicked paths.trianglePath config.fzToggleFx
        ] 
    , row NoStyle 
        ( renderAnimation config.fzFx 
          [width fill, paddingXY 0 0]
        ) 
        ( 
          [ case config.fzClicked of 
              Open -> 
                fzLegend paths 
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
                (text titleText |> within [ infoIconView (Just "...") ])
     

buttonView : Openness -> String -> Animation.State -> Element MainStyles Variations Msg
buttonView fzClicked togglePath fx =
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
                -- {src = paths.downArrow} 
                (Element.text "")
            , text "A   "
            , button
                (PL FZAE)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                -- {src = paths.downArrow} 
                (Element.text "")
            , text "AE   "
            , button
                (PL FZAO)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                -- {src = paths.downArrow} 
                (Element.text "")
            , text "AO    "
            , button
                (PL FZVE)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                -- {src = paths.downArrow} 
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