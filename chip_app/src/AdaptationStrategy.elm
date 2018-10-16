module AdaptationStrategy exposing (..)

import Dict exposing (Dict)
import List.Zipper as Zipper exposing (..)
import ZipperHelpers as ZipHelp
import Maybe.Extra as MEx
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (..)
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
import Types exposing (GqlData, GqlList, getId, dictFromGqlList, unwrapGqlList, mapGqlError)


--
-- STRATEGIES BY HAZARD
--


type alias StrategiesByHazard = 
    Dict HazardId (List StrategyId)

--
-- COASTAL HAZARDS
--


type alias HazardId = 
    String


type alias CoastalHazard =
    { id : Scalar.Id
    , name : String
    , description : Maybe String
    }


type alias CoastalHazards = 
    Dict String CoastalHazard


type alias CoastalHazardZipper = 
    Zipper HazardId


hazardsToZipper : GqlData CoastalHazards -> Maybe CoastalHazardZipper
hazardsToZipper data =
    data
        |> Remote.toMaybe
        |> Maybe.map ZipHelp.fromDictKeys
        |> Maybe.withDefault Nothing


hazardsFromResponse : (GqlList CoastalHazard) -> CoastalHazards
hazardsFromResponse =
    dictFromGqlList (\c -> ( getId c.id, c ))


transformHazardsResponse : (GqlData (GqlList CoastalHazard)) -> GqlData CoastalHazards
transformHazardsResponse response =
    response
        |> Remote.mapBoth
            hazardsFromResponse
            (mapGqlError hazardsFromResponse)


--
-- ADAPTATION STRATEGIES
--


type alias StrategyId = 
    String


type alias Strategy =
    { id : Scalar.Id
    , name : String
    , details : GqlData (Maybe StrategyDetails)
    }


type alias Strategies = 
    Dict StrategyId Strategy


type alias StrategyZipper = 
    Zipper StrategyId


strategiesToZipper : GqlData Strategies -> Maybe StrategyZipper
strategiesToZipper data =
    data
        |> Remote.toMaybe
        |> Maybe.map ZipHelp.fromDictKeys
        |> Maybe.withDefault Nothing


strategiesFromResponse : (GqlList ActiveStrategy) -> Strategies
strategiesFromResponse =
    dictFromGqlList ( newStrategy >> (\c -> ( getId c.id, c )) )


transformStrategiesResponse : (GqlData (GqlList ActiveStrategy)) -> GqlData Strategies
transformStrategiesResponse response =
    response
        |> Remote.mapBoth
            strategiesFromResponse
            (mapGqlError strategiesFromResponse)


strategyHasCategory : Category -> Strategy -> Bool
strategyHasCategory category { details } =
    details
        |> Remote.toMaybe
        |> MEx.join
        |> Maybe.map (strategyDetailsHasCategory category)
        |> Maybe.withDefault False


--
-- STRATEGY DETAILS, ETC.
--


type alias StrategyDetails =
    { description : Maybe String
    , currentlyPermittable : Maybe String
    , imagePath : Maybe String
    , categories : List CategoryId
    , hazards : List CoastalHazard
    , scales : List ImpactScale
    , placements : List Placement
    , benefits : List Benefit
    , advantages : List Advantage
    , disadvantages : List Disadvantage
    }


strategyDetailsHasCategory : Category -> StrategyDetails -> Bool
strategyDetailsHasCategory category { categories } =
    categoryIdsHasCategory category categories


type alias CategoryId =
    Scalar.Id


type alias Category =
    { id : CategoryId
    , name : String
    , description : Maybe String
    , imagePathActive : Maybe String
    , imagePathInactive : Maybe String
    }


type alias Categories =
    Dict String Category
                

categoriesFromResponse : (GqlList Category) -> Categories
categoriesFromResponse =
    dictFromGqlList (\c -> ( getId c.id, c ))


transformCategoriesResponse : (GqlData (GqlList Category)) -> GqlData Categories
transformCategoriesResponse response =
    response
        |> Remote.mapBoth
            categoriesFromResponse
            (mapGqlError categoriesFromResponse)


