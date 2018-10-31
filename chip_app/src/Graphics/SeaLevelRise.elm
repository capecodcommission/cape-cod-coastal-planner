module Graphics.SeaLevelRise exposing (SeaLevelRiseIconConfig, seaLevelRiseIconConfig, seaLevelRiseIcon)

import Html exposing (Html)
import Html.Attributes exposing (id)
import Color exposing (Color)
import Svg exposing (Svg)
import TypedSvg exposing (rect, svg, g, mask, use, path)
import TypedSvg.Attributes as Attr exposing (xlinkHref, d, fill, transform, fillRule, stroke, viewBox)
import TypedSvg.Attributes.InPx exposing (height, strokeWidth, width, x, y)
import TypedSvg.Types exposing (Fill(..), FillRule(..), Transform(..))

type alias SeaLevelRiseIconConfig =
    { color : Color
    , width : Float
    , height : Float
    }


seaLevelRiseIconConfig : SeaLevelRiseIconConfig
seaLevelRiseIconConfig =
    { color = Color.white
    , width = 53
    , height = 51
    }


seaLevelRiseIcon : SeaLevelRiseIconConfig -> Html msg
seaLevelRiseIcon cfg =
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
            [ seaLevelRise cfg
            , circlePath cfg.color
            ]
        ]


seaLevelRise : SeaLevelRiseIconConfig -> Svg msg
seaLevelRise { color } =
    g
        [ id "Group-16", transform [ Translate 0 0.3447 ] ]
        [ g [ id "Group-3" ]
            [ landMask color
            , g [ id "Clip-2" ] []
            , landPath color
            ]
        , g [ id "Group-6" ]
            [ water2Mask color
            , g [ id "Clip-5" ] []
            , water2Path color
            ]
        , g [ id "Group-9" ]
            [ water3Mask color
            , g [ id "Clip-8" ] []
            , water3Path color
            ]
        , g [ id "Group-12" ]
            [ water4Mask color
            , g [ id "Clip-11" ] []
            , water4Path color
            ]
        , g [ id "Group-15" ]
            [ water1Mask color
            , g [ id "Clip14" ] []
            , water1Path color
            ]
        ]


landMask : Color -> Svg msg
landMask color =
    mask [ id "mask-2", fill <| Fill color ]
        [ use [ xlinkHref "#path-1" ]
            [ path
                [ d "M0.817,25.136 C0.817,38.943 12.01,50.136 25.817,50.136 C39.624,50.136 50.817,38.943 50.817,25.136 C50.817,11.329 39.624,0.136 25.817,0.136 C12.01,0.136 0.817,11.329 0.817,25.136"
                , id "path-1"
                ]
                []
            ]
        ]


landPath : Color -> Svg msg
landPath color =
 path
    [ d "M2.9644,50.8984 L2.9644,45.7534 C3.1054,45.7184 3.2514,45.6574 3.3994,45.6484 C4.5624,45.5884 5.7304,45.5784 6.8894,45.4784 C13.4784,44.9104 19.6144,43.0564 24.9244,38.9614 C27.9854,36.6014 30.4664,33.7304 32.2704,30.2944 C32.4184,30.0134 32.6084,29.7394 32.6834,29.4374 C32.9814,28.2394 33.9014,27.6804 34.9214,27.2524 C35.7704,26.8924 36.6544,26.6124 37.5734,26.2784 L37.5734,20.7994 C37.2174,20.7674 36.8604,20.7364 36.3484,20.6894 C38.2654,18.5444 40.2234,16.6044 42.1834,14.5534 C44.1364,16.5894 46.0364,18.5704 48.0584,20.6774 C47.5524,20.7234 47.2074,20.7554 46.8144,20.7914 L46.8144,24.9674 L54.4974,24.9674 C54.6634,25.6284 49.3824,49.9924 49.2364,50.8374 C48.6774,51.0024 4.3814,51.0734 2.9644,50.8984" 
    , fill <| Fill color
    , id "Fill-1"
    , Attr.mask "url(#mask-2)"
    ]
    []


water1Mask : Color -> Svg msg
water1Mask color =
    mask [ id "mask-10", fill <| Fill color ]
        [ use [ xlinkHref "#path-9" ]
            [ path 
                [ d "M0.817,25.136 C0.817,38.943 12.01,50.136 25.817,50.136 C39.624,50.136 50.817,38.943 50.817,25.136 C50.817,11.329 39.624,0.136 25.817,0.136 C12.01,0.136 0.817,11.329 0.817,25.136"
                , id "path-9"
                ]
                []
            ]
        ]


