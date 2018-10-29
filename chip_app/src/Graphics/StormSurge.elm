module Graphics.StormSurge exposing (StormSurgeIconConfig, stormSurgeIconConfig, stormSurgeIcon)

import Html exposing (Html)
import Html.Attributes exposing (id)
import Color exposing (Color)
import Svg exposing (Svg)
import TypedSvg exposing (rect, svg, g, mask, use, path)
import TypedSvg.Attributes as Attr exposing (xlinkHref, d, fill, transform, fillRule, stroke, viewBox)
import TypedSvg.Attributes.InPx exposing (height, strokeWidth, width, x, y)
import TypedSvg.Types exposing (Fill(..), FillRule(..), Transform(..))


type alias StormSurgeIconConfig =
    { color : Color
    , width : Float
    , height : Float
    }


stormSurgeIconConfig : StormSurgeIconConfig
stormSurgeIconConfig =
    { color = Color.white
    , width = 53
    , height = 52
    }


stormSurgeIcon : StormSurgeIconConfig -> Html msg
stormSurgeIcon cfg =
    svg
        [ viewBox 0 0 cfg.width cfg.height
        , width cfg.width
        , height cfg.height
        ]
        [ g
            [ id "StyleGuide" 
            , stroke <| Color.rgba 0 0 0 0
            , strokeWidth 1
            , fill FillNone
            , fillRule FillRuleEvenOdd
            ]
            [ stormSurge cfg
            , circlePath cfg.color
            ]
        ]


stormSurge : StormSurgeIconConfig -> Svg msg
stormSurge { color } =
    g
        [ id "Group-13", transform [ Translate 0 0.9609 ] ]
        [ g [ id "Group-3" ]
            [ water1Mask color
            , g [ id "Clip-2" ] []
            , water1Path color
            ]
        , g [ id "Group-6" ]
            [ water2Mask color
            , g [ id "Clip-5" ] []
            , water2Path color
            ]
        , g [ id "Group-9" ]
            [ waveMask color
            , g [ id "Clip-8" ] []
            , wavePath color
            ]
        ]


water1Mask : Color -> Svg msg
water1Mask color =
    mask [ id "mask-2", fill <| Fill color ]
        [ use [ xlinkHref "#path-1" ]
            [ path 
                [ d "M0.481,25.442 C0.481,39.249 11.674,50.441 25.481,50.441 C39.287,50.441 50.48,39.249 50.48,25.442 C50.48,11.635 39.287,0.442 25.481,0.442 C11.674,0.442 0.481,11.635 0.481,25.442"
                , id "path-1"
                ]
                []
            ]
        ]


water1Path : Color -> Svg msg
water1Path color =
    path 
        [ d "M13.1699,42.2871 C15.3079,44.7941 17.4449,39.7821 19.5839,42.2871 C21.7229,44.7941 23.8609,39.7821 25.9989,42.2871 C28.1369,44.7941 30.2749,39.7821 32.4139,42.2871 L32.4139,42.2631 C34.5529,44.7771 36.6909,39.7471 38.8289,42.2631 L38.8289,42.5221 L38.8849,42.2711 C40.8739,44.6611 42.8639,40.3231 44.8549,41.8861 C45.0429,41.8071 45.2319,41.7271 45.4279,41.6451 L45.2449,40.8691 C43.1249,38.3211 41.0049,43.4151 38.8849,40.8691 L38.8289,41.1191 L38.8289,40.8581 C36.6909,38.3441 34.5529,43.3741 32.4139,40.8581 L32.4139,40.8851 C30.2749,38.3791 28.1369,43.3911 25.9989,40.8851 C23.8609,38.3791 21.7229,43.3911 19.5839,40.8851 C17.4449,38.3791 15.3079,43.3911 13.1699,40.8851 C11.0309,38.3791 8.8929,43.3911 6.7539,40.8851 L6.7539,42.2871 C8.8929,44.7941 11.0309,39.7821 13.1699,42.2871"
        , id "Fill-1"        
        , fill <| Fill color
        , Attr.mask "url(#mask-2)"
        ]
        []


water2Mask : Color -> Svg msg
water2Mask color =
    mask [ id "mask-4", fill <| Fill color ]
        [ use [ xlinkHref "#path-3" ]
            [ path 
                [ d "M0.481,25.442 C0.481,39.249 11.674,50.441 25.481,50.441 C39.287,50.441 50.48,39.249 50.48,25.442 C50.48,11.635 39.287,0.442 25.481,0.442 C11.674,0.442 0.481,11.635 0.481,25.442"
                , id "path-3"
                ]
                []
            ]
        ]


