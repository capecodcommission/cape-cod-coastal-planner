module Message exposing (..)

import Navigation
import Element.Input as Input
import Animation
import Types exposing (..)


type Msg
    = Noop
    | UrlChange Navigation.Location
    | HandleCoastalHazardsResponse (GqlData CoastalHazardsResponse)
    | SelectHazard (Input.SelectMsg CoastalHazard)
    | Animate Animation.Msg
