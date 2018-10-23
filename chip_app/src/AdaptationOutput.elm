module AdaptationOutput exposing (..)


import AdaptationStrategy exposing (..)
import AdaptationHexes exposing (..)


type alias AdaptationOutput =
    { strategy : Strategy
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


