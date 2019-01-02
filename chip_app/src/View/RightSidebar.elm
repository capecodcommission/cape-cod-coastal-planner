module View.RightSidebar exposing (..)

import Animation
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Styles exposing (..)
import View.ToggleButton as Toggle exposing (..)
import View.Helpers exposing (renderAnimation)
import Message exposing (Msg(..))
import Types exposing (..)


view :
    { config
        | trianglePath : String
        , rightSidebarFx : Animation.State
        , rightSidebarToggleFx : Animation.State
    }
    -> (String, List (Element MainStyles Variations Msg))
    -> Element MainStyles Variations Msg
view config (titleText, childViews) =
    el NoStyle
        (renderAnimation config.rightSidebarFx
            [ height fill
            , width content
            , paddingTop 20.0
            , alignRight
            ]
        )
        (sidebar (Sidebar SidebarContainer)
            [ height fill, width (px 550) ]
            ( headerView titleText config.trianglePath config.rightSidebarToggleFx 
                :: childViews
            )
        )


headerView : String -> String -> Animation.State -> Element MainStyles Variations Msg
headerView titleText togglePath fx = 
    ( header (Sidebar SidebarHeader) 
        [ height (px 72), width fill ] 
        ( h5 (Headings H5) 
            [ center, verticalCenter ] 
            ( text titleText 
            ) |> onLeft
                [ case titleText of 
                    "STRATEGY OUTPUT" ->
                        button CancelButton
                            [ onClick CancelPickStrategy, width (px 75), height (px 42), moveLeft 50 ]
                            ( text "clear" )
                    _ ->
                        el NoStyle [] empty    
                ]
        )
    ) |> onLeft
        [ el (Sidebar SidebarToggle) 
            [ height (px 72), width (px 70), onClick ToggleRightSidebar ] 
            ( el NoStyle 
                [ center, verticalCenter, height fill, width fill, moveRight 18 ]
                ( Toggle.view togglePath fx )
            )
        ]