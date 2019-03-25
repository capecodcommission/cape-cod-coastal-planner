module Message exposing (..)

import Navigation
import Element.Input as Input
import Animation
import Window
import Types exposing (..)
import AdaptationStrategy.AdaptationInfo exposing (AdaptationInfo)
import AdaptationStrategy.StrategyDetails exposing (StrategyDetails)
import AdaptationOutput exposing (OutputDetails)
import AdaptationHexes as AH
import ShorelineLocation as SL
import Json.Decode as D
import Http
import RemoteData as Remote exposing (WebData)
import Keyboard.Event exposing (KeyboardEvent)
import ChipApi.Scalar as Scalar


type Msg
    = Noop
    | UrlChange Navigation.Location
    | GotAdaptationInfo (GqlData AdaptationInfo)
    | GotShorelineExtents (GqlData (GqlList SL.ShorelineExtent))
    | SelectLocationInput (Input.SelectMsg SL.ShorelineExtent)
    | GetBaselineInfo
    | GotBaselineInfo (GqlData (Maybe SL.BaselineInfo))
    | CloseBaselineInfo
    | LoadLittoralCells SL.Extent
    | LoadLittoralCellsResponse (Result Http.Error D.Value)
    | MapSelectLittoralCell String
    | LoadVulnerabilityRibbonResponse (Result Http.Error D.Value)
    | GotHexesResponse (WebData AH.AdaptationHexes)
    | UpdateZoneOfImpact ZoneOfImpact
    | CancelZoneOfImpactSelection    
    | PickStrategy
    | CancelPickStrategy
    | SelectPreviousHazard
    | SelectNextHazard
    | SelectStrategy Scalar.Id
    | HandleStrategyKeyboardEvent KeyboardEvent
    | GotStrategyDetails Scalar.Id (GqlData (Maybe StrategyDetails))
    | ApplyStrategy StrategyDetails (Maybe KeyboardEvent)
    | ShowStrategyOutput (OutputDetails, OutputDetails)
    | ShowNoActionOutput (OutputDetails, OutputDetails)
    | ToggleRightSidebar
    | Animate Animation.Msg
    | Resize Window.Size
    | ToggleLeftSidebar
    | ToggleCritFac
    | LoadCritFacResponse (Result Http.Error D.Value)
    | ToggleSLRSection
    | ToggleInfraSection
    | ToggleErosionSection
    | ToggleDR String
    | ToggleSLRLayer String
    | ToggleMOPLayer
    | LoadMOPResponse (Result Http.Error D.Value)
    | TogglePPRLayer
    | ToggleSPLayer
    | ToggleCDSLayer
    | ToggleFZLayer
    | ToggleSloshLayer
    | ToggleFourtyYearLayer
    | ToggleSTILayer
    | ClearAllLayers
    | ToggleStructuresLayer
    | ResetAll
    | ZoomIn
    | ZoomOut
    | GetLocation
    | ToggleVulnRibbon
    | ToggleMenu
