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
import View.StormtidePathways as SP
import View.Infrastructure as IF
import View.Inundation as Inundation
import View.Erosion as Erosion
import View.VulnerabilityRibbon as Vuln


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
        , dr1ftClicked : Openness
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
        , slr3ftClicked : Openness
        , slr4ftClicked : Openness
        , slr5ftClicked : Openness
        , slr6ftClicked : Openness
        , dr2ftClicked : Openness
        , dr3ftClicked : Openness
        , dr4ftClicked : Openness
        , dr5ftClicked : Openness
        , dr6ftClicked : Openness
        , structuresClicked : Openness
        , erosionSectionOpenness : Openness
        , erosionFx : Animation.State
        , erosionToggleFx : Animation.State
        , fourtyYearClicked : Openness
        , stiClicked : Openness
        , inundationFx : Animation.State
        , inundationToggleFx : Animation.State
        , shorelineSelected : Openness
        , vulnRibbonClicked : Openness
        , vulnFX : Animation.State
        , vulnLegendFX : Animation.State
        , inundationClicked : Openness
        , histDistClicked : Openness
        , histPlacesClicked : Openness
        , llrClicked : Openness
        , stpOpenness : Openness
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
    -> Element MainStyles Variations Msg
view config device paths =
  column NoStyle
    [ height fill ]
    [ Vuln.view config device paths "Vulnerability Ribbon" ToggleVulnRibbon
    , IF.view config device paths "Infrastructure" ToggleInfraSection 
    , SLR.view config device paths "Sea Level Rise" ToggleSLRSection 
    , SP.view config device paths "Stormtide Pathways" ToggleSTPSection
    , Inundation.view config device paths "Inundation" ToggleInundationSection
    , Erosion.view config device paths "Erosion" ToggleErosionSection
    ]