water1Path : Color -> Svg msg
water1Path color =
    path 
        [ d "M0.3579,28.0049 C2.4959,30.5119 4.6339,25.4989 6.7729,28.0049 C8.9109,30.5119 11.0489,25.4989 13.1879,28.0049 C15.3259,30.5119 17.4639,25.4989 19.6029,28.0049 L19.6029,27.9799 C21.7409,30.4939 23.8789,25.4639 26.0179,27.9799 C26.0179,28.0699 26.0179,28.1569 26.0169,28.2389 L26.0729,27.9869 C28.0629,30.3789 30.0529,26.0399 32.0429,27.6029 C32.2319,27.5239 32.4199,27.4439 32.6159,27.3609 L32.4339,26.5859 C30.3139,24.0389 28.1929,29.1319 26.0729,26.5859 L26.0169,26.8359 C26.0179,26.7549 26.0179,26.6679 26.0179,26.5769 C23.8789,24.0619 21.7409,29.0919 19.6029,26.5769 L19.6029,26.6019 C17.4639,24.0959 15.3259,29.1089 13.1879,26.6019 C11.0489,24.0959 8.9109,29.1089 6.7729,26.6019 C4.6339,24.0959 2.4959,29.1089 0.3579,26.6019 C-1.7811,24.0959 -3.9191,29.1089 -6.0571,26.6019 L-6.0571,28.0049 C-3.9191,30.5119 -1.7811,25.4989 0.3579,28.0049"
        , id "Fill-13"        
        , fill <| Fill color
        , Attr.mask "url(#mask-10)"
        ]
        []


water2Mask : Color -> Svg msg
water2Mask color =
    mask [ id "mask-4", fill <| Fill color ]
        [ use [ xlinkHref "#path-3" ]
            [ path 
                [ d "M0.817,25.136 C0.817,38.943 12.01,50.136 25.817,50.136 C39.624,50.136 50.817,38.943 50.817,25.136 C50.817,11.329 39.624,0.136 25.817,0.136 C12.01,0.136 0.817,11.329 0.817,25.136"
                , id "path-3"
                ]
                []
            ]
        ]


water2Path : Color -> Svg msg
water2Path color =
    path 
        [ d "M-2.8076,32.25 C-0.6696,34.756 1.4684,29.743 3.6074,32.25 C5.7454,34.756 7.8834,29.743 10.0224,32.25 C12.1604,34.756 14.2984,29.743 16.4374,32.25 L16.4374,32.224 C18.5754,34.74 20.7134,29.708 22.8524,32.224 C22.8524,32.316 22.8524,32.401 22.8514,32.483 L22.9074,32.233 C24.8974,34.623 26.8874,30.284 28.8774,31.847 C29.0664,31.769 29.2544,31.688 29.4504,31.607 L29.2684,30.83 C27.1484,28.283 25.0274,33.378 22.9074,30.83 L22.8514,31.081 C22.8524,30.999 22.8524,30.912 22.8524,30.821 C20.7134,28.306 18.5754,33.336 16.4374,30.821 L16.4374,30.848 C14.2984,28.341 12.1604,33.353 10.0224,30.848 C7.8834,28.341 5.7454,33.353 3.6074,30.848 C1.4684,28.341 -0.6696,33.353 -2.8076,30.848 C-4.9466,28.341 -7.0836,33.353 -9.2226,30.848 L-9.2226,32.25 C-7.0836,34.756 -4.9466,29.743 -2.8076,32.25"
        , id "Fill-4"        
        , fill <| Fill color
        , Attr.mask "url(#mask-4)"
        ]
        []


water3Mask : Color -> Svg msg
water3Mask color =
    mask [ id "mask-6", fill <| Fill color ]
        [ use [ xlinkHref "#path-5" ]
            [ path 
                [ d "M0.817,25.136 C0.817,38.943 12.01,50.136 25.817,50.136 C39.624,50.136 50.817,38.943 50.817,25.136 C50.817,11.329 39.624,0.136 25.817,0.136 C12.01,0.136 0.817,11.329 0.817,25.136"
                , id "path-5"
                ]
                []
            ]
        ]


