module AdaptationStrategy exposing (..)

import List.Zipper as Zipper exposing (..)
import Graphqelm.Http as GHttp exposing (..)
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import Graphqelm.Http.GraphqlError exposing (PossiblyParsedData(..))
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
import Types exposing (GqlData)


-- TYPES


type alias Strategies = Maybe (Zipper Strategy)
    

type Strategy =
    Strategy
        { id : Scalar.Id
        , name : String
        , details : GqlData (Maybe StrategyDetails)
        }


type alias Category =
    { name : String
    , description : Maybe String
    }


type alias Categories =
    List Category


type alias CoastalHazard =
    { name : String
    , description : Maybe String
    }


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
    Strategy
        { id = id
        , name = name
        , details = NotAsked
        }


-- ACCESS


getStrategyHtmlId : Strategy -> String
getStrategyHtmlId (Strategy { id }) =
    case id of
        Scalar.Id theId ->
            "strategy-" ++ theId


getSelectedStrategyHtmlId : Strategies -> Maybe String
getSelectedStrategyHtmlId strategies =
    strategies
        |> Maybe.map Zipper.current
        |> Maybe.map getStrategyHtmlId


loadDetailsFor : Strategy -> Maybe Scalar.Id
loadDetailsFor (Strategy s) =
    if Remote.isSuccess s.details == True then
        Nothing
    else
        Just s.id 


currentStrategy : Strategies -> Maybe Strategy
currentStrategy strategies =
    strategies
        |> Maybe.map Zipper.current


firstStrategy : Strategies -> Strategies
firstStrategy strategies =
    strategies
        |> Maybe.map Zipper.first


findStrategy : Scalar.Id -> Strategies -> Strategies
findStrategy id strategies =
    let 
        found = strategies |> Maybe.andThen (Zipper.findFirst (matchesId id))
    in
        case found of
            Just foundStrategies -> Just foundStrategies

            Nothing -> strategies


nextStrategy : Strategies -> Strategies
nextStrategy strategies =
    let
        next = strategies |> Maybe.andThen Zipper.next
    in
        case next of
            Just nextStrategies -> Just nextStrategies

            Nothing -> strategies


previousStrategy : Strategies -> Strategies
previousStrategy strategies =
    let
        previous = strategies |> Maybe.andThen Zipper.previous
    in
        case previous of
            Just previousStrategies -> Just previousStrategies

            Nothing -> strategies


matchesId : Scalar.Id -> Strategy -> Bool
matchesId (Scalar.Id targetId) (Strategy strategy) =
    case strategy.id of
        Scalar.Id theId ->
            theId == targetId


-- UPDATE


updateStrategyDetails : (GqlData (Maybe StrategyDetails)) -> Strategy -> Strategy
updateStrategyDetails newDetails (Strategy ({ details } as strategy)) =
    Strategy <| { strategy | details = newDetails }



-- TRANSFORM


mapStrategiesFromActiveStrategies : ActiveStrategies -> Strategies
mapStrategiesFromActiveStrategies data =
    data.items
        |> List.map newStrategy
        |> Zipper.fromList


mapErrorFromActiveStrategies : GHttp.Error ActiveStrategies -> GHttp.Error Strategies
mapErrorFromActiveStrategies error =
    GHttp.mapError mapStrategiesFromActiveStrategies error


mapCategoriesFromAdaptationCategories : AdaptationCategories -> Categories
mapCategoriesFromAdaptationCategories data =
    data.items

mapErrorFromAdaptationCategories : GHttp.Error AdaptationCategories -> GHttp.Error Categories
mapErrorFromAdaptationCategories error =
    GHttp.mapError mapCategoriesFromAdaptationCategories error


mapBenefitsFromAdaptationBenefits : AdaptationBenefits -> Benefits
mapBenefitsFromAdaptationBenefits data =
    data.items


mapErrorFromAdaptationBenefits : GHttp.Error AdaptationBenefits -> GHttp.Error Benefits
mapErrorFromAdaptationBenefits error =
    GHttp.mapError mapBenefitsFromAdaptationBenefits error



-- GRAPHQL - QUERY ACTIVE ADAPTATION STRATEGIES


type alias ActiveStrategy = 
    { id : Scalar.Id
    , name : String
    }


type alias ActiveStrategies =
    { items : List ActiveStrategy }


queryAdaptationStrategies : SelectionSet ActiveStrategies RootQuery
queryAdaptationStrategies =
    Query.selection ActiveStrategies
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


selectCoastalHazard : SelectionSet CoastalHazard ChipApi.Object.CoastalHazard
selectCoastalHazard =
    CH.selection CoastalHazard
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


type alias AdaptationCategories =
    { items : Categories }


queryAdaptationCategories : SelectionSet AdaptationCategories RootQuery
queryAdaptationCategories =
    Query.selection AdaptationCategories
        |> with (Query.adaptationCategories identity selectCategory)


-- GRAPHQL - QUERY LIST OF ADAPTATION BENEFITS


type alias AdaptationBenefits =
    { items : Benefits }


queryAdaptationBenefits : SelectionSet AdaptationBenefits RootQuery
queryAdaptationBenefits =
    Query.selection AdaptationBenefits
        |> with (Query.adaptationBenefits identity selectBenefit)