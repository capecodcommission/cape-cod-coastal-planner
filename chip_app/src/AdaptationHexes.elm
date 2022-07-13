module AdaptationHexes exposing (..)


import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (required, custom)

---
--- HEX
---


type alias AdaptationHexes = List AdaptationHex


type alias AdaptationHex =
    { id : Int
    , coastalBank : Bool
    , revetment : Bool
    , rareSpecies : Bool
    , seaLevelRise : SeaLevelRise
    , stormSurge : StormSurge
    , erosion : ErosionImpact
    , saltMarshAcres : Acreage
    , shorelinePrivateAcres : Acreage
    , privateBldgValue : MonetaryValue
    , publicBldgValue : MonetaryValue
    , numCriticalFacilities : Count
    , numHistoricalResources : Count
    , sLRRdTot : Mile
    , stormSurgeRdTot : Mile
    , erosionRdTot : Mile
    }


{-| ErosionImpact

    This type depends on the `Erosion` and `ErosionWidth` fields from the
    map service. 
    
    `A` maps to `Accreting`
    `E` maps to `Eroding`
    `null` maps to `NoErosion`
-}
type ErosionImpact
    = NoErosion
    | Accreting ImpactWidth
    | Eroding ImpactWidth



{-| SeaLevelRise

    This type depends on the `SLR` and `SLRWidth` fields from the map service.

    `Y` maps to `VulnSeaRise`
    anything else maps to `NoSeaRise`
-}
type SeaLevelRise
    = NoSeaRise
    | VulnSeaRise ImpactWidth


{-| StormSurge
    
    This type depends on the `StormSurge` and `StormSurgeAcres` fields from the
    map service.

    `Y` maps to `VulnSurge`
    anything else maps to `NoSurge`
-}
type StormSurge
    = NoSurge
    | VulnSurge Acreage


type alias ImpactWidth = Float


type alias InundationWidth = Float


type alias Acreage = Float


type alias Mile = Float


type alias MonetaryValue = Float


type alias Count = Int


--
-- CALCULATIONS AND TRANSFORMS
--


erosionImpactToFloat : ErosionImpact -> Float
erosionImpactToFloat impact =
    case impact of
        NoErosion ->
            0

        Accreting val ->
            val

        Eroding val ->
            val * -1


erosionImpactFromFloat : Float -> ErosionImpact
erosionImpactFromFloat value =
    if value > 0 then
        Accreting value
    else if value < 0 then
        Eroding value
    else
        NoErosion


seaLevelRiseToFloat : SeaLevelRise -> Float
seaLevelRiseToFloat slr =
    case slr of
        NoSeaRise -> 0

        VulnSeaRise width -> width


seaLevelRiseFromFloat : Float -> SeaLevelRise
seaLevelRiseFromFloat value =
    if value == 0 then
        NoSeaRise
    else
        VulnSeaRise <| abs value


withErosion : AdaptationHexes -> AdaptationHexes
withErosion hexes =
    hexes |> List.filter (\hex -> hex.erosion /= NoErosion)


withAccretion : AdaptationHexes -> AdaptationHexes
withAccretion hexes =
    hexes |> List.filter (\hex -> hex.erosion /= NoErosion)


withSeaLevelRise : AdaptationHexes -> AdaptationHexes
withSeaLevelRise hexes =
    hexes |> List.filter (\hex -> hex.seaLevelRise /= NoSeaRise)


withStormSurge : AdaptationHexes -> AdaptationHexes
withStormSurge hexes =
    hexes |> List.filter (\hex -> hex.stormSurge /= NoSurge)


averageErosion : AdaptationHexes -> ErosionImpact
averageErosion hexes =
    let
        hexesWithErosion = hexes |> withErosion
    in
    hexesWithErosion
        |> List.foldl (\hex acc -> (erosionImpactToFloat hex.erosion) + acc) 0.0
        |> \result ->
            ( case List.length hexesWithErosion of
                0 ->
                    NoErosion
                
                count ->
                    erosionImpactFromFloat (result / toFloat count)
            )


-- CALCULATE THE AVERAGE SEA LEVEL RISE OF ONLY THOSE HEXES TAGGED WITH `Y`
-- `Y` MAPS TO `VulnSeaRise` ANYTHING ELSE MAPS TO `NoSeaRise`
averageSeaLevelRise : AdaptationHexes -> SeaLevelRise
averageSeaLevelRise hexes =
    let
        hexesWithSLR = hexes |> withSeaLevelRise
    in
    hexesWithSLR
        |> List.foldl (\hex acc -> (seaLevelRiseToFloat hex.seaLevelRise) + acc) 0.0
        |> \result ->
            ( case List.length hexesWithSLR of
                0 ->
                    NoSeaRise

                count ->
                    seaLevelRiseFromFloat (result / toFloat count) -- WE GET THE AVERAGE HERE
            )


countCriticalFacilities : AdaptationHexes -> Int
countCriticalFacilities hexes =
    hexes
        |> List.foldl (\hex acc -> hex.numCriticalFacilities + acc) 0


isRareSpeciesHabitatPresent : AdaptationHexes -> Bool
isRareSpeciesHabitatPresent hexes =
    hexes
        |> List.any (\hex -> hex.rareSpecies == True)
countHistoricalPlaces : AdaptationHexes -> Int
countHistoricalPlaces hexes =
    hexes
        |> List.foldl (\hex acc -> hex.numHistoricalResources + acc) 0