water3Path : Color -> Svg msg
water3Path color =
    path 
        [ d "M-7.3037,36.7451 C-5.1657,39.2521 -3.0277,34.2391 -0.8887,36.7451 C1.2493,39.2521 3.3873,34.2391 5.5263,36.7451 C7.6643,39.2521 9.8023,34.2391 11.9403,36.7451 L11.9403,36.7211 C14.0793,39.2351 16.2173,34.2051 18.3563,36.7211 C18.3563,36.8111 18.3553,36.8981 18.3553,36.9801 L18.4113,36.7291 C20.4013,39.1191 22.3913,34.7801 24.3813,36.3441 C24.5703,36.2651 24.7583,36.1851 24.9533,36.1031 L24.7723,35.3271 C22.6513,32.7791 20.5313,37.8741 18.4113,35.3271 L18.3553,35.5771 C18.3553,35.4951 18.3563,35.4081 18.3563,35.3171 C16.2173,32.8021 14.0793,37.8321 11.9403,35.3171 L11.9403,35.3441 C9.8023,32.8371 7.6643,37.8491 5.5263,35.3441 C3.3873,32.8371 1.2493,37.8491 -0.8887,35.3441 C-3.0277,32.8371 -5.1657,37.8491 -7.3037,35.3441 C-9.4427,32.8371 -11.5807,37.8491 -13.7197,35.3441 L-13.7197,36.7451 C-11.5807,39.2521 -9.4427,34.2391 -7.3037,36.7451"
        , id "Fill-7"        
        , fill <| Fill color
        , Attr.mask "url(#mask-6)"
        ]
        []


water4Mask : Color -> Svg msg
water4Mask color =
    mask [ id "mask-8", fill <| Fill color ]
        [ use [ xlinkHref "#path-7" ]
            [ path 
                [ d "M0.817,25.136 C0.817,38.943 12.01,50.136 25.817,50.136 C39.624,50.136 50.817,38.943 50.817,25.136 C50.817,11.329 39.624,0.136 25.817,0.136 C12.01,0.136 0.817,11.329 0.817,25.136"
                , id "path-7"
                ]
                []
            ]
        ]


water4Path : Color -> Svg msg
water4Path color =
    path 
        [ d "M-11.5845,41.0264 C-9.4465,43.5324 -7.3085,38.5194 -5.1695,41.0264 C-3.0315,43.5324 -0.8935,38.5194 1.2455,41.0264 C3.3835,43.5324 5.5215,38.5194 7.6605,41.0264 L7.6605,41.0014 C9.7985,43.5164 11.9365,38.4854 14.0755,41.0014 C14.0755,41.0924 14.0755,41.1784 14.0745,41.2604 L14.1305,41.0094 C16.1205,43.4004 18.1105,39.0604 20.1005,40.6244 C20.2895,40.5454 20.4775,40.4644 20.6725,40.3834 L20.4915,39.6064 C18.3715,37.0594 16.2505,42.1544 14.1305,39.6064 L14.0745,39.8584 C14.0755,39.7754 14.0755,39.6894 14.0755,39.5974 C11.9365,37.0824 9.7985,42.1134 7.6605,39.5974 L7.6605,39.6244 C5.5215,37.1174 3.3835,42.1304 1.2455,39.6244 C-0.8935,37.1174 -3.0315,42.1304 -5.1695,39.6244 C-7.3085,37.1174 -9.4465,42.1304 -11.5845,39.6244 C-13.7235,37.1174 -15.8605,42.1304 -18.0005,39.6244 L-18.0005,41.0264 C-15.8605,43.5324 -13.7235,38.5194 -11.5845,41.0264"
        , id "Fill-10"        
        , fill <| Fill color
        , Attr.mask "url(#mask-8)"
        ]
        []


circlePath : Color -> Svg msg
circlePath color =
    path
        [ d "M50.8169,25.4804 C50.8169,39.2874 39.6239,50.4804 25.8169,50.4804 C12.0099,50.4804 0.8169,39.2874 0.8169,25.4804 C0.8169,11.6734 12.0099,0.4804 25.8169,0.4804 C39.6239,0.4804 50.8169,11.6734 50.8169,25.4804 Z"
        , id "Stroke-17"
        , stroke color
        , strokeWidth 0.962
        ]
        []