module Animations exposing (..)

import Animation


type alias RightSidebarStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }


rightSidebarStates : RightSidebarStates
rightSidebarStates =
    { open =
        [ Animation.left (Animation.px 0.0) ]
    , closed =
        [ Animation.left (Animation.px 400.0) ]    
    }


type alias ToggleStates =
    { rotateZero : List Animation.Property
    , rotateNeg180 : List Animation.Property
    , rotate180 : List Animation.Property
    }


toggleStates : ToggleStates
toggleStates =
    { rotateZero =
        [ Animation.rotate (Animation.deg 0.0) ]
    , rotateNeg180 =
        [ Animation.rotate (Animation.deg -180.0) ]
    , rotate180 =
        [ Animation.rotate (Animation.deg 180.0) ]
    }