sumSLRRdTotMile : AdaptationHexes -> Float
sumSLRRdTotMile hexes =
    hexes
        |> List.foldl (\hex acc -> hex.sLRRdTot + acc) 0.0

sumStormSurgeRdTotMile : AdaptationHexes -> Float
sumStormSurgeRdTotMile hexes =
    hexes
        |> List.foldl (\hex acc -> hex.stormSurgeRdTot + acc) 0.0

sumRdTotMile : AdaptationHexes -> Float
sumRdTotMile hexes =
    hexes
        |> List.foldl (\hex acc -> hex.erosionRdTot + acc) 0.0



isVulnerableToStormSurge : AdaptationHexes -> Bool
isVulnerableToStormSurge hexes =
    hexes
        |> List.any (\hex -> hex.stormSurge /= NoSurge)


sumPublicBldgValue : AdaptationHexes -> Float
sumPublicBldgValue hexes =
    hexes
        |> List.foldl (\hex acc -> hex.publicBldgValue + acc) 0.0


sumPrivateLandAcreage : AdaptationHexes -> Float
sumPrivateLandAcreage hexes =
    hexes
        |> List.foldl (\hex acc -> hex.shorelinePrivateAcres + acc) 0.0


sumPrivateBldgValue : AdaptationHexes -> Float
sumPrivateBldgValue hexes =
    hexes
        |> List.foldl (\hex acc -> hex.privateBldgValue + acc) 0.0


sumSaltMarshAcreage : AdaptationHexes -> Float
sumSaltMarshAcreage hexes =
    hexes
        |> List.foldl (\hex acc -> hex.saltMarshAcres + acc) 0.0


hasRevetment : AdaptationHexes -> Bool
hasRevetment hexes =
    hexes
        |> List.any (\hex -> hex.revetment == True)


hasSaltMarshAndRevetment : AdaptationHexes -> Bool
hasSaltMarshAndRevetment hexes =
    hexes
        |> List.any (\hex -> hex.saltMarshAcres > 0 && hex.revetment == True)


--
-- DECODERS ETC.
--


adaptationHexesDecoder : Decoder (List AdaptationHex)
adaptationHexesDecoder =
    D.field "features" 
        <| D.list 
        <| D.field "attributes" adaptationHexDecoder


adaptationHexDecoder : Decoder AdaptationHex
adaptationHexDecoder =
    D.succeed AdaptationHex
        |> required "hexagonID" D.int
        |> required "CoastalBank" yesOrNullToBool
        |> required "Revetment" yesOrNullToBool
        |> required "RareSpecies" yesOrNullToBool
        |> custom seaLevelRiseDecoder
        |> custom stormSurgeDecoder
        |> custom erosionImpactDecoder
        |> required "SaltMarshAcres" floatOrNullToFloat
        |> required "ShorelinePrivateAcres" floatOrNullToFloat
        |> required "SumBLDGValue" floatOrNullToFloat
        |> required "PublicBLDGValue" floatOrNullToFloat
        |> required "CritFacCount" D.int
        |> required "HistPlaceCount" D.int
        |> required "SLRRdTot" floatOrNullToFloat
        |> required "StormSurgeRdTot" floatOrNullToFloat
        |> required "ErosionRdTot" floatOrNullToFloat


erosionImpactDecoder : Decoder ErosionImpact
erosionImpactDecoder =
    D.map2 newErosionImpact
        (D.field "Erosion" <| D.maybe D.string)
        (D.field "ErosionWidth" <| D.maybe D.float)


newErosionImpact : Maybe String -> Maybe Float -> ErosionImpact
newErosionImpact erosionType erosionWidth =
    case erosionType of
        Just "A" ->
            erosionWidth 
                |> Maybe.map Accreting
                |> Maybe.withDefault NoErosion

        Just "E" ->
            erosionWidth 
                |> Maybe.map Eroding
                |> Maybe.withDefault NoErosion

        _ ->
            NoErosion


seaLevelRiseDecoder : Decoder SeaLevelRise
seaLevelRiseDecoder =
    D.map2 newSeaLevelRise
        (D.field "SLR" <| D.maybe D.string)
        (D.field "SLRWidth" <| D.maybe D.float)


newSeaLevelRise : Maybe String -> Maybe Float -> SeaLevelRise
newSeaLevelRise slr inundationWidth =
    case slr of
        Just "Y" ->
            inundationWidth 
                |> Maybe.map VulnSeaRise
                |> Maybe.withDefault NoSeaRise

        _ ->
            NoSeaRise


stormSurgeDecoder : Decoder StormSurge
stormSurgeDecoder =
    D.map2 newStormSurge
        (D.field "StormSurge" <| D.maybe D.string)
        (D.field "StormSurgeAcres" <| D.maybe D.float)


newStormSurge : Maybe String -> Maybe Float -> StormSurge
newStormSurge surge acreage =
    case surge of
        Just "Y" ->
            acreage
                |> Maybe.map VulnSurge
                |> Maybe.withDefault NoSurge

        _ ->
            NoSurge


yesOrNullToBool : Decoder Bool
yesOrNullToBool =
    D.maybe D.string
        |> D.andThen
            (\val ->
                case val of
                    Just "Y" -> D.succeed True
                    _ -> D.succeed False
            )
    

floatOrNullToFloat : Decoder Float
floatOrNullToFloat =
    D.maybe D.float
        |> D.andThen
            (\val ->
                val |> Maybe.withDefault 0 |> D.succeed        
            )

    