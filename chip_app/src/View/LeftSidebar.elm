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
import Types exposing (..)


view :
    { config
        | trianglePath : String
        , leftSidebarFx : Animation.State
        , leftSidebarToggleFx : Animation.State
        , layerClicked : Openness
        , stiClicked : Openness 
        , fourtyYearClicked : Openness
        , sloshClicked : Openness
        , fzClicked : Openness
        , cdsClicked : Openness
        , spClicked : Openness
        , pprClicked : Openness
        , mopClicked : Openness
        , slr6ftClicked : Openness 
        , dr6ftClicked : Openness
        , slr5ftClicked : Openness
        , dr5ftClicked : Openness
        , slr4ftClicked : Openness
        , dr4ftClicked : Openness
        , slr3ftClicked : Openness
        , dr3ftClicked : Openness
        , slr2ftClicked : Openness
        , dr2ftClicked : Openness
        , slr1ftClicked : Openness 
        , dr1ftClicked : Openness
        , critFacClicked : Openness
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
                config
                titleText 
                config.trianglePath 
                config.leftSidebarToggleFx 
              :: childViews
            )
        )


headerView : {
    config 
        | layerClicked : Openness
        , stiClicked : Openness 
        , fourtyYearClicked : Openness
        , sloshClicked : Openness
        , fzClicked : Openness
        , cdsClicked : Openness
        , spClicked : Openness
        , pprClicked : Openness
        , mopClicked : Openness
        , slr6ftClicked : Openness 
        , dr6ftClicked : Openness
        , slr5ftClicked : Openness
        , dr5ftClicked : Openness
        , slr4ftClicked : Openness
        , dr4ftClicked : Openness
        , slr3ftClicked : Openness
        , dr3ftClicked : Openness
        , slr2ftClicked : Openness
        , dr2ftClicked : Openness
        , slr1ftClicked : Openness 
        , dr1ftClicked : Openness
        , critFacClicked : Openness
    } -> String -> String -> Animation.State -> Element MainStyles Variations Msg
headerView config titleText togglePath fx =
    ( header (Sidebar SidebarHeader) 
        [ height (px 72), width fill ]
        ( h5 (Headings H5) 
            [ center, verticalCenter ] 
            ( text titleText
            ) |> onRight
                [ if 
                    ( config.stiClicked == Open 
                    || config.fourtyYearClicked == Open 
                    || config.sloshClicked == Open 
                    || config.fzClicked == Open 
                    || config.cdsClicked == Open 
                    || config.spClicked == Open 
                    || config.pprClicked == Open 
                    || config.mopClicked == Open 
                    || config.slr6ftClicked == Open 
                    || config.dr6ftClicked == Open 
                    || config.slr5ftClicked == Open 
                    || config.dr5ftClicked == Open 
                    || config.slr4ftClicked == Open 
                    || config.dr4ftClicked == Open 
                    || config.slr3ftClicked == Open 
                    || config.dr3ftClicked == Open 
                    || config.slr2ftClicked == Open 
                    || config.dr2ftClicked == Open 
                    || config.slr1ftClicked == Open 
                    || config.dr1ftClicked == Open 
                    || config.critFacClicked == Open 
                    ) 
                    then
                        button CancelButton
                            [ onClick ClearAllLayers, width (px 75), height (px 42), moveRight 50 ]
                            ( text "clear" ) 
                    else
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