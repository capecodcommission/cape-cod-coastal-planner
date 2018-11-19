module View.StrategyResults exposing (..)

import Message exposing (..)
import Element exposing (..)
import Element.Attributes as Attr exposing (..)
import Element.Events exposing (..)
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (Locale, usLocale)
import Graphics.Erosion exposing (erosionIcon, erosionIconConfig)
import Graphics.SeaLevelRise exposing (seaLevelRiseIcon, seaLevelRiseIconConfig)
import Graphics.StormSurge exposing (stormSurgeIcon, stormSurgeIconConfig)
import View.Helpers exposing (title, parseErrors, parseHttpError)
import Styles exposing (..)
import AdaptationStrategy.CoastalHazards as Hazards
import AdaptationStrategy.Impacts as Impacts
import AdaptationOutput exposing (..)


view : Result OutputError AdaptationOutput -> Element MainStyles Variations Msg
view result =
    column NoStyle
        [ height fill, width fill ]
        ( case result of
            Ok NotCalculated ->
                [ el NoStyle [ height fill ] empty, footerView ]

            Ok CalculatingOutput ->
                [ el NoStyle [ height fill ] empty, footerView ]

            Ok (OnlyNoAction output) ->
                [ resultsHeader output
                , resultsMainContent output
                , footerView 
                ]

            Ok (ShowNoAction noActionOutput strategyOutput) ->
                [ toggleToStrategy ( noActionOutput, strategyOutput )
                , resultsHeader noActionOutput
                , resultsMainContent noActionOutput
                , footerView
                ]

            Ok (ShowStrategy noActionOutput strategyOutput) ->
                [ toggleToNoAction ( noActionOutput, strategyOutput )
                , resultsHeader strategyOutput
                , resultsMainContent strategyOutput
                , footerView
                ]

            Err (BadInput err) ->
                [ errorView
                    "Bad Input"
                    [ err ]
                , footerView 
                ]

            Err (DetailsGHttpError ghttpError) ->
                [ parseErrors ghttpError
                    |> List.head
                    |> Maybe.withDefault ("GraphQL Error", "Could not fetch Stratgy Details from GraphQL API")
                    |> (\(errTitle, errMsg) -> errorView errTitle [ errMsg ])
                , footerView
                ]

            Err (HexHttpError httpError) ->
                [ parseHttpError httpError
                    |> (\(errTitle, errMsg) -> errorView errTitle [ errMsg ])
                , footerView 
                ]

            Err (CalculationError err) ->
                [ errorView
                    "Failed to calculate output."
                    [ err ]
                , footerView 
                ]
        )
    

toggleToStrategy : ( OutputDetails, OutputDetails ) -> Element MainStyles Variations Msg
toggleToStrategy (( noActionOutput, strategyOutput ) as output) =
    row NoStyle [ height (px 35) ]
        [ el (ShowOutput OutputToggleLbl) 
            [ width (percent 35) ] <|
                el NoStyle [verticalCenter, center] (text "NO ACTION")
        , button (ShowOutput OutputToggleBtn)
            [ onClick <| ShowStrategyOutput output 
            , width (percent 65)
            ] <| 
            el NoStyle [] (text <| String.toUpper strategyOutput.name)
        ]


toggleToNoAction : ( OutputDetails, OutputDetails ) -> Element MainStyles Variations Msg
toggleToNoAction (( noActionOutput, strategyOutput ) as output) =
    row NoStyle [ height (px 35) ]
        [ button (ShowOutput OutputToggleBtn)
            [ onClick <| ShowNoActionOutput output 
            , width (percent 35)
            ] <| 
            el NoStyle [] (text "NO ACTION")
        , el (ShowOutput OutputToggleLbl)
            [ width (percent 65) ] <| 
                el NoStyle [verticalCenter, center] (text <| String.toUpper strategyOutput.name)
        ]


