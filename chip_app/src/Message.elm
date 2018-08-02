module Message exposing (..)

import Navigation
import Element.Input as Input
import Animation
import Types exposing (..)


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
    | Animate Animation.Msg