water2Path : Color -> Svg msg
water2Path color =
    path 
        [ d "M11.6465,46.748 C13.7855,49.255 15.9225,44.242 18.0615,46.748 C20.1995,49.255 22.3375,44.242 24.4765,46.748 C26.6155,49.255 28.7525,44.242 30.8905,46.748 L30.8905,46.722 C33.0295,49.237 35.1675,44.207 37.3065,46.722 C37.3065,46.814 37.3065,46.899 37.3055,46.982 L37.3615,46.732 C39.3515,49.122 41.3415,44.782 43.3325,46.345 C43.5195,46.268 43.7085,46.187 43.9045,46.106 L43.7225,45.328 C41.6015,42.782 39.4815,47.875 37.3615,45.328 L37.3055,45.58 C37.3065,45.497 37.3065,45.411 37.3065,45.319 C35.1675,42.805 33.0295,47.835 30.8905,45.319 L30.8905,45.346 C28.7525,42.84 26.6155,47.852 24.4765,45.346 C22.3375,42.84 20.1995,47.852 18.0615,45.346 C15.9225,42.84 13.7855,47.852 11.6465,45.346 C9.5075,42.84 7.3695,47.852 5.2315,45.346 L5.2315,46.748 C7.3695,49.255 9.5075,44.242 11.6465,46.748"
        , id "Fill-4"        
        , fill <| Fill color
        , Attr.mask "url(#mask-4)"
        ]
        []


waveMask : Color -> Svg msg
waveMask color =
    mask [ id "mask-6", fill <| Fill color ]
        [ use [ xlinkHref "#path-5" ]
            [ path 
                [ d "M0.481,25.442 C0.481,39.249 11.674,50.441 25.481,50.441 C39.287,50.441 50.48,39.249 50.48,25.442 C50.48,11.635 39.287,0.442 25.481,0.442 C11.674,0.442 0.481,11.635 0.481,25.442"
                , id "path-5"
                ]
                []
            ]
        ]


wavePath : Color -> Svg msg
wavePath color =
    path 
        [ d "M17.125,26.9766 C17.083,27.7936 16.678,28.5716 16.904,29.4236 C17.196,30.5276 18.302,31.3216 19.55,31.2456 C20.413,31.1926 20.904,30.7186 21.204,30.0426 C21.713,28.9026 22.143,28.5816 22.972,28.7606 C23.825,28.9446 24.45,29.9146 24.327,30.8926 C24.062,32.9866 23.006,34.5526 20.813,35.4556 C18.38,36.4586 15.882,37.1116 13.186,37.1466 C10.146,37.1866 7.125,37.0496 4.109,36.6046 C4.454,37.2566 5.059,37.6676 6.307,38.1616 C8.062,38.8536 9.917,39.2326 11.797,39.3906 C16.189,39.7606 20.539,39.5596 24.738,38.1766 C26.625,37.5556 28.402,36.7546 29.865,35.4676 C30.038,35.3166 30.185,35.0786 30.496,35.3656 C33.055,37.7246 36.373,38.7266 39.772,39.5266 C42.107,40.0766 44.477,40.4996 46.913,40.5106 C47.601,40.5136 47.84,40.3256 47.805,39.6996 C47.755,38.7806 47.74,37.8556 47.81,36.9406 C47.858,36.3116 47.597,36.0686 46.962,35.8986 C42.641,34.7396 38.904,32.6836 35.803,29.7196 C33.863,27.8676 32.393,25.6696 30.609,23.7006 C28.828,21.7326 26.753,20.0556 23.778,19.9466 C20.34,19.8196 17.027,20.2126 14.728,22.9766 C14.591,23.1406 14.46,23.3206 14.384,23.5106 C14.153,24.0806 13.698,24.6566 14.131,25.2766 C14.587,25.9296 15.205,25.2456 15.738,25.3646 L15.806,25.2766 C15.803,25.2926 15.808,25.3156 15.797,25.3226 C15.777,25.3376 15.751,25.3436 15.727,25.3546 C15.643,25.6946 15.591,26.0446 15.467,26.3726 C15.316,26.7706 15.308,27.1776 15.663,27.4216 C16.082,27.7096 16.435,27.3446 16.779,27.1456 C16.887,27.0826 16.993,27.0176 17.101,26.9556 C17.135,26.9106 17.134,26.7856 17.241,26.9026 C17.202,26.9276 17.164,26.9516 17.125,26.9766"
        , id "Fill-7"
        , fill <| Fill color
        , Attr.mask "url(#mask-6)"
        ]
        []


circlePath : Color -> Svg msg
circlePath color =
    path
        [ d "M50.4805,26.4804 C50.4805,40.2874 39.2875,51.4804 25.4805,51.4804 C11.6735,51.4804 0.4805,40.2874 0.4805,26.4804 C0.4805,12.6724 11.6735,1.4804 25.4805,1.4804 C39.2875,1.4804 50.4805,12.6724 50.4805,26.4804 Z"
        , id "Stroke-14"
        , stroke color
        , strokeWidth 0.962
        ]
        []