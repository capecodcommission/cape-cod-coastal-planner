module View.RightSidebar exposing (..)

import Animation
import Types exposing (..)
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick, onMouseDown, onMouseUp)
import Styles exposing (..)
import View.Helpers exposing (renderAnimation)


type alias Animations =
    { open : List Animation.Property
    , closed : List Animation.Property
    }


animations : Animations
animations =
    { open =
        [ Animation.left (Animation.px 0.0) ]
    , closed =
        [ Animation.left (Animation.px 400.0) ]
    }


view :
    { config
        | rightSidebarOpenness : Openness
        , rightSidebarAnimations : Animation.State
    }
    -> List (Element MainStyles Variations Msg)
    -> Element MainStyles Variations Msg
view { rightSidebarOpenness, rightSidebarAnimations } childViews =
    el NoStyle
        (renderAnimation rightSidebarAnimations
            [ height fill
            , width content
            , paddingTop 20.0
            , alignRight
            ]
        )
        (sidebar Sidebar
            [ height fill, width (px 400) ]
            childViews
        )
