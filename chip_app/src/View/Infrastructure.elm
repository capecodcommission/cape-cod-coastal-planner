module View.Infrastructure exposing (..)

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
        , slr2ftClicked : Openness
        , infraOpenness : Openness
        , infraFx : Animation.State
        , infraToggleFx : Animation.State
        , mopClicked : Openness
        , pprClicked : Openness
        , spClicked : Openness
        , cdsClicked : Openness
        , structuresClicked : Openness
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
      , buttonView paths.trianglePath config.infraToggleFx 
      ] 
    , row NoStyle 
        ( renderAnimation config.infraFx 
          [width fill, paddingXY 0 0]
        ) 
        ( 
          [ case config.infraOpenness of 
              Open -> 
                infraDetails config paths 
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

infraDetails :
    { config
        | critFacClicked : Openness
        , slrFx : Animation.State
        , slr2ftClicked : Openness
        , mopClicked : Openness
        , pprClicked : Openness
        , spClicked : Openness
        , cdsClicked : Openness
        , structuresClicked : Openness
    } 
    -> Paths 
    -> Element MainStyles Variations Msg
infraDetails config paths =
    textLayout (Zoi ZoiText)
        [ verticalCenter, spacing 0, paddingXY 20 0 ]
        [ paragraph CloseIcon [ onClick ToggleMOPLayer ] 
            [ decorativeImage
                ( case config.mopClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Municipal Properties" |> within [ infoIconView (Just "This layer displays all parcels owned by local and regional government on Cape Cod.") ]
            ]
        , paragraph CloseIcon [onClick TogglePPRLayer] 
            [ decorativeImage 
                ( case config.pprClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed -> 
                        (NoStyle)
                )
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Public and Private Roads" |> within [ infoIconView (Just "This layer displays all public and private roads in Barnstable County.") ]
            ]
        , case config.pprClicked of 
            Open ->
                pprLegend paths
            Closed -> 
                (el NoStyle [] empty )
        , paragraph CloseIcon [onClick ToggleSPLayer] 
            [ decorativeImage
                ( case config.spClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed ->
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Sewered Parcels" |> within [ infoIconView (Just "Barnstable County parcels which are served by sewer systems.") ]
            ]
        , paragraph CloseIcon [onClick ToggleCDSLayer] 
            [ decorativeImage
                ( case config.cdsClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed ->
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Coastal Defense Structures" |> within [ infoIconView (Just "Coastal defense structures include groins, jetties, and revetments, and are derived from a 2014 planimetrics layer created by the regional flyover.") ]
            ]
        , case config.cdsClicked of 
            Open ->
                cdsLegend paths
            Closed -> 
                (el NoStyle [] empty )
        , paragraph 
            CloseIcon 
            [onClick ToggleStructuresLayer] 
            [ decorativeImage
                ( case config.structuresClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed ->
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Structures" |> within [ infoIconView (Just "Roofprints of buildings larger than 150 square feet are derived from ortho images continually collected through 2015.") ]
            ]
        ]

pprLegend : Paths -> Element MainStyles Variations Msg
pprLegend paths =
    textLayout 
        NoStyle 
        [ verticalCenter, spacing 5, paddingXY 32 0 ]
        [ paragraph 
            NoStyle 
            []
            [ button
                (PL RoadsPrivate)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                -- {src = paths.downArrow} 
                (Element.text "")
            , text "Private   "
            , button
                (PL RoadsPublic)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                -- {src = paths.downArrow} 
                (Element.text "")
            , text "Public"
            ]
        ]

cdsLegend : Paths -> Element MainStyles Variations Msg
cdsLegend paths =
    textLayout 
        NoStyle 
        [ verticalCenter, spacing 5, paddingXY 32 0 ]
        [ paragraph 
            NoStyle 
            []
            [ button
                (PL Groins)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                -- {src = paths.downArrow} 
                (Element.text "")
            , text "Groins   "
            , button
                (PL Revetment)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                -- {src = paths.downArrow} 
                (Element.text "")
            , text "Revetment   "
            , button
                (PL Jetty)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                -- {src = paths.downArrow} 
                (Element.text "")
            , text "Jetty"
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