module AdaptationOutput exposing (..)

import Graphqelm.Http as GHttp
import AdaptationStrategy exposing (..)
import AdaptationHexes exposing (..)


type AdaptationOutput 
    = NotCalculated
    | CalculatingOutput
    | OnlyNoAction OutputDetails
    | WithStrategy OutputDetails OutputDetails
    | NetworkError (GHttp.Error AdaptationHexes)
    | CalculationError (List String) (Maybe OutputDetails)


type alias OutputDetails =
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


