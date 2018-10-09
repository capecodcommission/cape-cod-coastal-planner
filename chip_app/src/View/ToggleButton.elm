module View.ToggleButton exposing (..)

import Animation
import Message exposing (..)
import Element exposing (..)
import Styles exposing (..)
import View.Helpers exposing (renderAnimation)



view : String -> Animation.State -> Element MainStyles Variations Msg
view src toggleAnimations =
    decorativeImage NoStyle
        ( renderAnimation toggleAnimations
            []
        )
        { src = src }