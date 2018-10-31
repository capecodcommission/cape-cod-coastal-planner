module AdaptationOutput exposing (..)

import Http
import AdaptationStrategy.Impacts exposing (..)
import AdaptationHexes exposing (..)


type AdaptationOutput 
    = NotCalculated
    | CalculatingOutput
    | OnlyNoAction OutputDetails
    | WithStrategy OutputDetails OutputDetails


type OutputError
    = BadInput String
    | HexHttpError Http.Error
    | CalculationError (List String)


type alias OutputDetails =
    { name : String
    , scales : List ImpactScale
    , cost : Maybe ImpactCost
    , lifespan : Maybe ImpactLifeSpan
    , hazard : String
    , location : String
    , duration : String
    , scenarioSize : Int
    , criticalFacilities : CriticalFacilities
    , publicBuildingValue : MonetaryResult
    , privateLandValue : MonetaryResult
    , privateBuildingValue : MonetaryResult
    , saltMarshChange : AcreageResult
    , beachAreaChange : AcreageResult
    , rareSpeciesHabitat : RareSpeciesHabitat
    }


defaultOutput : OutputDetails
defaultOutput =
    { name = ""
    , scales = []
    , cost = Nothing
    , lifespan = Nothing
    , hazard = ""
    , location = ""
    , duration = ""
    , scenarioSize = 0
    , criticalFacilities = FacilitiesUnchanged
    , publicBuildingValue = ValueUnchanged
    , privateLandValue = ValueUnchanged
    , privateBuildingValue = ValueUnchanged
    , saltMarshChange = AcreageUnchanged
    , beachAreaChange = AcreageUnchanged
    , rareSpeciesHabitat = HabitatUnchanged
    }


type MonetaryResult
    = ValueLoss MonetaryValue
    | ValueProtected MonetaryValue
    | ValueUnchanged


isValueUnchanged : MonetaryResult -> Bool
isValueUnchanged result =
    case result of
        ValueUnchanged -> True
        _ -> False


isValueLoss : MonetaryResult -> Bool
isValueLoss result =
    case result of
        ValueLoss _ -> True
        _ -> False


isValueProtected : MonetaryResult -> Bool
isValueProtected result =
    case result of
        ValueProtected _ -> True
        _ -> False


monetaryValueToResult : MonetaryValue -> MonetaryResult
monetaryValueToResult value =
    if value < 0 then
        ValueLoss value
    else if value > 0 then
        ValueProtected value
    else
        ValueUnchanged


type AcreageResult
    = AcreageLost Acreage
    | AcreageGained Acreage
    | AcreageUnchanged


acreageToAcreageResult : Acreage -> AcreageResult
acreageToAcreageResult acreage =
    if acreage < 0 then 
        AcreageLost acreage
    else if acreage > 0 then
        AcreageGained acreage
    else
        AcreageUnchanged


type CriticalFacilities
    = FacilitiesLost Int
    | FacilitiesProtected Int
    | FacilitiesUnchanged
    | FacilitiesPresent


countToCriticalFacilities : Int -> CriticalFacilities
countToCriticalFacilities count =
    if count < 0 then
        FacilitiesLost count
    else if count > 0 then
        FacilitiesProtected count
    else
        FacilitiesUnchanged


boolToCriticalFacilities : Bool -> CriticalFacilities
boolToCriticalFacilities presence =
    if presence then
        FacilitiesPresent
    else
        FacilitiesUnchanged


type RareSpeciesHabitat
    = HabitatLost
    | HabitatGained
    | HabitatUnchanged