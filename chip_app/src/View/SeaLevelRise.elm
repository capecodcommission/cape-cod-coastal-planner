module View.SeaLevelRise exposing (..)

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
        | slrOpenness : Openness
        , slrToggleFx : Animation.State
        , critFacClicked : Openness
        , slrFx : Animation.State
        , dr1ftClicked : Openness
        , slr2ftClicked : Openness
        , slr1ftClicked : Openness
        , slr3ftClicked : Openness
        , slr4ftClicked : Openness
        , slr5ftClicked : Openness
        , slr6ftClicked : Openness
        , dr2ftClicked : Openness
        , dr3ftClicked : Openness
        , dr4ftClicked : Openness
        , dr5ftClicked : Openness
        , dr6ftClicked : Openness
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
      , buttonView paths.trianglePath config.slrToggleFx 
      ] 
    , row NoStyle 
        ( renderAnimation config.slrFx 
          [width fill, paddingXY 0 0]
        ) 
        ( 
          [ case config.slrOpenness of 
              Open -> 
                slrDetails config paths 
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
     

buttonView : String -> Animation.State -> Element MainStyles Variations Msg
buttonView togglePath fx =
    el (Sidebar SidebarLeftToggle) 
        [ height (px 45), width (px 45)] <| 
            decorativeImage NoStyle 
                ( renderAnimation fx
                    [height (px 35), width (px 35), moveDown 5]
                )
                { src = togglePath } 

slrDetails :
    { config
        | critFacClicked : Openness
        , slrFx : Animation.State
        , dr1ftClicked : Openness
        , slr2ftClicked : Openness
        , slr1ftClicked : Openness
        , slr3ftClicked : Openness
        , slr4ftClicked : Openness
        , slr5ftClicked : Openness
        , slr6ftClicked : Openness
        , dr2ftClicked : Openness
        , dr3ftClicked : Openness
        , dr4ftClicked : Openness
        , dr5ftClicked : Openness
        , dr6ftClicked : Openness
    } 
    -> Paths 
    -> Element MainStyles Variations Msg
slrDetails config paths =
    textLayout (Zoi ZoiText)
        [ verticalCenter, spacing 10, paddingXY 20 0 ]
        [ paragraph 
            NoStyle 
            [] 
            [ decorativeImage
                NoStyle
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Sea Level Rise" |> within [ infoIconView (Just "Sea level rise data was derived from Digital Elevation Model data collected through LiDAR in 2011, and is shown as a simple representation of a change in elevation - a 'bathtub' model.") ]
            , paragraph 
                CloseIcon 
                [ paddingXY 35 0 ]
                [ el 
                    ( case config.slr1ftClicked of 
                        Open -> 
                            (PL Clicked)
                        Closed -> 
                            (NoStyle)
                    )  
                    [ onClick (ToggleSLRLayer "1") ] <| text " 1ft -"
                , el 
                    ( case config.slr2ftClicked of 
                        Open -> 
                            (PL Clicked)
                        Closed -> 
                            (NoStyle)
                    )  
                    [ onClick (ToggleSLRLayer "2") ] <| text " 2ft -"
                , el 
                    ( case config.slr3ftClicked of 
                        Open -> 
                            (PL Clicked)
                        Closed -> 
                            (NoStyle)
                    )  
                    [ onClick (ToggleSLRLayer "3") ] <| text " 3ft -"
                , el 
                    ( case config.slr4ftClicked of 
                        Open -> 
                            (PL Clicked)
                        Closed -> 
                            (NoStyle)
                    )  
                    [ onClick (ToggleSLRLayer "4") ] <| text " 4ft -"
                , el 
                    ( case config.slr5ftClicked of 
                        Open -> 
                            (PL Clicked)
                        Closed -> 
                            (NoStyle)
                    )  
                    [ onClick (ToggleSLRLayer "5") ] <| text " 5ft -"
                , el 
                    ( case config.slr6ftClicked of 
                        Open -> 
                            (PL Clicked)
                        Closed -> 
                            (NoStyle)
                    )  
                    [ onClick (ToggleSLRLayer "6") ] <| text " 6ft"
                ]
            ]
        , hairline (PL Line)
        , paragraph 
            NoStyle 
            [] 
            [ decorativeImage 
                NoStyle
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Disconnected Roads" |> within [ infoIconView (Just "ESRI Network Analyst was used to determine which roads are disconnected from the network at each increment of sea level rise.") ]
            , paragraph 
                CloseIcon 
                [ paddingXY 30 0 ]
                [ el 
                    ( case config.dr1ftClicked of 
                        Open -> 
                            (PL Clicked)
                        Closed -> 
                            (NoStyle)
                    )  
                    [ onClick (ToggleSLRLayer "1") ] <| text " 1ft -"
                , el 
                    ( case config.dr2ftClicked of 
                        Open -> 
                            (PL Clicked)
                        Closed -> 
                            (NoStyle)
                    )  
                    [ onClick (ToggleSLRLayer "2") ] <| text " 2ft -"
                , el 
                    ( case config.dr3ftClicked of 
                        Open -> 
                            (PL Clicked)
                        Closed -> 
                            (NoStyle)
                    )  
                    [ onClick (ToggleSLRLayer "3") ] <| text " 3ft -"
                , el 
                    ( case config.dr4ftClicked of 
                        Open -> 
                            (PL Clicked)
                        Closed -> 
                            (NoStyle)
                    )  
                    [ onClick (ToggleSLRLayer "4") ] <| text " 4ft -"
                , el 
                    ( case config.dr5ftClicked of 
                        Open -> 
                            (PL Clicked)
                        Closed -> 
                            (NoStyle)
                    )  
                    [ onClick (ToggleSLRLayer "5") ] <| text " 5ft -"
                , el 
                    ( case config.dr6ftClicked of 
                        Open -> 
                            (PL Clicked)
                        Closed -> 
                            (NoStyle)
                    )  
                    [ onClick (ToggleSLRLayer "6") ] <| text " 6ft"
                ]
            ]
        , hairline (PL Line)
        , paragraph CloseIcon [onClick ToggleCritFac] 
            [ decorativeImage
                ( case config.critFacClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed ->
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Critical Facilities" |> within [ infoIconView (Just "Critical facilities are identified by towns through their hazard mitigation planning process and includes a variety of important local departments and structures.") ]
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