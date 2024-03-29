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
import View.Tray as Tray


view :
    { config
        | trianglePath : String
        , rightSidebarFx : Animation.State
        , rightSidebarToggleFx : Animation.State
        , shorelineSelected : Openness
        , paths : Paths
        , titleRibbonFX : Animation.State
        , zoneOfImpact : Maybe ZoneOfImpact
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
            [ height fill
            , width (px 550)
            ,  id "rightSideBar"  ]
            ( headerView titleText config.trianglePath config.rightSidebarToggleFx config.zoneOfImpact
                :: childViews
            ) 
        ) |> onLeft
                [ Tray.view config

                ]


headerView : String -> String -> Animation.State -> Maybe ZoneOfImpact -> Element MainStyles Variations Msg
headerView titleText togglePath fx zoi = 
    ( header (Sidebar SidebarHeader) 
        [ height (px 72), width fill ] 
        ( h5 (Headings H5) 
            [ center, verticalCenter ] 
            ( text titleText 
            ) 
                |> onLeft
                -- [ case titleText of 
                --     "STRATEGY OUTPUT" ->
                --         button CancelButton
                --             [ onClick CancelPickStrategy, width (px 75), height (px 42), moveLeft 50 ]
                --             ( text "clear" )
                --     _ ->
                --         el NoStyle [] empty    
                -- ]
                [ el NoStyle [] empty ]
        )
    ) |> onLeft
        [ case zoi of
            Just item ->
                el (Sidebar SidebarToggle) 
                    [ height (px 72), width (px 70), onClick ToggleRightSidebar ] 
                    ( el NoStyle 
                        [ center, verticalCenter, height fill, width fill, moveRight 18 ]
                        ( Toggle.view togglePath fx )
                    )
            Nothing ->
                el NoStyle [] empty
        ]