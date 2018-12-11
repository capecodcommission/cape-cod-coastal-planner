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
import View.SeaLevelRise as SLR
import View.Infrastructure as IF
import View.FloodZone as FZ
import View.Slosh as Slosh


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
        , slr2ftClicked : Openness
        , infraOpenness : Openness
        , infraFx : Animation.State
        , infraToggleFx : Animation.State
        , mopClicked : Openness
        , pprClicked : Openness
        , spClicked : Openness
        , cdsClicked : Openness
        , fzClicked : Openness
        , sloshClicked : Openness
        , slr1ftClicked : Openness
    } 
    -> Device 
    -> Paths 
    -> Element MainStyles Variations Msg
view config device paths =
  column NoStyle
    [ height fill, verticalSpread ]
    [ SLR.view config device paths "Sea Level Rise" ToggleSLRSection 
    , IF.view config device paths "Infrastructure" ToggleInfraSection 
    , FZ.view config device paths "Flood Zone" ToggleFZLayer
    , Slosh.view config device paths "SLOSH" ToggleSloshLayer
    ]