resultsHeader : OutputDetails -> Element MainStyles Variations Msg
resultsHeader output =
    let
        scaleDisabled a = vary Disabled (not <| Impacts.hasScale a output.scales)
    in
    header (ShowOutput OutputHeader) [ height (px 125) ] <|
        column NoStyle [ height fill, width fill, paddingLeft 25, paddingRight 25, paddingTop 15, paddingBottom 10 ]
            [ row NoStyle 
                [ height (percent 45), width fill, spacingXY 15 0 ]
                [ el (ShowOutput OutputDivider) [ width (px 90), verticalCenter ] <|
                    paragraph NoStyle [] [ text "SELECTED STRATEGY" ]
                , h5 (Headings H5) [ verticalCenter ] <|
                    ( el NoStyle [] (text output.name)
                        |> within [ infoIconView output.description ]
                    )
                ]
            , row NoStyle [ height (percent 55), width fill, spread, alignBottom ]
                [ column NoStyle [center ]
                    [ el (ShowOutput OutputImpact) 
                        [ moveUp 2, paddingXY 4 2, minWidth (px 115) ] <| text output.cost.name
                    , el NoStyle [ moveDown 3 ] (text "COST")
                        |> within [ infoIconView (Just "...") ]
                    ]
                , column NoStyle [center]
                    [ el (ShowOutput OutputImpact) 
                        [ moveUp 2, paddingXY 4 2, minWidth (px 115), vary Secondary True ] <| text output.lifespan.name
                    , el NoStyle [ moveDown 3 ] (text "LIFESPAN")
                        |> within [ infoIconView (Just "...") ]
                    ]
                , column NoStyle [center]                    
                    [ column NoStyle []
                        [ row NoStyle [ minWidth (px 115) ]
                            [ el (ShowOutput OutputMultiImpact) 
                                [ paddingXY 4 0 
                                , scaleDisabled "Site"
                                ] <| text "Site"
                            , el (ShowOutput OutputMultiImpact) 
                                [ paddingXY 4 0
                                , vary Secondary True 
                                , scaleDisabled "Neighborhood"
                                ] <| text "Neighborhood"
                            ]
                        , row NoStyle [ minWidth (px 115) ]
                            [ el (ShowOutput OutputMultiImpact) 
                                [ paddingXY 4 0
                                , vary Tertiary True 
                                , scaleDisabled "Community"
                                ] <| text "Community"
                            , el (ShowOutput OutputMultiImpact) 
                                [ paddingXY 4 0
                                , vary Quaternary True
                                , scaleDisabled "Region"
                                ] <| text "Region"
                            ]
                        ]
                    , el NoStyle [ moveDown 3 ] (text "SCALE")
                        |> within [ infoIconView (Just "...") ]
                    ]
                ]
            ]


resultsMainContent : OutputDetails -> Element MainStyles Variations Msg
resultsMainContent output =
    column NoStyle [ height fill ]
        [ scenarioGeneralInfoView output
        , column NoStyle [ paddingXY 20 0 ]
            [ h6 (ShowOutput OutputH6Bold) [] <| text "SCENARIO OUTPUTS"
            , paragraph (ShowOutput OutputSmallItalic) [] 
                [ text "All outputs are relative to the user"
                , text " taking no action within the planning area." 
                ]
            ]
        , row NoStyle [ paddingXY 40 20, spread, height fill ]
            [ monetaryResultView "Public Building" "Value" output.publicBuildingValue
            , monetaryResultView "Private Shoreline" "Land Value" output.privateLandValue
            , monetaryResultView "Private Building" "Value" output.privateBuildingValue
            ]
        , row NoStyle [ paddingXY 40 20, width fill, height fill ]
            [ acreageResultView "Salt Marsh Change" output.saltMarshChange
            , acreageResultView "Beach Area Change" output.beachAreaChange
            ]
        , row NoStyle [spread, height fill, width fill]
            [ criticalFacilitiesView output.criticalFacilities
            , rareSpeciesHabitatView output.rareSpeciesHabitat
            ]
        ]


