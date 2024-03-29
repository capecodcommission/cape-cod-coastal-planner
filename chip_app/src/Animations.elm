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

type alias STPStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }

type alias InfraStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }

type alias ErosionStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }

type alias FZStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }

type alias SloshStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }

type alias TitleStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }

type alias MenuStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }

type alias VulnStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }

type alias VulnLegendStates =
    { open : List Animation.Property
    , closed : List Animation.Property
    }

vulnLegendStates : VulnLegendStates
vulnLegendStates =
    { open =
        [ Animation.left (Animation.px 10.0) ]
    , closed =
        [ Animation.left (Animation.px 0.0) ]    
    }

vulnStates : VulnStates
vulnStates =
    { open =
        [ Animation.left (Animation.px 10.0) ]
    , closed =
        [ Animation.left (Animation.px 0.0) ]    
    }

menuStates : MenuStates
menuStates =
    { open =
        [ Animation.top (Animation.px 0.0) ]
    , closed =
        [ Animation.top (Animation.px -183.0) ]    
    }

titleStates : TitleStates
titleStates =
    { open =
        [ Animation.top (Animation.px 0.0) ]
    , closed =
        [ Animation.top (Animation.px -183.0) ]    
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
        [ Animation.left (Animation.px -400.0) ]    
    }

slrStates : SLRStates
slrStates =
    { open =
        [ Animation.left (Animation.px 10.0) ]
    , closed =
        [ Animation.left (Animation.px 0.0) ]    
    }

stpStates : STPStates
stpStates =
    { open =
        [ Animation.left (Animation.px 10.0) ]
    , closed =
        [ Animation.left (Animation.px 0.0) ]    
    }
infraStates : InfraStates
infraStates =
    { open =
        [ Animation.left (Animation.px 10.0) ]
    , closed =
        [ Animation.left (Animation.px 0.0) ]    
    }

erosionStates : ErosionStates
erosionStates =
    { open =
        [ Animation.left (Animation.px 10.0) ]
    , closed =
        [ Animation.left (Animation.px 0.0) ]    
    }

fzStates : FZStates
fzStates =
    { open =
        [ Animation.left (Animation.px 10.0) ]
    , closed =
        [ Animation.left (Animation.px 0.0) ]    
    }

sloshStates : SloshStates
sloshStates =
    { open =
        [ Animation.left (Animation.px 10.0) ]
    , closed =
        [ Animation.left (Animation.px 0.0) ]    
    }


type alias ToggleStates =
    { rotateZero : List Animation.Property
    , rotateNeg180 : List Animation.Property
    , rotate180 : List Animation.Property
    , rotate90 : List Animation.Property
    }


toggleStates : ToggleStates
toggleStates =
    { rotateZero =
        [ Animation.rotate (Animation.deg 0.0) ]
    , rotateNeg180 =
        [ Animation.rotate (Animation.deg -180.0) ]
    , rotate180 =
        [ Animation.rotate (Animation.deg 180.0) ]
    , rotate90 =
        [ Animation.rotate (Animation.deg 90.0) ]
    }