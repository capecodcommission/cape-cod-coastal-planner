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
    , saltMarshValue : MonetaryResult
    , beachAreaChange : AcreageResult
    , beachAreaValue : MonetaryResult
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
    , saltMarshValue = ValueUnchanged
    , beachAreaChange = AcreageUnchanged
    , beachAreaValue = ValueUnchanged
    , rareSpeciesHabitat = HabitatUnchanged
    }


type MonetaryResult
    = ValueLoss MonetaryValue
    | ValueProtected MonetaryValue
    | ValueUnchanged


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


countToCriticalFacilities : Int -> CriticalFacilities
countToCriticalFacilities count =
    if count < 0 then
        FacilitiesLost count
    else if count > 0 then
        FacilitiesProtected count
    else
        FacilitiesUnchanged


type RareSpeciesHabitat
    = HabitatLost
    | HabitatGained
    | HabitatUnchanged


toMaybe : AdaptationOutput -> Maybe AdaptationOutput
toMaybe output =
    case output of
        NotCalculated -> 
            Nothing

        _ ->
            Just output

