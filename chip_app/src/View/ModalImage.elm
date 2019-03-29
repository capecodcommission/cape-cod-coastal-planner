module View.ModalImage exposing (..)


import Element exposing (..)
import Element.Attributes exposing (..)
import Styles exposing (..)
import Message exposing (Msg(..))


view : MainStyles -> MainStyles -> Maybe String -> Element MainStyles Variations Msg
view wrapperStyle imageStyle imagePath = 
    case imagePath of
        Just path ->
            column wrapperStyle []
                [ decorativeImage imageStyle 
                    [ width fill, height (px 200) ] 
                    { src = path }
                ]

        Nothing ->
            Element.empty