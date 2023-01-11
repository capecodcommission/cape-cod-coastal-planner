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
        , stpOpenness : Openness
        , stpToggleFx : Animation.State
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
        , histDistClicked : Openness
        , histPlacesClicked : Openness
        , llrClicked : Openness
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
        , histDistClicked : Openness
        , histPlacesClicked : Openness
        , llrClicked : Openness
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
        , paragraph 
            CloseIcon 
            [onClick ToggleHistDistLayer] 
            [ decorativeImage
                ( case config.histDistClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed ->
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Historic Districts" |> within [ infoIconView (Just "Cape Cod has 22 local and regional historic districts.") ]
            ]
        , paragraph 
            CloseIcon 
            [onClick ToggleHistPlacesLayer] 
            [ decorativeImage
                ( case config.histPlacesClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed ->
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Historic Places" |> within [ infoIconView (Just "Cape Cod has a wealth of historic resources, from its buildings and historic villages to its cultural landscapes and archaeological sites.") ]
            ]
        
        , paragraph CloseIcon [onClick ToggleLLRLayer] 
            [ decorativeImage
                ( case config.llrClicked of 
                    Open -> 
                        (PL Clicked)
                    Closed ->
                        (NoStyle)
                ) 
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
                {src = paths.downArrow}
            , text "Low Lying Roads" |> within [ infoIconView (Just "This layer depicts outputs from the Massachusetts Coast Flood Risk Model, a predictive model showing the 50 year probability of road segments being inundated with water under storm surge and sea level rise scenarios.") ]
            ]
        , case config.llrClicked of 
            Open ->
                llrLegend paths
            Closed -> 
                (el NoStyle [] empty )
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
                (Element.text "")
            , text "Private   "
            , button
                (PL RoadsPublic)
                [height (px 20), width (px 20), moveDown 5, spacing 5] 
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
                (Element.text "")
            , text "Groins   "
            , button
                (PL Revetment)
                [height (px 20), width (px 20), moveDown 5, spacing 5]
                (Element.text "")
            , text "Revetment   "
            , button
                (PL Jetty)
                [height (px 20), width (px 20), moveDown 5, spacing 5]
                (Element.text "")
            , text "Jetty"
            ]
        ]

llrLegend : Paths -> Element MainStyles Variations Msg
llrLegend paths =
    textLayout 
        NoStyle 
        [ verticalCenter, spacing 5, paddingXY 32 0 ]
        [ paragraph 
            NoStyle 
            []
            [ button
                (PL Category1)
                [height (px 10), width (px 10), moveUp 5, spacingXY 2 0]
                (Element.text "")
            , el (NoStyle) [ spacingXY 10 0 ] <| text "0.1% "
            , button
                (PL Category4)
                [height (px 10), width (px 10), moveUp 5, spacingXY 2 0]
                (Element.text "")
            -- , text "1.0% "
            , el (NoStyle) [ spacingXY 10 0 ] <| text "1.0% "
            , button
                (PL Category7)
                [height (px 10), width (px 10), moveUp 5, spacingXY 2 0]
                (Element.text "")
            , text "10% "
            ]
        , paragraph 
            NoStyle 
            []
            [ button
                (PL Category2)
                [height (px 10), width (px 10), moveUp 5, spacingXY 2 0]
                (Element.text "")
            , el (NoStyle) [ spacingXY 10 0 ] <| text "0.2% "
            , button
                (PL Category5)
                [height (px 10), width (px 10), moveUp 5, spacingXY 2 0]
                (Element.text "")
            , el (NoStyle) [ spacingXY 10 0 ] <| text "2.0% "
            , button
                (PL Category8)
                [height (px 10), width (px 10), moveUp 5, spacingXY 2 0]
                (Element.text "")
            , text "20% "
            ]
        , paragraph 
            NoStyle 
            []
            [ button
                (PL Category3)
                [height (px 10), width (px 10), moveUp 5, spacingXY 2 0]
                (Element.text "")
            , el (NoStyle) [ spacingXY 10 0 ] <| text "0.5% "
            , button
                (PL Category6)
                [height (px 10), width (px 10), moveUp 5, spacingXY 2 0]
                (Element.text "")
            , el (NoStyle) [ spacingXY 10 0 ] <| text "5.0% "
            , button
                (PL Category9)
                [height (px 10), width (px 10), moveUp 5, spacingXY 2 0]
                (Element.text "")
            , text "100%   "
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