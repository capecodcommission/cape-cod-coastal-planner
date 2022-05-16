module AdaptationOutput exposing (..)

import Http
import Graphql.Http as GHttp
import AdaptationStrategy.StrategyDetails exposing (StrategyDetails)
import AdaptationStrategy.Impacts exposing (..)
import AdaptationHexes exposing (..)


type AdaptationOutput 
    = NotCalculated
    | CalculatingOutput
    | OnlyNoAction OutputDetails
    | ShowNoAction OutputDetails OutputDetails
    | ShowStrategy OutputDetails OutputDetails


type OutputError
    = BadInput String
    | DetailsGHttpError (GHttp.Error (Maybe StrategyDetails))
    | HexHttpError Http.Error
    | CalculationError String


type alias OutputDetails =
    { name : String
    , description : Maybe String
    , scales : List ImpactScale
    , cost : ImpactCost
    , lifespan : ImpactLifeSpan
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
    , historicalPlaces : HistoricalPlaces
    }


type MonetaryResult
    = ValueLoss MonetaryValue
    | ValueProtected MonetaryValue
    | ValueTransferred MonetaryValue
    | ValueUnchanged
    | ValueNoLongerPresent


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


type HistoricalPlaces
    = HistoricalPlacesLost Int
    | HistoricalPlacesProtected Int
    | HistoricalPlacesUnchanged Int
    | HistoricalPlacesPresent Int
    | HistoricalPlacesRelocated Int


defaultOutput : OutputDetails
defaultOutput =
    { name = ""
    , description = Nothing
    , scales = []
    , cost = ImpactCost "N/A" -1 Nothing 
    , lifespan = ImpactLifeSpan "N/A" -1 Nothing
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
    , historicalPlaces = HistoricalPlacesUnchanged 0
    }


monetaryValueToResult : MonetaryValue -> MonetaryResult
monetaryValueToResult value =
    if value < 0 then
        ValueLoss value
    else if value > 0 then
        ValueProtected value
    else
        ValueUnchanged


getCriticalFacilityCount : OutputDetails -> Int
getCriticalFacilityCount { criticalFacilities } =
    case criticalFacilities of
        FacilitiesLost count -> count
        FacilitiesProtected count -> count
        FacilitiesUnchanged count -> count
        FacilitiesPresent count -> count
        FacilitiesRelocated count -> count


getHistoricalPlaceCount : OutputDetails -> Int
getHistoricalPlaceCount { historicalPlaces } =
    case historicalPlaces of
        HistoricalPlacesLost count -> count
        HistoricalPlacesProtected count -> count
        HistoricalPlacesUnchanged count -> count
        HistoricalPlacesPresent count -> count
        HistoricalPlacesRelocated count -> count


getMonetaryValue : MonetaryResult -> MonetaryValue
getMonetaryValue result =
    case result of
        ValueLoss value -> 
            if value > 0 then value * -1 else value

        ValueProtected value -> 
            value

        ValueTransferred value ->
            value

        ValueUnchanged -> 
            0.0

        ValueNoLongerPresent -> 
            0.0


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