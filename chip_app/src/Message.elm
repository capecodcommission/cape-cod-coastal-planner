module Message exposing (..)

import Navigation
import Element.Input as Input
import Animation
import Window
import Types exposing (..)
import Json.Decode as D
import Http


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
    | Animate Animation.Msg
    | Resize Window.Size
