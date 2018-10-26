module AdaptationOutput exposing (..)

import Http
import AdaptationStrategy.Impacts exposing (..)
import AdaptationHexes exposing (..)


type AdaptationOutput 
    = NotCalculated
    | CalculatingOutput
    | BadInput
    | OnlyNoAction OutputDetails
    | WithStrategy OutputDetails OutputDetails
    | HexHttpError Http.Error
    | CalculationError (List String)  


type alias OutputDetails =
    { name : String
    , scales : List ImpactScale
    , cost : ImpactCost
    , lifespan : ImpactLifeSpan
    , hazard : String
    , location : String
    , duration : Duration
    , scenarioSize : Float
    , publicBuildingValue : MonetaryResult
    , privateLandValue : MonetaryResult
    , privateBuildingValue : MonetaryResult
    , saltMarshChange : AcreageResult
    , beachAreaChange : AcreageResult
    , criticalFacilities : CriticalFacilities
    , rareSpeciesHabitat : RareSpeciesHabitat
    }


type MonetaryResult
    = ValueLoss MonetaryValue
    | ValueProtected MonetaryValue


type AcreageResult
    = AcreageLost Acreage
    | AcreageGained Acreage
    | AcreageUnchanged


type CriticalFacilities
    = FacilitiesLost Int
    | FacilitiesProtected Int
    | FacilitiesUnchanged


type RareSpeciesHabitat
    = HabitatLost
    | HabitatGained
    | HabitatUnchanged


type Duration
    = FortyYears
    | OneTimeEvent


toMaybe : AdaptationOutput -> Maybe AdaptationOutput
toMaybe output =
    case output of
        NotCalculated -> 
            Nothing

        _ ->
            Just output

