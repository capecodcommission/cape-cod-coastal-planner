module Graphics.Erosion exposing (ErosionIconConfig, erosionIconConfig, erosionIcon)

import Html exposing (Html)
import Html.Attributes exposing (id, style)
import Color exposing (Color)
import Svg exposing (Svg)
import TypedSvg exposing (rect, svg, g, mask, use, path)
import TypedSvg.Attributes as Attr exposing (xlinkHref, d, fill, transform, fillRule, stroke, viewBox)
import TypedSvg.Attributes.InPx exposing (height, strokeWidth, width, x, y)
import TypedSvg.Types exposing (Paint(..), FillRule(..), Transform(..))

import Styles exposing (..)

type alias ErosionIconConfig =
    { color : Color
    , width : Float
    , height : Float
    }


erosionIconConfig : ErosionIconConfig
erosionIconConfig =
    { color = Color.white
    , width = 53
    , height = 52
    }


erosionIcon : ErosionIconConfig -> Html msg
erosionIcon cfg =
    svg
        [ viewBox 0 0 cfg.width cfg.height
        , width cfg.width
        , height cfg.height
        , id "svgStyleGuide"
        ]
        [ g 
            [ id "StyleGuide"
            , stroke <| Paint (Color.rgba 0 0 0 0)
            , strokeWidth 1
            , fill PaintNone
            , fillRule FillRuleEvenOdd
            ] 
            [ erosion cfg
            , circlePath cfg.color
            ] 
        ]


erosion : ErosionIconConfig -> Svg msg
erosion { color } =
    g
        [ id "Group-10", transform [ Translate 1 0.2324 ] ]
        [ g [ id "Group-3" ]
            [ landMask color
            , g [ id "Clip-2" ] []
            , landPath color
            ]
        , g [ id "Group-6" ]
            [ water1Mask color
            , g [ id "Clip-5" ] []
            , water1Path color
            ]
        , g [ id "Group-9" ]
            [ water2Mask color
            , g [ id "Clip-8" ] []
            , water2Path color
            ]        
        ]


landMask : Color -> Svg msg
landMask color =
    mask [ id "mask-2", fill <| Paint color ]
        [ use [ xlinkHref "#path-1" ]
            [ path
                [ d "M0.273,25.248 C0.273,38.815 11.272,49.815 24.84,49.815 C38.409,49.815 49.409,38.815 49.409,25.248 C49.409,11.678 38.409,0.68 24.84,0.68 C11.272,0.68 0.273,11.678 0.273,25.248"
                , id "path-1"
                ]
                []
            ]
        ]
        

landPath : Color -> Svg msg
landPath color =
 path
    [ d "M22.9414,14.5547 L-12.9996,14.5547 L-12.9996,54.9997 L44.1924,54.9997 L44.1924,44.6197 C44.1924,44.6197 33.9094,45.0117 25.4874,43.1507 C17.0654,41.2897 18.5344,38.1567 16.3794,36.6877 C14.2254,35.2177 13.5884,30.7127 13.6374,30.1257 C13.6704,29.7237 13.7354,29.0487 13.4414,29.0487 C13.1484,29.0487 13.1484,27.8727 13.1484,27.8727 C13.1484,27.8727 13.8134,26.8047 14.2744,26.7467 C14.8344,26.6767 14.9964,26.4807 15.1224,26.1587 C15.3844,25.4887 15.0084,25.0327 15.1064,24.5427 C15.2044,24.0537 15.4984,23.3677 16.2814,22.4867 C17.0654,21.6057 17.4574,21.4087 18.0454,21.6057 C18.6314,21.8017 18.7304,21.1167 19.1214,20.5287 C19.5134,19.9407 20.1014,19.0597 20.1984,18.3727 C20.2964,17.6887 21.4724,16.3177 22.3534,16.0237 C23.2344,15.7297 22.9414,14.5547 22.9414,14.5547" 
    , fill <| Paint color
    , id "Fill-1"
    , Attr.mask "url(#mask-2)"
    ]
    []
      