categoryIdsHasCategory : Category -> List CategoryId -> Bool
categoryIdsHasCategory category ids =
    ids |> List.member category.id


categoryIdsToCategories : Categories -> List CategoryId -> List Category
categoryIdsToCategories categories ids =
    ids
        |> List.map (categoryIdToCategory categories)
        |> MEx.values
            
        
categoryIdToCategory : Categories -> CategoryId -> Maybe Category
categoryIdToCategory categories (Scalar.Id id) =
    Dict.get id categories


type alias ImpactScale =
    { name : String
    , impact : Int
    , description : Maybe String
    }


type alias Placement = 
    { name : String }


type alias Benefit = 
    { name : String }


--
-- STRATEGY BENEFITS
--


type alias Benefits =
    List Benefit


benefitsFromResponse : (GqlList Benefit) -> Benefits
benefitsFromResponse =
    unwrapGqlList


transformBenefitsResponse : (GqlData (GqlList Benefit)) -> GqlData Benefits
transformBenefitsResponse response =
    response
        |> Remote.mapBoth
            unwrapGqlList
            (mapGqlError unwrapGqlList)


type alias Advantage = 
    { name : String }


type alias Disadvantage = 
    { name : String }


-- CREATE


newStrategy : { a | id : Scalar.Id, name : String } -> Strategy
newStrategy { id, name } = 
    { id = id
    , name = name
    , details = NotAsked
    }


-- ACCESS


getStrategyHtmlId : StrategyId -> String
getStrategyHtmlId id =
    "strategy-" ++ id


getSelectedStrategyHtmlId : StrategyZipper -> String
getSelectedStrategyHtmlId strategies =
    strategies
        |> Zipper.current
        |> getStrategyHtmlId


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



queryAdaptationStrategies : Maybe Scalar.Id -> SelectionSet (GqlList ActiveStrategy) RootQuery
queryAdaptationStrategies hazardId =
    let
        strategyFilter =
            Present 
                { isActive = Present True
                , hazardId = 
                    hazardId 
                        |> Maybe.map Present 
                        |> Maybe.withDefault Absent
                , name = Absent 
                }
                
    in
    Query.selection GqlList
        |> with 
            (Query.adaptationStrategies
                (\optionals -> { optionals | filter = strategyFilter }) 
                selectActiveAdaptationStrategies
            )


selectActiveAdaptationStrategies : SelectionSet ActiveStrategy ChipApi.Object.AdaptationStrategy
selectActiveAdaptationStrategies =
    AS.selection ActiveStrategy
        |> with AS.id
        |> with AS.name
        

-- GRAPHQL - QUERY ADAPTATION STRATEGY + DETAILS BY ID


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
        |> with (AS.categories selectCategoryId)
        |> with (AS.hazards selectCoastalHazard)
        |> with (AS.scales selectImpactScale)
        |> with (AS.placements selectPlacement)
        |> with (AS.benefits selectBenefit)
        |> with (AS.advantages selectAdvantage)
        |> with (AS.disadvantages selectDisadvantage)


selectCategoryId : SelectionSet CategoryId ChipApi.Object.AdaptationCategory
selectCategoryId =
    fieldSelection AC.id


selectCategory : SelectionSet Category ChipApi.Object.AdaptationCategory
selectCategory =
    AC.selection Category
        |> with AC.id
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


-- GRAPHQL - QUERY STRATEGY IDS BY HAZARD


selectCoastalHazardStrategies : SelectionSet (List Scalar.Id) ChipApi.Object.CoastalHazard
selectCoastalHazardStrategies =
    fieldSelection <| 
        CH.strategies selectStrategyId


selectStrategyId : SelectionSet Scalar.Id ChipApi.Object.AdaptationStrategy
selectStrategyId =
    fieldSelection AS.id


queryStrategyIdsByHazard : Scalar.Id -> SelectionSet (Maybe (List Scalar.Id)) RootQuery
queryStrategyIdsByHazard hazardId =
    Query.selection identity
        |> with (Query.coastalHazard { id = hazardId } selectCoastalHazardStrategies)