module View.PlanningLayers exposing (..)

import Types exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import View.Helpers exposing (title, adjustOnHeight)
import Styles exposing (..)
import ShorelineLocation as SL


textLayoutSpacing : Device -> Float
textLayoutSpacing device =
    adjustOnHeight ( 25, 40 ) device


imageHeight : Device -> Float
imageHeight device =
    adjustOnHeight ( 150, 235 ) device


view : Device -> Paths -> Element MainStyles Variations Msg
view device paths =
  column NoStyle
    [ height fill
    , verticalSpread 
    ]
    [ textLayout (Zoi ZoiText)
        [ height fill
        , verticalCenter
        , spacing <| textLayoutSpacing device 
        , paddingXY 75 20 
        ]
        [
          paragraph NoStyle []
            [
              text "Toggle layers on/off using left mouse-click"
            ]
        ]
      
    , row NoStyle 
        [ verticalCenter
        , spread
        , width fill
        , height fill
        , paddingXY 32 35 
        ]
        [ decorativeImage NoStyle 
            [ height (px <| imageHeight device)
            , verticalCenter
            , onClick ToggleCritFac
            ] 
            { src = paths.shorePath }
        , decorativeImage NoStyle 
            [ height (px <| imageHeight device)
            , verticalCenter
            ] 
            { src = paths.slrPath }
        ]
    , row NoStyle 
        [ verticalCenter
        , spread
        , width fill
        , height fill
        , paddingXY 32 35 
        ]
        [ decorativeImage NoStyle 
            [ height (px <| imageHeight device)
            , verticalCenter
            ] 
            { src = paths.wetPath }
        , decorativeImage NoStyle 
            [ height (px <| imageHeight device)
            , verticalCenter
            ] 
            { src = paths.sloshPath }
        ]
      -- row NoStyle 
      --   [ verticalCenter, spread, width fill, height fill, paddingXY 32 100 ]
      --   [
      --     decorativeImage NoStyle 
      --       [ height (px <| imageHeight device), verticalCenter] 
      --       { src = trianglePath },
      --     decorativeImage NoStyle 
      --       [ height (px <| imageHeight device), verticalCenter] 
      --       { src = trianglePath }
      --   ]  
            -- textLayout (Zoi ZoiText) 
            --   [ height fill, verticalCenter, spacing <| textLayoutSpacing device , paddingXY 32 0 ]
            --   [ 
            --     paragraph NoStyle [] 
            --       [ 
            --         text "Select layer images to toggle respective layers",
            --         el (Zoi ZoiCallout) [] <| text " five 100 ft. segments",
            --         text " for a total of 500 ft. per selection." 
            --       ],
            --     paragraph NoStyle [] 
            --       [ 
            --         text "You may make up to ",
            --         el (Zoi ZoiCallout) [] <| text " eight contiguous selections",
            --         text " for a maximum planning area of 4000 ft." 
            --       ],
            --     paragraph NoStyle [] 
            --       [ 
            --         text "A contiguous selection may be made by selecting ",
            --         el (Zoi ZoiCallout) [] <| text " any one of the five segments",
            --         text " to the", 
            --         el (Zoi ZoiCallout) [] <| text " immediate left or right",
            --         text " of the existing selection." 
            --       ]
            --   ],
            -- column (Zoi ZoiStat) 
            --   [ height fill, center, verticalCenter, spacingXY 0 5 ] 
            --   [ 
            --   --   el NoStyle [ alignBottom ] <|
            --   --     text ("Selections: " ++ toString zoi.numSelected ++ " of 8")
            --   -- , el NoStyle [ alignTop ] <|
            --   --     text ("Shoreline Extent: " ++ toString zoi.beachLengths.total ++ " ft.")
            --   ],
            -- footer (Sidebar SidebarFooter) 
              -- [ alignBottom, height (px 90) ] 
              -- <|
              --   row NoStyle
              --     [ verticalCenter, spread, width fill, height fill, paddingXY 32 0 ]
              --     [ 
              --       button ActionButton 
              --         [ onClick PickStrategy 
              --         , width (px 175)
              --         , height (px 42)
              --         , title "Apply an adaptation strategy to the zone of impact"
              --         ] <| text "add strategy"
              --     , button CancelButton 
              --         [ onClick CancelZoneOfImpactSelection 
              --         , width (px 175)
              --         , height (px 42)
              --         , title "Clear zone of impact"
              --         ] <| text "cancel"
              --     ]
    ]
