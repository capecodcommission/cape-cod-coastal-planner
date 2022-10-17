module View.StormtidePathways exposing (..)
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
        | stpOpenness : Openness
        , stpToggleFx : Animation.State
        , stpFx : Animation.State
        , stp0ftClicked : Openness
        , stp1ftClicked : Openness
        , stp2ftClicked : Openness
        , stp3ftClicked : Openness
        , stp4ftClicked : Openness
        , stp5ftClicked : Openness
        , stp6ftClicked : Openness
        , stp7ftClicked : Openness
        , stp8ftClicked : Openness
        , stp9ftClicked : Openness
        , stp10ftClicked : Openness
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
      , buttonView paths.trianglePath config.stpToggleFx 
      ] 
    , row NoStyle 
        ( renderAnimation config.stpFx 
          [width fill, paddingXY 0 0]
        ) 
        ( 
          [ case config.stpOpenness of 
              Open -> 
                spDetails config paths 
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

spDetails :
    { config
        | stpOpenness : Openness
        , stpToggleFx : Animation.State
        , stpFx : Animation.State
        , stp0ftClicked : Openness
        , stp1ftClicked : Openness
        , stp2ftClicked : Openness
        , stp3ftClicked : Openness
        , stp4ftClicked : Openness
        , stp5ftClicked : Openness
        , stp6ftClicked : Openness
        , stp7ftClicked : Openness
        , stp8ftClicked : Openness
        , stp9ftClicked : Openness
        , stp10ftClicked : Openness
    } 
    -> Paths 
    -> Element MainStyles Variations Msg
spDetails config paths =
    textLayout (Zoi ZoiText)
        [ verticalCenter, spacing 10, paddingXY 20 0 ]        
        -- Point layer
        [ paragraph 
            NoStyle 
            [] 
            [ decorativeImage
                NoStyle
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Stormtide Pathways" |> within [ infoIconView (Just "This layer shows the location of points where, once the total water level is greater than the elevation of the Storm Tide Pathway, water will begin to flow. The locations of the storm tide pathways are based on the field surveys conducted during fieldwork and should be seen as an approximation only.") ]
            ]
        , paragraph 
            CloseIcon 
            [ paddingXY 35 0 ]
            -- [ el 
            --     ( case config.stp0ftClicked of 
            --         Open -> 
            --             (PL Clicked)
            --         Closed -> 
            --             (NoStyle)
            --     )  
            --     [ onClick (ToggleSTPLayer "0") ] <| text " 0 ft"
            -- , text "-"
            [ el 
                ( case config.stp1ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "1") ] <| text " 1 ft "
            , text "-"
            , el 
                ( case config.stp2ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "2") ] <| text " 2 "
            , text "-"
            , el 
                ( case config.stp3ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "3") ] <| text " 3 "
            , text "-"
            , el 
                ( case config.stp4ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "4") ] <| text " 4 "
            , text "-"
            , el 
                ( case config.stp5ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "5") ] <| text " 5 "
            , text "-"
            , el 
                ( case config.stp6ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "6") ] <| text " 6 "
            , text "-"
            , el 
                ( case config.stp7ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "7") ] <| text " 7 "
            , text "-"
            , el 
                ( case config.stp8ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "8") ] <| text " 8 "
            , text "-"
            , el 
                ( case config.stp9ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "9") ] <| text " 9 "
            , text "- "
            , el 
                ( case config.stp10ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "10") ] <| text "10 ft"
            ]
        , hairline (PL Line)
        -- Polygon layer
        , paragraph 
            NoStyle 
            [] 
            [ decorativeImage
                NoStyle
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Stormtide Plane Extent" |> within [ infoIconView (Just "This layer shows the approximate extent of flooding in one foot increments based on the latest lidar dataset available at the time the fieldwork was conducted and should be seen as an approximation only. Please see this resource for details: https://www.stormtides.org/") ]
            ]
        , paragraph 
            CloseIcon 
            [ paddingXY 35 0 ]
            -- [ el 
            --     ( case config.stp0ftClicked of 
            --         Open -> 
            --             (PL Clicked)
            --         Closed -> 
            --             (NoStyle)
            --     )  
            --     [ onClick (ToggleSTPLayer "0") ] <| text " 0 ft"
            -- , text "-"
            [ el 
                ( case config.stp1ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "1") ] <| text " 1 ft "
            , text "-"
            , el 
                ( case config.stp2ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "2") ] <| text " 2 "
            , text "-"
            , el 
                ( case config.stp3ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "3") ] <| text " 3 "
            , text "-"
            , el 
                ( case config.stp4ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "4") ] <| text " 4 "
            , text "-"
            , el 
                ( case config.stp5ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "5") ] <| text " 5 "
            , text "-"
            , el 
                ( case config.stp6ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "6") ] <| text " 6 "
            , text "-"
            , el 
                ( case config.stp7ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "7") ] <| text " 7 "
            , text "-"
            , el 
                ( case config.stp8ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "8") ] <| text " 8 "
            , text "-"
            , el 
                ( case config.stp9ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "9") ] <| text " 9 "
            , text "- "
            , el 
                ( case config.stp10ftClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )  
                [ onClick (ToggleSTPLayer "10") ] <| text "10 ft"
            ]
        , hairline (PL Line)
        
        -- , paragraph 
        --     NoStyle 
        --     [] 
        --     [ decorativeImage 
        --         NoStyle
        --         [height (px 20), width (px 20), moveDown 5, spacing 5] 
        --         {src = paths.downArrow}
        --     , text "Disconnected Roads" |> within [ infoIconView (Just "ESRI Network Analyst was used to determine which roads are disconnected from the network at each increment of sea level rise.") ]
        --     ]
        -- , paragraph 
        --     CloseIcon 
        --     [ paddingXY 30 0 ]
        --     [ el 
        --         ( case config.dr1ftClicked of 
        --             Open -> 
        --                 (PL Clicked)
        --             Closed -> 
        --                 (NoStyle)
        --         )  
        --         [ onClick (ToggleSLRLayer "1") ] <| text " 1ft -"
        --     , el 
        --         ( case config.dr2ftClicked of 
        --             Open -> 
        --                 (PL Clicked)
        --             Closed -> 
        --                 (NoStyle)
        --         )  
        --         [ onClick (ToggleSLRLayer "2") ] <| text " 2ft -"
        --     , el 
        --         ( case config.dr3ftClicked of 
        --             Open -> 
        --                 (PL Clicked)
        --             Closed -> 
        --                 (NoStyle)
        --         )  
        --         [ onClick (ToggleSLRLayer "3") ] <| text " 3ft -"
        --     , el 
        --         ( case config.dr4ftClicked of 
        --             Open -> 
        --                 (PL Clicked)
        --             Closed -> 
        --                 (NoStyle)
        --         )  
        --         [ onClick (ToggleSLRLayer "4") ] <| text " 4ft -"
        --     , el 
        --         ( case config.dr5ftClicked of 
        --             Open -> 
        --                 (PL Clicked)
        --             Closed -> 
        --                 (NoStyle)
        --         )  
        --         [ onClick (ToggleSLRLayer "5") ] <| text " 5ft -"
        --     , el 
        --         ( case config.dr6ftClicked of 
        --             Open -> 
        --                 (PL Clicked)
        --             Closed -> 
        --                 (NoStyle)
        --         )  
        --         [ onClick (ToggleSLRLayer "6") ] <| text " 6ft"
        --     ]
        -- , hairline (PL Line)
        -- , paragraph CloseIcon [onClick ToggleCritFac] 
        --     [ decorativeImage
        --         ( case config.critFacClicked of 
        --             Open -> 
        --                 (PL Clicked)
        --             Closed ->
        --                 (NoStyle)
        --         ) 
        --         [height (px 20), width (px 20), moveDown 5, spacing 5] 
        --         {src = paths.downArrow}
        --     , text "Critical Facilities" |> within [ infoIconView (Just "Critical facilities are identified by towns through their hazard mitigation planning process and includes a variety of important local departments and structures.") ]
        --     ]
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