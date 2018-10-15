module AdaptationStrategy exposing (..)

import List.Zipper as Zipper exposing (..)
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import RemoteData as Remote exposing (RemoteData(..))
import ChipApi.Object
import ChipApi.Object.AdaptationStrategy as AS
import ChipApi.Object.AdaptationCategory as AC
import ChipApi.Object.CoastalHazard as CH
import ChipApi.Object.ImpactScale as IS
import ChipApi.Object.StrategyPlacement as SP
import ChipApi.Object.AdaptationBenefit as AB
import ChipApi.Object.AdaptationAdvantages as AA
import ChipApi.Object.AdaptationDisadvantages as AD
import Graphqelm.OptionalArgument exposing (..)
import ChipApi.Query as Query
import ChipApi.Scalar as Scalar
import Types exposing (GqlData, GqlList)


-- TYPES


type alias Strategy =
    { id : Scalar.Id
    , name : String
    , details : GqlData (Maybe StrategyDetails)
    }


type alias Strategies = Maybe (Zipper Strategy)


type alias Category =
    { name : String
    , description : Maybe String
    , imagePathActive : Maybe String
    , imagePathInactive : Maybe String
    }


type alias Categories =
    List Category


type alias CoastalHazard =
    { id : Scalar.Id
    , name : String
    , description : Maybe String
    }


type alias CoastalHazards = Maybe (Zipper CoastalHazard)


type alias ImpactScale =
    { name : String
    , impact : Int
    , description : Maybe String
    }


type alias Placement = { name : String }


type alias Benefit = { name : String }


type alias Benefits =
    List Benefit


type alias Advantage = { name : String }


type alias Disadvantage = { name : String }


-- CREATE


newStrategy : { a | id : Scalar.Id, name : String } -> Strategy
newStrategy { id, name } = 
    { id = id
    , name = name
    , details = NotAsked
    }


-- ACCESS


getStrategyHtmlId : Strategy -> String
getStrategyHtmlId { id } =
    case id of
        Scalar.Id theId ->
            "strategy-" ++ theId


getSelectedStrategyHtmlId : Strategies -> Maybe String
getSelectedStrategyHtmlId strategies =
    strategies
        |> Maybe.map Zipper.current
        |> Maybe.map getStrategyHtmlId


loadDetailsFor : Strategy -> Maybe ( Maybe Scalar.Id, GqlData (Maybe StrategyDetails) )
loadDetailsFor s =
    if Remote.isSuccess s.details == True then
        Just ( Nothing, s.details )
    else
        Just ( Just s.id, Loading )


-- UPDATE


updateStrategyDetails : (GqlData (Maybe StrategyDetails)) -> Strategy -> Strategy
updateStrategyDetails newDetails ({ details } as strategy) =
    { strategy | details = newDetails }


-- GRAPHQL - QUERY ACTIVE ADAPTATION STRATEGIES


type alias ActiveStrategy = 
    { id : Scalar.Id
    , name : String
    }


-- type alias ActiveStrategies =
--     { items : List ActiveStrategy }


queryAdaptationStrategies : SelectionSet (GqlList ActiveStrategy) RootQuery
queryAdaptationStrategies =
    Query.selection GqlList
        |> with 
            (Query.adaptationStrategies 
                (\optionals -> 
                    { optionals 
                        | filter = Present { isActive = Present True, name = Absent }
                    } 
                ) selectActiveAdaptationStrategies
            )


selectActiveAdaptationStrategies : SelectionSet ActiveStrategy ChipApi.Object.AdaptationStrategy
selectActiveAdaptationStrategies =
    AS.selection ActiveStrategy
        |> with AS.id
        |> with AS.name
        

-- GRAPHQL - QUERY ADAPTATION STRATEGY + DETAILS BY ID

type alias StrategyDetails =
    { description : Maybe String
    , currentlyPermittable : Maybe String
    , imagePath : Maybe String
    , categories : List Category
    , hazards : List CoastalHazard
    , scales : List ImpactScale
    , placements : List Placement
    , benefits : List Benefit
    , advantages : List Advantage
    , disadvantages : List Disadvantage
    }


queryAdaptationStrategyById : Scalar.Id -> SelectionSet (Maybe StrategyDetails) RootQuery
queryAdaptationStrategyById id =
    Query.selection identity
        |> with (Query.adaptationStrategy { id = id } selectStrategyDetails)


selectStrategyDetails : SelectionSet StrategyDetails ChipApi.Object.AdaptationStrategy
selectStrategyDetails =
    AS.selection StrategyDetails
        |> with AS.description
        |> with AS.currentlyPermittable
        |> with AS.imagePath
        |> with (AS.categories selectCategory)
        |> with (AS.hazards selectCoastalHazard)
        |> with (AS.scales selectImpactScale)
        |> with (AS.placements selectPlacement)
        |> with (AS.benefits selectBenefit)
        |> with (AS.advantages selectAdvantage)
        |> with (AS.disadvantages selectDisadvantage)


selectCategory : SelectionSet Category ChipApi.Object.AdaptationCategory
selectCategory =
    AC.selection Category
        |> with AC.name
        |> with AC.description
        |> with AC.imagePathActive
        |> with AC.imagePathInactive


selectCoastalHazard : SelectionSet CoastalHazard ChipApi.Object.CoastalHazard
selectCoastalHazard =
    CH.selection CoastalHazard
        |> with CH.id
        |> with CH.name
        |> with CH.description


selectImpactScale : SelectionSet ImpactScale ChipApi.Object.ImpactScale
selectImpactScale =
    IS.selection ImpactScale
        |> with IS.name
        |> with IS.impact
        |> with IS.description


selectPlacement : SelectionSet Placement ChipApi.Object.StrategyPlacement
selectPlacement =
    SP.selection Placement
        |> with SP.name
        

selectBenefit : SelectionSet Benefit ChipApi.Object.AdaptationBenefit
selectBenefit =
    AB.selection Benefit
        |> with AB.name


selectAdvantage : SelectionSet Advantage ChipApi.Object.AdaptationAdvantages
selectAdvantage =
    AA.selection Advantage
        |> with AA.name


selectDisadvantage : SelectionSet Disadvantage ChipApi.Object.AdaptationDisadvantages
selectDisadvantage =
    AD.selection Disadvantage
        |> with AD.name



-- GRAPHQL - QUERY LIST OF ADAPTATION CATEGORIES


queryAdaptationCategories : SelectionSet (GqlList Category) RootQuery
queryAdaptationCategories =
    Query.selection GqlList
        |> with (Query.adaptationCategories identity selectCategory)


-- GRAPHQL - QUERY LIST OF ADAPTATION BENEFITS


queryAdaptationBenefits : SelectionSet (GqlList Benefit) RootQuery
queryAdaptationBenefits =
    Query.selection GqlList
        |> with (Query.adaptationBenefits identity selectBenefit)


-- GRAPHQL - QUERY COASTAL HAZARDS


queryCoastalHazards : SelectionSet (GqlList CoastalHazard) RootQuery
queryCoastalHazards =
    Query.selection GqlList
        |> with (Query.coastalHazards identity selectCoastalHazard)

