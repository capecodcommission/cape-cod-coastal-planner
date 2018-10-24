module AdapationStrategy.Query exposing (..)


import Set
import RemoteData as Remote exposing (..)
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (..)
import Graphqelm.Field as Field
import Graphqelm.OptionalArgument exposing (..)
import ChipApi.Object
import ChipApi.Object.AdaptationStrategy as AS
import ChipApi.Object.AdaptationCategory as AC
import ChipApi.Object.CoastalHazard as CH
import ChipApi.Object.ImpactScale as IS
import ChipApi.Object.AdaptationBenefit as AB
import ChipApi.Object.AdaptationAdvantages as AA
import ChipApi.Object.AdaptationDisadvantages as AD
import ChipApi.Query as Query
import ChipApi.Scalar as Scalar
import AdaptationStrategy.AdaptationInfo as Info exposing (..)
import AdaptationStrategy.Strategies as Strategies exposing (..)
import AdaptationStrategy.Categories as Categories exposing (..)
import AdaptationStrategy.CoastalHazards as Hazards exposing (..)
import AdaptationStrategy.StrategyDetails as Details exposing (..)
import AdaptationStrategy.Impacts exposing (..)


--
-- GRAPHQL ROOT QUERIES
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
                |> Field.map Categories.fromList
            )
        |> with 
            (Query.coastalHazards identity selectCoastalHazardWithStrategyIds
                |> Field.map Hazards.fromList
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
                    |> Field.map Strategies.fromList
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


selectCategoryId : SelectionSet Scalar.Id ChipApi.Object.AdaptationCategory
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
                |> Field.map Hazards.fromList
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