module Message exposing (..)

import Navigation
import Element.Input as Input
import Animation
import Window
import Types exposing (..)
import AdaptationStrategy exposing (ActiveStrategies, StrategyDetails)
import Json.Decode as D
import Http
import Keyboard.Event exposing (KeyboardEvent)
import ChipApi.Scalar as Scalar


type Msg
    = Noop
    | UrlChange Navigation.Location
    | GotCoastalHazards (GqlData CoastalHazards)
    | SelectHazard (Input.SelectMsg CoastalHazard)
    | GotShorelineExtents (GqlData ShorelineExtents)
    | SelectLocation (Input.SelectMsg ShorelineExtent)
    | GetBaselineInfo
    | GotBaselineInfo (GqlData (Maybe BaselineInfo))
    | CloseBaselineInfo
    | LoadLittoralCells Extent
    | LoadLittoralCellsResponse (Result Http.Error D.Value)
    | MapSelectLittoralCell String
    | LoadVulnerabilityRibbonResponse (Result Http.Error D.Value)
    | LoadLocationHexesResponse (Result Http.Error D.Value)
    | UpdateZoneOfImpact ZoneOfImpact
    | CancelZoneOfImpactSelection
    | PickStrategy
    | CloseStrategyModal
    | GotActiveStrategies (GqlData ActiveStrategies)
    | SelectStrategy Scalar.Id
    | HandleStrategyKeyboardEvent KeyboardEvent
    | GotStrategyDetails Scalar.Id (GqlData (Maybe StrategyDetails))
    | ToggleRightSidebar
    | Animate Animation.Msg
    | Resize Window.Size
