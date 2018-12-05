module Animations exposing (..)

import Animation


type alias RightSidebarStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }

type alias LeftSidebarStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }

type alias SLRStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }

type alias GLPStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }


rightSidebarStates : RightSidebarStates
rightSidebarStates =
    { open =
        [ Animation.left (Animation.px 0.0) ]
    , closed =
        [ Animation.left (Animation.px 550.0) ]    
    }

leftSidebarStates : LeftSidebarStates
leftSidebarStates =
    { open =
        [ Animation.left (Animation.px 0.0) ]
    , closed =
        [ Animation.left (Animation.px -550.0) ]    
    }

slrStates : SLRStates
slrStates =
    { open =
        [ Animation.bottom (Animation.px 50.0) ]
    , closed =
        [ Animation.bottom (Animation.px 0.0) ]    
    }

glpStates : GLPStates
glpStates =
    { open =
        [ Animation.bottom (Animation.px 50.0) ]
    , closed =
        [ Animation.bottom (Animation.px 0.0) ]    
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