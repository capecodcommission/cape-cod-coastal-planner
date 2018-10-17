module Message exposing (..)

import Navigation
import Element.Input as Input
import Animation
import Window
import Types exposing (..)
import AdaptationStrategy as AS
import ShorelineLocation as SL
import Json.Decode as D
import Http
import Keyboard.Event exposing (KeyboardEvent)
import ChipApi.Scalar as Scalar


type Msg
    = Noop
    | UrlChange Navigation.Location
    | GotAdaptationInfo (GqlData AS.AdaptationInfo)
    | GotShorelineExtents (GqlData (GqlList SL.ShorelineExtent))
    | SelectLocationInput (Input.SelectMsg SL.ShorelineExtent)
    | GetBaselineInfo
    | GotBaselineInfo (GqlData (Maybe SL.BaselineInfo))
    | CloseBaselineInfo
    | LoadLittoralCells SL.Extent
    | LoadLittoralCellsResponse (Result Http.Error D.Value)
    | MapSelectLittoralCell String
    | LoadVulnerabilityRibbonResponse (Result Http.Error D.Value)
    | LoadLocationHexesResponse (Result Http.Error D.Value)
    | UpdateZoneOfImpact ZoneOfImpact
    | CancelZoneOfImpactSelection    
    | PickStrategy
    | CloseStrategyModal
    | SelectPreviousHazard
    | SelectNextHazard
    | SelectStrategy Scalar.Id
    | HandleStrategyKeyboardEvent KeyboardEvent
    | GotStrategyDetails Scalar.Id (GqlData (Maybe AS.StrategyDetails))
    | ToggleRightSidebar
    | Animate Animation.Msg
    | Resize Window.Size
