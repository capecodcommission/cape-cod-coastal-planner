module Message exposing (..)

import Navigation
import Element.Input as Input
import Animation
import Window
import Types exposing (..)
import Json.Decode as D
import Http
import RemoteData exposing (WebData)


type Msg
    = Noop
    | UrlChange Navigation.Location
    | HandleCoastalHazardsResponse (GqlData CoastalHazards)
    | SelectHazard (Input.SelectMsg CoastalHazard)
    | HandleShorelineExtentsResponse (GqlData ShorelineExtents)
    | SelectLocation (Input.SelectMsg ShorelineExtent)
    | GetBaselineInfo
    | HandleBaselineInfoResponse (GqlData (Maybe BaselineInfo))
    | CloseBaselineInfo
    | LoadLittoralCells Extent
    | LoadLittoralCellsResponse (Result Http.Error D.Value)
    | MapSelectLittoralCell String
    | LoadVulnerabilityRibbonResponse (WebData VulnerabilityRibbon)
    | Animate Animation.Msg
    | Resize Window.Size