scenarioGeneralInfoView : OutputDetails -> Element MainStyles Variations Msg
scenarioGeneralInfoView output =
    let
        renderDetails a b c d =
            row NoStyle [ spacingXY 8 0 ] <|
                case c of
                    Just cText ->
                        [ el (ShowOutput ScenarioLabel) [ verticalCenter ] (text a)
                        , el (ShowOutput ScenarioBold) [ verticalCenter ] (text b)
                        , el NoStyle [ verticalCenter ] (text cText)
                            |> within [ infoIconView d ]
                        ]

                    Nothing ->
                        [ el (ShowOutput ScenarioLabel) [ verticalCenter ] (text a)
                        , el (ShowOutput ScenarioBold) [ verticalCenter ] (text b)
                            |> within [ infoIconView d ]
                        ]
                
    in
    row NoStyle [ height (px 125), paddingXY 25 30 ]
        [ el (ShowOutput OutputDivider) [ width (px 180), height fill, paddingRight 10 ] <|
            row NoStyle [height fill, spacingXY 8 0]
                [ el NoStyle [ center, verticalCenter, height fill  ] <|
                    ( case Hazards.toTypeFromStr output.hazard of
                        Ok Hazards.Erosion ->
                            erosionIconConfig |> erosionIcon |> html 

                        Ok Hazards.SeaLevelRise ->
                            seaLevelRiseIconConfig |> seaLevelRiseIcon |> html

                        Ok Hazards.StormSurge ->
                            stormSurgeIconConfig |> stormSurgeIcon |> html

                        Err _ ->
                            empty
                    )
                , column NoStyle [ width fill, verticalCenter ]
                    [ el NoStyle [] <| paragraph (ShowOutput OutputAddresses) [] [ text "SCENARIO ADDRESSES" ]
                    , el NoStyle [] <| paragraph (ShowOutput OutputHazard) [] [ text output.hazard ]
                    ]
                ]
        , column NoStyle [ paddingLeft 15, spacingXY 0 4 ]
            [ renderDetails "LOCATION:" output.location (Just "area") Nothing
            , renderDetails "DURATION:" output.duration Nothing (Just "...")
            , renderDetails "SCENARIO SIZE:" (toString output.scenarioSize) (Just "linear ft.") (Just "...")
            ]
        ]


monetaryResultView : String -> String -> MonetaryResult -> Element MainStyles Variations Msg
monetaryResultView lblPart1 lblPart2 result =
    let
        render a ( b, c ) d e f =
            column NoStyle [ spacing 5, verticalCenter ]
                [ el (ShowOutput OutputValue) [ center, f ] <| text a 
                , el (ShowOutput OutputValueLbl) [ center, f ] (text b)
                    |> within [ infoIconView c ]
                , h6 (ShowOutput OutputH6Bold) [ center ] <| text d
                , h6 (ShowOutput OutputH6Bold) [ center ] <| text e
                ]
    in
    case result of
        ValueUnchanged ->
            render "--" ("NO CHANGE", Just "...") lblPart1 lblPart2 (vary Secondary False)
            
        ValueNoLongerPresent ->
            render "--" ("NO LONGER PRESENT", Just "...") lblPart1 lblPart2 (vary Secondary False)

        ValueTransferred transfer ->
            render (abbreviateMonetaryValue transfer) ("TRANSFERRED", Just "...") lblPart1 lblPart2 (vary Tertiary True)

        ValueLoss lost ->
            render (abbreviateMonetaryValue lost) ("LOST", Just "...") lblPart1 lblPart2 (vary Secondary True)

        ValueProtected protected ->
            render (abbreviateMonetaryValue protected) ("PROTECTED", Just "...") lblPart1 lblPart2 (vary Tertiary True)


acreageResultView : String -> AcreageResult -> Element MainStyles Variations Msg
acreageResultView lbl result =
    let
        render a ( b, c ) d e =
            column NoStyle [ spacing 5, width fill, verticalCenter ]
                [ h6 (ShowOutput OutputH6Bold) [ center ] <| text d
                , el (ShowOutput OutputValueLbl) [ center, e ] (text b)
                    |> within [ infoIconView c ]
                , el (ShowOutput OutputValue) [ center, e ] <| text a
                ]
    in
    case result of
        AcreageUnchanged ->
            render "--" ( "NO CHANGE", Just "..." ) lbl (vary Secondary False)

        AcreageLost loss ->
            render (abbreviateAcreageValue loss) ( "ACRES LOST", Just "..." ) lbl (vary Secondary True)

        AcreageGained gain ->
            render (abbreviateAcreageValue gain) ( "ACRES GAINED", Just "..." ) lbl (vary Tertiary True)


