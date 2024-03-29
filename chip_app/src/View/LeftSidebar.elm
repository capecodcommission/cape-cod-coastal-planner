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
        , structuresClicked : Openness
        , histDistClicked : Openness
        , histPlacesClicked : Openness
        , llrClicked : Openness
        , stp0ftClicked : Openness
        , stp1ftClicked : Openness
        , stp2ftClicked : Openness
        , stp3ftClicked : Openness
        , stp4ftClicked : Openness
        , stp5ftClicked : Openness
        , stp6ftClicked : Openness
        , stp7ftClicked : Openness
        , stp8ftClicked : Openness
        , stp9ftClicked : Openness
        , stp10ftClicked : Openness
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
            [ height fill, width (px 400) ]
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
        , structuresClicked : Openness
        , histDistClicked : Openness
        , histPlacesClicked : Openness
        , llrClicked : Openness
        , stp0ftClicked : Openness
        , stp1ftClicked : Openness
        , stp2ftClicked : Openness
        , stp3ftClicked : Openness
        , stp4ftClicked : Openness
        , stp5ftClicked : Openness
        , stp6ftClicked : Openness
        , stp7ftClicked : Openness
        , stp8ftClicked : Openness
        , stp9ftClicked : Openness
        , stp10ftClicked : Openness

    } -> String -> String -> Animation.State -> Element MainStyles Variations Msg
headerView config titleText togglePath fx =
    ( header (Sidebar SidebarHeader) 
        [ height (px 72), width fill ]
        ( h5 (Headings H5) 
            [ paddingXY 20 0, verticalCenter ] 
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
                    || config.structuresClicked == Open
                    || config.histDistClicked == Open
                    || config.histPlacesClicked == Open
                    || config.llrClicked == Open 
                    || config.stp0ftClicked == Open
                    || config.stp1ftClicked == Open
                    || config.stp2ftClicked == Open
                    || config.stp3ftClicked == Open
                    || config.stp4ftClicked == Open
                    || config.stp5ftClicked == Open
                    || config.stp6ftClicked == Open
                    || config.stp7ftClicked == Open
                    || config.stp8ftClicked == Open
                    || config.stp9ftClicked == Open
                    || config.stp10ftClicked == Open
                    ) 
                    then
                        button CancelButton
                            [ onClick ClearAllLayers, width (px 75), height (px 42), moveRight 25 ]
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