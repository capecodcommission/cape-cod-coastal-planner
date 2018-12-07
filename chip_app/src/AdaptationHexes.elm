module AdaptationHexes exposing (..)


import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required, custom)

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

-- withoutErosion : AdaptationHexes -> AdaptationHexes
-- withoutErosion hexes =
--     hexes |> List.filter (\hex -> hex.erosion /= Eroding)


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


countCriticalFacilitiesSLR : AdaptationHexes -> Int
countCriticalFacilitiesSLR hexes =
    let
        hexesWithSLR = hexes |> withSeaLevelRise
    in
    hexesWithSLR
        |> List.foldl (\hex acc -> hex.numCriticalFacilities + acc) 0

countCriticalFacilitiesEroding : AdaptationHexes -> Int
countCriticalFacilitiesEroding hexes =
    let
        hexesWithEroding = hexes |> withErosion
    in
    hexesWithEroding
        |> List.foldl (\hex acc -> hex.numCriticalFacilities + acc) 0


isRareSpeciesHabitatPresent : AdaptationHexes -> Bool
isRareSpeciesHabitatPresent hexes =
    hexes
        |> List.any (\hex -> hex.rareSpecies == True)


-- INDICATE IF RARE SPECIES ARE PRESENT WITH
-- ONLY THE HEXES WITH SLR TAGGED WITH `Y`
isRareSpeciesHabitatPresentSLR : AdaptationHexes -> Bool
isRareSpeciesHabitatPresentSLR hexes =
    let
        hexesWithSLR = hexes |> withSeaLevelRise
    in
    hexesWithSLR
        |> List.any (\hex -> hex.rareSpecies == True)


-- INDICATE IF RARE SPECIES ARE PRESENT WITH
-- ONLY THE HEXES WITH EROSION TAGGED WITH `E`
isRareSpeciesHabitatPresentEroding : AdaptationHexes -> Bool
isRareSpeciesHabitatPresentEroding hexes =
    let
        hexesWithEroding = hexes |> withErosion
    in
    hexesWithEroding
        |> List.any (\hex -> hex.rareSpecies == True)


isVulnerableToStormSurge : AdaptationHexes -> Bool
isVulnerableToStormSurge hexes =
    hexes
        |> List.any (\hex -> hex.stormSurge /= NoSurge)


sumPublicBldgValue : AdaptationHexes -> Float
sumPublicBldgValue hexes =
    hexes
        |> List.foldl (\hex acc -> hex.publicBldgValue + acc) 0.0


-- CALCULATE THE SUM OF PUBLIC BUIDLING VALUES WITH
-- ONLY THE HEXES WITH SLR TAGGED WITH `Y`
sumPublicBldgValueSLR : AdaptationHexes -> Float
sumPublicBldgValueSLR hexes =
    let
        hexesWithSLR = hexes |> withSeaLevelRise
    in
    hexesWithSLR
        |> List.foldl (\hex acc -> hex.publicBldgValue + acc) 0.0

-- CALCULATE THE SUM OF PUBLIC BUIDLING VALUES WITH
-- ONLY THE HEXES WITH STORM SURGE TAGGED WITH `Y`
sumPublicBldgValueStormSurge : AdaptationHexes -> Float
sumPublicBldgValueStormSurge hexes =
    let
        hexesWithStormSurge = hexes |> withStormSurge
    in
    hexesWithStormSurge
        |> List.foldl (\hex acc -> hex.publicBldgValue + acc) 0


-- CALCULATE THE SUM OF PUBLIC BUIDLING VALUES WITH
-- ONLY THE HEXES WITH EROSION TAGGED WITH `E`
sumPublicBldgValueEroding : AdaptationHexes -> Float
sumPublicBldgValueEroding hexes =
    let
        hexesWithEroding = hexes |> withErosion
    in
    hexesWithEroding
        |> List.foldl (\hex acc -> hex.publicBldgValue + acc) 0


