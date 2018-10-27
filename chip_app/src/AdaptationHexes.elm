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
    , numCriticalFacilities : Int
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
    | Accreting ErosionWidth
    | Eroding ErosionWidth


erosionImpactToFloat : ErosionImpact -> Float
erosionImpactToFloat impact =
    case impact of
        NoErosion ->
            0

        Accreting val ->
            val

        Eroding val ->
            val * -1


{-| SeaLevelRise

    This type depends on the `SLR` and `SLRWidth` fields from the map service.

    `Y` maps to `VulnSeaRise`
    anything else maps to `NoSeaRise`
-}
type SeaLevelRise
    = NoSeaRise
    | VulnSeaRise InundationWidth


{-| StormSurge
    
    This type depends on the `StormSurge` and `StormSurgeAcres` fields from the
    map service.

    `Y` maps to `VulnSurge`
    anything else maps to `NoSurge`
-}
type StormSurge
    = NoSurge
    | VulnSurge Acreage


type alias ErosionWidth = Float


type alias InundationWidth = Float


type alias Acreage = Float


type alias MonetaryValue = Float



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

    