criticalFacilitiesView : CriticalFacilities -> Element MainStyles Variations Msg
criticalFacilitiesView facilities =
    let
        render a b c =
            column (ShowOutput OutputValueBox)
                [ moveRight 15
                , height (px 58)
                , width (px 58) 
                , center
                , verticalCenter
                , c
                ]
                [ el NoStyle [] <| text a
                , el NoStyle [] <| b
                ]
    in
    row NoStyle [ height fill, width fill, center, verticalCenter ]
        [ column (ShowOutput OutputDivider) [ spacing 5, paddingRight 15 ]
            [ el (ShowOutput OutputH6Bold) [ alignRight ] <| text "Critical"
            , el (ShowOutput OutputH6Bold) [ alignRight ] <| text "Facilities"
            ]
        , ( case facilities of
            FacilitiesUnchanged num ->
                render "--" empty (vary Secondary False)

            FacilitiesLost num ->
                render (toString num) (text "LOST") (vary Secondary True)

            FacilitiesProtected num ->
                render (toString num) (text "PROT.") (vary Tertiary True)

            FacilitiesPresent num ->
                render (toString num) empty (vary Secondary False)

            FacilitiesRelocated num ->
                render (toString num) (text "RELOC.") (vary Tertiary True)
          )
            |> within [ infoIconView (Just "...") ]
        ]


rareSpeciesHabitatView : RareSpeciesHabitat -> Element MainStyles Variations Msg
rareSpeciesHabitatView habitat =
    let
        render a b =
            column (ShowOutput OutputValueBox) 
                [ moveRight 15
                , height (px 58)
                , width (px 58) 
                , center
                , verticalCenter
                , b
                ] 
                [ el NoStyle [] <| text a ]
    in
    row NoStyle [ height fill, width fill, center, verticalCenter ]
        [ column (ShowOutput OutputDivider) [ spacing 5, paddingRight 15 ]
            [ el (ShowOutput OutputH6Bold) [ alignRight ] <| text "Rare Species"
            , el (ShowOutput OutputH6Bold) [ alignRight ] <| text "Habitat"
            ]
        , ( case habitat of
            HabitatUnchanged ->
                render "--" (vary Secondary False)

            HabitatLost ->
                render "LOSS" (vary Secondary True)

            HabitatGained ->
                render "GAIN" (vary Tertiary True)
          )
            |> within [ infoIconView (Just "...") ]
        ]


errorView : String -> List String -> Element MainStyles Variations Msg
errorView errTitle errMsgs =
    el NoStyle [ height fill, verticalCenter ] <|
        el NoStyle [ verticalCenter, paddingXY 15 0 ] <|
            textLayout NoStyle []
                [ paragraph NoStyle [] 
                    [ text <| "Error: " ++ errTitle ]
                , paragraph NoStyle []
                    (errMsgs |> List.intersperse " " |> List.map text)
                ]


footerView : Element MainStyles Variations Msg
footerView =
    footer (Sidebar SidebarFooter) [ alignBottom, height (px 90) ] <|
        row NoStyle
            [ spread, verticalCenter, width fill, height fill, paddingXY 32 0 ]
            [ button ActionButton
                [ onClick PickStrategy
                , width (px 175)
                , height (px 42)
                , title "Back to strategy selection"
                ] <| text "back"
            , button CancelButton
                [ onClick CancelPickStrategy
                , width (px 175) 
                , height (px 42)
                , title "Clear strategy selection"
                ] <| text "clear"
            ]
    

infoIconView : Maybe String -> Element MainStyles Variations Msg
infoIconView maybeHelpText =
    case maybeHelpText of
        Just helpText ->
            circle 6 (ShowOutput OutputInfoIcon) 
                [ title helpText, alignRight, moveRight 18 ] <| 
                    el NoStyle [verticalCenter, center] (text "i")

        Nothing ->
            empty        


abbreviateAcreageValue : Float -> String
abbreviateAcreageValue num =
    format usLocale num


abbreviateMonetaryValue : Float -> String
abbreviateMonetaryValue =
    formatMonetaryValue monetaryAbbreviations


monetaryAbbreviations : List String
monetaryAbbreviations =
    [ "", "K", "M", "B" ]


formatMonetaryValue : List String -> Float -> String
formatMonetaryValue abbrs num =
    let
        result = abs num / 1000.0

        fmt abbr n = format (Locale 1 "," "." "$" abbr "$" abbr) n
    in
    case abbrs of
        [] ->
            "--"

        head :: [] ->
            if result < 1.0 then
                fmt head num
            else
                fmt head result

        head :: tail ->
            if result < 1.0 then
                fmt head num
            else
                formatMonetaryValue tail result


    