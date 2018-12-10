module View.PlanningLayers exposing (..)

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
import View.SeaLevelRise as SLRSection
import View.Infrastructure as InfraSection


textLayoutSpacing : Device -> Float
textLayoutSpacing device =
    adjustOnHeight ( 25, 40 ) device


imageHeight : Device -> Float
imageHeight device =
    adjustOnHeight ( 150, 235 ) device



view :  
    { config
        | slrOpenness : Openness
        , slrToggleFx : Animation.State
        , critFacClicked : Openness
        , slrFx : Animation.State
        , drClicked : Openness
        , slrClicked : Openness
        , infraOpenness : Openness
        , infraFx : Animation.State
        , infraToggleFx : Animation.State
        , mopClicked : Openness
    } 
    -> Device 
    -> Paths 
    -> Element MainStyles Variations Msg
view config device paths =
  column NoStyle
    [ height fill, verticalSpread ]
    [ SLRSection.view config device paths "Sea Level Rise" ToggleSLRSection 
    , InfraSection.view config device paths "Infrastructure" ToggleInfraSection 
    ]