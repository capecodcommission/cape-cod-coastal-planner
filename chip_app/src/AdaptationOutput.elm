module AdaptationOutput exposing (..)

import Http
import Graphqelm.Http as GHttp
import AdaptationStrategy.StrategyDetails exposing (StrategyDetails)
import AdaptationStrategy.Impacts exposing (..)
import AdaptationHexes exposing (..)


type AdaptationOutput 
    = NotCalculated
    | CalculatingOutput
    | OnlyNoAction OutputDetails
    | WithStrategy OutputDetails OutputDetails


type OutputError
    = BadInput String
    | DetailsGHttpError (GHttp.Error (Maybe StrategyDetails))
    | HexHttpError Http.Error
    | CalculationError String


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


type MonetaryResult
    = ValueLoss MonetaryValue
    | ValueProtected MonetaryValue
    | ValueUnchanged


type AcreageResult
    = AcreageLost Acreage
    | AcreageGained Acreage
    | AcreageUnchanged


type CriticalFacilities
    = FacilitiesLost Int
    | FacilitiesProtected Int
    | FacilitiesUnchanged Int
    | FacilitiesPresent Int
    | FacilitiesRelocated Int


type RareSpeciesHabitat
    = HabitatLost
    | HabitatGained
    | HabitatUnchanged



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
    , criticalFacilities = FacilitiesUnchanged 0
    , publicBuildingValue = ValueUnchanged
    , privateLandValue = ValueUnchanged
    , privateBuildingValue = ValueUnchanged
    , saltMarshChange = AcreageUnchanged
    , beachAreaChange = AcreageUnchanged
    , rareSpeciesHabitat = HabitatUnchanged
    }


monetaryValueToResult : MonetaryValue -> MonetaryResult
monetaryValueToResult value =
    if value < 0 then
        ValueLoss value
    else if value > 0 then
        ValueProtected value
    else
        ValueUnchanged


acreageToAcreageResult : Acreage -> AcreageResult
acreageToAcreageResult acreage =
    if acreage < 0 then 
        AcreageLost acreage
    else if acreage > 0 then
        AcreageGained acreage
    else
        AcreageUnchanged


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


getCriticalFacilityCount : OutputDetails -> Int
getCriticalFacilityCount { criticalFacilities } =
    case criticalFacilities of
        FacilitiesLost count -> count
        FacilitiesProtected count -> count
        FacilitiesUnchanged count -> count
        FacilitiesPresent count -> count
        FacilitiesRelocated count -> count


getMonetaryValue : MonetaryResult -> MonetaryValue
getMonetaryValue result =
    case result of
        ValueLoss value -> 
            if value > 0 then value * -1 else value
        ValueProtected value -> value
        ValueUnchanged -> 0.0


getAcreageChange : AcreageResult -> Acreage
getAcreageChange result =
    case result of
        AcreageLost value ->
            if value > 0 then value * -1 else value 

        AcreageGained value -> value

        AcreageUnchanged -> 0


adjustAcreageResult : Acreage -> AcreageResult -> Acreage
adjustAcreageResult acreage result =
    (getAcreageChange result) + acreage


getRareSpeciesPresence : RareSpeciesHabitat -> Bool
getRareSpeciesPresence habitat =
    case habitat of
        HabitatLost -> True
        HabitatGained -> True
        HabitatUnchanged -> False