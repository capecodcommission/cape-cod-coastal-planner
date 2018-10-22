module AdaptationStrategy exposing (..)

import Dict exposing (Dict)
import List.Zipper as Zipper exposing (..)
import Set exposing (Set)
import ZipperHelpers as ZipHelp
import Maybe.Extra as MEx
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (..)
import Graphqelm.Field as Field
import RemoteData as Remote exposing (RemoteData(..))
import ChipApi.Object
import ChipApi.Object.AdaptationStrategy as AS
import ChipApi.Object.AdaptationCategory as AC
import ChipApi.Object.CoastalHazard as CH
import ChipApi.Object.ImpactScale as IS
import ChipApi.Object.AdaptationBenefit as AB
import ChipApi.Object.AdaptationAdvantages as AA
import ChipApi.Object.AdaptationDisadvantages as AD
import Graphqelm.OptionalArgument exposing (..)
import ChipApi.Query as Query
import ChipApi.Scalar as Scalar
import Types 
    exposing 
        ( GqlData
        , GqlList
        , ZoneOfImpact
        , getId
        , dictFromGqlList
        , unwrapGqlList
        , mapGqlError
        )


--
-- ADAPTATION INFO
--

type alias AdaptationInfo =
    { benefits : Benefits
    , categories : Categories
    , hazards : Maybe CoastalHazardZipper
    , strategies : Strategies
    }


--
-- COASTAL HAZARDS
--


type alias CoastalHazard =
    { id : Scalar.Id
    , name : String
    , description : Maybe String
    , strategies : Maybe StrategyIdZipper
    }


type alias CoastalHazardZipper = 
    Zipper CoastalHazard


hazardsFromList : List CoastalHazard -> Maybe CoastalHazardZipper
hazardsFromList list =
    Zipper.fromList list


currentHazardFromInfo : GqlData AdaptationInfo -> Maybe CoastalHazard
currentHazardFromInfo data =
    data
        |> Remote.toMaybe
        |> Maybe.andThen .hazards
        |> Maybe.map Zipper.current
        

updateHazardStrategies : 
    (Maybe StrategyIdZipper -> Maybe StrategyIdZipper) 
    -> Maybe CoastalHazardZipper
    -> Maybe CoastalHazardZipper
updateHazardStrategies updateFn hazards =
    hazards
        |> ZipHelp.tryMapCurrent
            (\hazard ->
                { hazard | strategies = updateFn hazard.strategies }
            )

--
-- ADAPTATION STRATEGIES
--


type alias Strategy =
    { id : Scalar.Id
    , name : String
    , placement : Maybe Placement
    , details : GqlData (Maybe StrategyDetails)
    }


type alias Strategies = 
    Dict String Strategy


type alias StrategyIdZipper = 
    Zipper Scalar.Id


strategiesFromList : List Strategy -> Strategies
strategiesFromList list =
    list
        |> List.map (\s -> ( getId s.id, s ))
        |> Dict.fromList


currentStrategy : AdaptationInfo -> Maybe Strategy
currentStrategy info =
    info.hazards
        |> Maybe.map Zipper.current
        |> Maybe.andThen .strategies
        |> Maybe.map Zipper.current
        |> Maybe.map getId
        |> Maybe.andThen
            (\id -> Dict.get id info.strategies)



updateStrategyDetails : Scalar.Id -> (GqlData (Maybe StrategyDetails)) -> Strategies -> Strategies
updateStrategyDetails (Scalar.Id id) response strategies =
    strategies
        |> Dict.get id
        |> Maybe.map (\s -> { s | details = response })
        |> Maybe.map (\s -> Dict.insert id s strategies)
        |> Maybe.withDefault strategies


getSelectedStrategyHtmlId : Maybe CoastalHazardZipper -> Maybe String
getSelectedStrategyHtmlId hazards =
    hazards
        |> Maybe.map Zipper.current
        |> Maybe.andThen .strategies
        |> Maybe.map Zipper.current
        |> Maybe.map getStrategyHtmlId


getStrategyHtmlId : Scalar.Id -> String
getStrategyHtmlId (Scalar.Id id) =
    "strategy-" ++ id


canStrategyBePlacedInZoneOfImpact : ZoneOfImpact -> Strategy -> Bool
canStrategyBePlacedInZoneOfImpact { placementMajorities } { placement } =
    case placement of
        Just "anywhere" ->
            True

        Just "undeveloped_only" ->
            placementMajorities.majorityUndeveloped

        Just "coastal_bank_only" ->
            placementMajorities.majorityCoastalBank

        Just "anywhere_but_salt_marsh" ->
            not placementMajorities.majoritySaltMarsh

        Just _ ->
            False

        Nothing ->
            True


