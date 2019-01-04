module View.LeftSidebar exposing (..)

import Animation
import Message exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Styles exposing (..)
import View.ToggleButton as Toggle exposing (..)
import View.Helpers exposing (renderAnimation)
import Message exposing (Msg(..))


view :
    { config
        | trianglePath : String
        , leftSidebarFx : Animation.State
        , leftSidebarToggleFx : Animation.State
    }
    -> (String, List (Element MainStyles Variations Msg))
    -> Element MainStyles Variations Msg
view config (titleText, childViews) =
    el NoStyle
        (renderAnimation config.leftSidebarFx
            [ height fill
            , width content
            , paddingTop 20.0
            , alignLeft
            ]
        )
        (sidebar (Sidebar SidebarContainer)
            [ height fill, width (px 550) ]
            ( headerView 
                titleText 
                config.trianglePath 
                config.leftSidebarToggleFx 
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
            ) |> onRight
                [ case titleText of 
                    "PLANNING LAYERS" ->
                        button CancelButton
                            [ onClick ClearAllLayers, width (px 75), height (px 42), moveRight 50 ]
                            ( text "clear" )
                    _ ->
                        el NoStyle [] empty    
                ]
        )
                
    ) |> onRight
            [ el (Sidebar SidebarLeftToggle) 
                [ height (px 72), width (px 70), onClick ToggleLeftSidebar ]
                ( el NoStyle 
                    [ center, verticalCenter, height fill, width fill, moveRight 14 ]
                    ( Toggle.view togglePath fx )
                )
            ]