sumPrivateLandAcreage : AdaptationHexes -> Float
sumPrivateLandAcreage hexes =
    hexes
        |> List.foldl (\hex acc -> hex.shorelinePrivateAcres + acc) 0.0


-- CALCULATE THE SUM OF PRIVATE LAND ACRES WITH
-- ONLY THE HEXES WITH SLR TAGGED WITH `Y`
sumPrivateLandAcreageSLR : AdaptationHexes -> Float
sumPrivateLandAcreageSLR hexes =
    let
        hexesWithSLR = hexes |> withSeaLevelRise
    in
    hexesWithSLR
        |> List.foldl (\hex acc -> hex.shorelinePrivateAcres + acc) 0.0


-- CALCULATE THE SUM OF PRIVATE LAND ACRES WITH
-- ONLY THE HEXES WITH EROSION TAGGED WITH `E`
sumPrivateLandAcreageEroding : AdaptationHexes -> Float
sumPrivateLandAcreageEroding hexes =
    let
        hexesWithEroding = hexes |> withErosion
    in
    hexesWithEroding
        |> List.foldl (\hex acc -> hex.shorelinePrivateAcres + acc) 0


sumPrivateBldgValue : AdaptationHexes -> Float
sumPrivateBldgValue hexes =
    hexes
        |> List.foldl (\hex acc -> hex.privateBldgValue + acc) 0.0


-- CALCULATE THE SUM OF PRIVATE BUILDING VALUES WITH
-- ONLY THE HEXES WITH SLR TAGGED WITH `Y`
sumPrivateBldgValueSLR : AdaptationHexes -> Float
sumPrivateBldgValueSLR hexes =
    let
        hexesWithSLR = hexes |> withSeaLevelRise
    in
    hexesWithSLR
        |> List.foldl (\hex acc -> hex.privateBldgValue + acc) 0.0


-- CALCULATE THE SUM OF PRIVATE BUIDLING VALUES WITH
-- ONLY THE HEXES WITH STORM SURGE TAGGED WITH `Y`
sumPrivateBldgValueStormSurge : AdaptationHexes -> Float
sumPrivateBldgValueStormSurge hexes =
    let
        hexesWithStormSurge = hexes |> withStormSurge
    in
    hexesWithStormSurge
        |> List.foldl (\hex acc -> hex.privateBldgValue + acc) 0


-- CALCULATE THE SUM OF PRIVATE BUIDLING VALUES WITH
-- ONLY THE HEXES WITH EROSION TAGGED WITH `E`
sumPrivateBldgValueEroding : AdaptationHexes -> Float
sumPrivateBldgValueEroding hexes =
    let
        hexesWithEroding = hexes |> withErosion
    in
    hexesWithEroding
        |> List.foldl (\hex acc -> hex.privateBldgValue + acc) 0

sumSaltMarshAcreage : AdaptationHexes -> Float
sumSaltMarshAcreage hexes =
    hexes
        |> List.foldl (\hex acc -> hex.saltMarshAcres + acc) 0.0


-- CALCULATE THE SUM OF SALT MARSH ACRES WITH
-- ONLY THE HEXES WITH SLR TAGGED WITH `Y`
sumSaltMarshAcreageSLR : AdaptationHexes -> Float
sumSaltMarshAcreageSLR hexes =
    let
        hexesWithSLR = hexes |> withSeaLevelRise
    in
    hexesWithSLR
        |> List.foldl (\hex acc -> hex.saltMarshAcres + acc) 0.0


-- CALCULATE THE SUM OF SALT MARSH ACRES WITH
-- ONLY THE HEXES WITH EROSION TAGGED WITH `E`
sumSaltMarshAcreageEroding : AdaptationHexes -> Float
sumSaltMarshAcreageEroding hexes =
    let
        hexesWithEroding = hexes |> withErosion
    in
    hexesWithEroding
        |> List.foldl (\hex acc -> hex.saltMarshAcres + acc) 0


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
    decode AdaptationHex
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

    