canStrategyFromInfoBePlacedInZoneOfImpact : Maybe ZoneOfImpact -> GqlData AdaptationInfo -> Scalar.Id -> Bool
canStrategyFromInfoBePlacedInZoneOfImpact zoneOfImpact info (Scalar.Id id) =
    info
        |> Remote.toMaybe
        |> Maybe.andThen (\info -> info.strategies |> Dict.get id)
        |> Maybe.map2 canStrategyBePlacedInZoneOfImpact zoneOfImpact
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
    , benefits : Set Benefit
    , advantages : Set Advantage
    , disadvantages : Set Disadvantage
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
                

categoriesFromList : List Category -> Categories
categoriesFromList list =
    list 
        |> List.map (\c -> ( getId c.id, c ))
        |> Dict.fromList


categoryAppliesToStrategy : Maybe Strategy -> Category -> (Category, Bool)
categoryAppliesToStrategy maybeStrategy category =
    maybeStrategy
        |> Maybe.map .details
        |> Maybe.andThen Remote.toMaybe
        |> MEx.join
        |> Maybe.map .categories
        |> Maybe.map (categoryIdsHasCategory category)
        |> Maybe.map (\b -> (category, b))
        |> Maybe.withDefault (category, False)


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


type alias Placement = String


type alias Benefit = String
    

type alias Benefits =
    Set Benefit


type alias Advantage = 
    String


type alias Disadvantage = 
    String



--
-- GRAPHQL QUERIES
--

queryAdaptationInfo : SelectionSet AdaptationInfo RootQuery
queryAdaptationInfo =
    Query.selection AdaptationInfo
        |> with
            (Query.adaptationBenefits identity selectBenefit
                |> Field.map Set.fromList
            )
        |> with 
            (Query.adaptationCategories identity selectCategory
                |> Field.map categoriesFromList
            )
        |> with 
            (Query.coastalHazards identity selectCoastalHazardWithStrategyIds
                |> Field.map hazardsFromList
            )
        |> with 
            (Query.adaptationStrategies
                (\optionals -> 
                    let
                        strategyFilter =
                            Present
                                { isActive = Present True
                                , hazardId = Absent
                                , name = Absent
                                }
                    in
                    { optionals | filter = strategyFilter }
                )
                selectActiveAdaptationStrategies
                    |> Field.map strategiesFromList
            )


queryAdaptationStrategyDetailsById : Scalar.Id -> SelectionSet (Maybe StrategyDetails) RootQuery
queryAdaptationStrategyDetailsById id =
    Query.selection identity
        |> with (Query.adaptationStrategy { id = id } selectStrategyDetails)


--
-- GRAPHQL SELECTORS
--


selectActiveAdaptationStrategies : SelectionSet Strategy ChipApi.Object.AdaptationStrategy
selectActiveAdaptationStrategies =
    AS.selection Strategy
        |> with AS.id
        |> with AS.name
        |> with AS.strategyPlacement
        |> hardcoded NotAsked


selectStrategyDetails : SelectionSet StrategyDetails ChipApi.Object.AdaptationStrategy
selectStrategyDetails =
    AS.selection StrategyDetails
        |> with AS.description
        |> with AS.currentlyPermittable
        |> with AS.imagePath
        |> with (AS.categories selectCategoryId)
        |> with (AS.hazards selectCoastalHazard)
        |> with (AS.scales selectImpactScale)
        |> with (AS.benefits selectBenefit |> Field.map Set.fromList)
        |> with (AS.advantages selectAdvantage |> Field.map Set.fromList)
        |> with (AS.disadvantages selectDisadvantage |> Field.map Set.fromList)


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
        |> hardcoded Nothing


selectCoastalHazardWithStrategyIds : SelectionSet CoastalHazard ChipApi.Object.CoastalHazard
selectCoastalHazardWithStrategyIds =
    CH.selection CoastalHazard
        |> with CH.id
        |> with CH.name
        |> with CH.description
        |> with 
            ( fieldSelection AS.id
                |> CH.strategies (\optionals -> { optionals | isActive = Present True })
                |> Field.map Zipper.fromList
            )


selectImpactScale : SelectionSet ImpactScale ChipApi.Object.ImpactScale
selectImpactScale =
    IS.selection ImpactScale
        |> with IS.name
        |> with IS.impact
        |> with IS.description
       

selectBenefit : SelectionSet Benefit ChipApi.Object.AdaptationBenefit
selectBenefit =
    AB.selection identity
        |> with AB.name


selectAdvantage : SelectionSet Advantage ChipApi.Object.AdaptationAdvantages
selectAdvantage =
    AA.selection identity
        |> with AA.name


selectDisadvantage : SelectionSet Disadvantage ChipApi.Object.AdaptationDisadvantages
selectDisadvantage =
    AD.selection identity
        |> with AD.name


selectStrategyId : SelectionSet Scalar.Id ChipApi.Object.AdaptationStrategy
selectStrategyId =
    fieldSelection AS.id