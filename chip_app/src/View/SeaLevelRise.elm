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
            , text "Sea Level Rise" |> within [ infoIconView (Just "To map the predicted sea level rise for Barnstable County (Cape Cod) the most accurate elevation data was obtained and adjusted to account for vertical datum variations as well as localized tidal information. This adjusted data, was then separated into areas below sea level and into 1 ft increments (up to 6ft) above sea level. Topographical elevation data was sourced from remotely sensed LiDAR data which was collected in the Winter and Spring of 2011, while no snow was on the ground, rivers were at or below normal levels and within 90 minutes of the daily predicted low tide. For Barnstable County, the LiDAR was processed and classified to meet a bare earth Fundamental Vertical Accuracy (FVA) of 18.13 cm at a 95% confidence level. The topological elevation data was in a grid format, as a Digital Elevation Model (DEM) with a cell size of 1 meter. In order to incorporate tidal variability within an area when mapping sea level rise, a “modeled” surface (or raster) is needed that represents this variability. In addition, this surface must be represented in the same vertical datum as the elevation data. To account for the datum and tidal differences across the county the DEM was adjusted to localized conditions using the NOAA VDatum (Verticle Datum Transformation) software. The VDatum program was used to convert a 500m grid of points that covered the entire Barnstable County area from the source of North American Vertical Datum 88 (NAVD 88) to Mean Higher High Water (MHHW). MHHW is the average of the higher high water height of each tidal day observed over the National Tidal Datum Epoch. The 500m MHHW grid was then interpolated into a 1m grid that was identical in spatial extent to the 1m topographical DEM. The topographical DEM was then adjusted on a cell-by-cell basis to account for the MHHW elevation. ") ]
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
            , text "Discnctd Roads" |> within [ infoIconView (Just "ESRI Network Analyst was used to determine which roads are disconnected from the network at each increment of Sea Level Rise. The network was created using the 2013 Navteq road dataset and service areas generated from a facility located on a high elevation. Thus, any roadway that was seperated from this facility by a barrier caused by flooding was identified by the software and would be considered disconnected.") ]
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
            , text "Critical Facilities" |> within [ infoIconView (Just "Critical facilities are the following: airport, bridge, child care, church, military, community center, municipal, fire station, hospital, library, marina, police, Red Cross, school, senior center, wastewater treatment plant, solid waste, utility, vet and water department. ") ]
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