water1Mask : Color -> Svg msg
water1Mask color =
    mask [ id "mask-4", fill <| Paint color ]
        [ use [ xlinkHref "#path-3" ]
            [ path 
                [ d "M0.273,25.248 C0.273,38.815 11.272,49.815 24.84,49.815 C38.409,49.815 49.409,38.815 49.409,25.248 C49.409,11.678 38.409,0.68 24.84,0.68 C11.272,0.68 0.273,11.678 0.273,25.248"
                , id "path-3"
                ]
                []
            ]
        ]


water1Path : Color -> Svg msg        
water1Path color = 
    path 
        [ d "M20.188,35.2168 C22.327,37.7228 24.465,32.7098 26.604,35.2168 C28.741,37.7228 30.879,32.7098 33.018,35.2168 C35.156,37.7228 37.294,32.7098 39.433,35.2168 L39.433,35.1908 C41.572,37.7068 43.709,32.6748 45.848,35.1908 C45.848,35.2828 45.848,35.3678 45.847,35.4498 L45.904,35.1998 C47.894,37.5898 49.883,33.2508 51.873,34.8138 C52.062,34.7358 52.251,34.6548 52.446,34.5738 L52.265,33.7968 C50.144,31.2498 48.023,36.3428 45.904,33.7968 L45.847,34.0478 C45.848,33.9658 45.848,33.8788 45.848,33.7878 C43.709,31.2728 41.572,36.3028 39.433,33.7878 L39.433,33.8148 C37.294,31.3078 35.156,36.3208 33.018,33.8148 C30.879,31.3078 28.741,36.3208 26.604,33.8148 C24.465,31.3078 22.327,36.3208 20.188,33.8148 C18.05,31.3078 15.911,36.3208 13.773,33.8148 L13.773,35.2168 C15.911,37.7228 18.05,32.7098 20.188,35.2168"
        , id "Fill-4"        
        , fill <| Paint color
        , Attr.mask "url(#mask-4)"
        ]
        []
        

water2Mask : Color -> Svg msg
water2Mask color =
    mask [ id "mask-6", fill <| Paint color ]
        [ use [ xlinkHref "#path-5" ]
            [ path
                [ d "M0.273,25.248 C0.273,38.815 11.272,49.815 24.84,49.815 C38.409,49.815 49.409,38.815 49.409,25.248 C49.409,11.678 38.409,0.68 24.84,0.68 C11.272,0.68 0.273,11.678 0.273,25.248"
                , id "path-5"                
                ]
                []
            ]
        ]
        

water2Path : Color -> Svg msg
water2Path color =
    path
        [ d "M18.8828,40.0928 C21.0218,42.5998 23.1598,37.5858 25.2988,40.0928 C27.4358,42.5998 29.5738,37.5858 31.7128,40.0928 C33.8508,42.5998 35.9888,37.5858 38.1288,40.0928 L38.1288,40.0678 C40.2648,42.5828 42.4038,37.5528 44.5428,40.0678 L44.5428,40.3268 L44.5988,40.0758 C46.5888,42.4668 48.5778,38.1268 50.5678,39.6918 C50.7568,39.6128 50.9448,39.5328 51.1398,39.4498 L50.9588,38.6748 C48.8388,36.1268 46.7178,41.2208 44.5988,38.6748 L44.5428,38.9248 L44.5428,38.6638 C42.4038,36.1498 40.2648,41.1798 38.1288,38.6638 L38.1288,38.6908 C35.9888,36.1848 33.8508,41.1968 31.7128,38.6908 C29.5738,36.1848 27.4358,41.1968 25.2988,38.6908 C23.1598,36.1848 21.0218,41.1968 18.8828,38.6908 C16.7448,36.1848 14.6068,41.1968 12.4678,38.6908 L12.4678,40.0928 C14.6068,42.5998 16.7448,37.5858 18.8828,40.0928"
        , id "Fill-7"
        , fill <| Paint color
        , Attr.mask "url(#mask-6)"
        ]
        []
        

circlePath : Color -> Svg msg
circlePath color =
    path
        [ d "M50.8413,25.4804 C50.8413,39.2874 39.6483,50.4804 25.8403,50.4804 C12.0333,50.4804 0.8413,39.2874 0.8413,25.4804 C0.8413,11.6734 12.0333,0.4804 25.8403,0.4804 C39.6483,0.4804 50.8413,11.6734 50.8413,25.4804 Z"
        , id "Stroke-11"
        , stroke (Paint color)
        , strokeWidth 0.962
        ]
        []