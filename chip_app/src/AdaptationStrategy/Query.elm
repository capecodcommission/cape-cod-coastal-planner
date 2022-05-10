module AdaptationStrategy.Query exposing (..)


import List.Zipper as Zipper
import RemoteData as Remote exposing (..)
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (..)
import Graphql.OptionalArgument exposing (..)
import ChipApi.Object
import ChipApi.Object.AdaptationStrategy as AS
import ChipApi.Object.AdaptationCategory as AC
import ChipApi.Object.CoastalHazard as CH
import ChipApi.Object.ImpactScale as IS
import ChipApi.Object.ImpactCost as IC
import ChipApi.Object.ImpactLifeSpan as ILS
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
import AdaptationStrategy.Impacts as Impacts exposing (..)


--
-- GRAPHQL ROOT QUERIES
--


queryAdaptationInfo : SelectionSet AdaptationInfo RootQuery
queryAdaptationInfo =
    SelectionSet.succeed AdaptationInfo
        |> with
            (Query.adaptationBenefits identity selectBenefit)
        |> with 
            (Query.adaptationCategories identity selectCategory
                |> SelectionSet.map Categories.fromList
            )
        |> with 
            (Query.coastalHazards identity selectCoastalHazardWithStrategyIds
                |> SelectionSet.map Hazards.fromList
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
                    |> SelectionSet.map Strategies.fromList
            )


queryAdaptationStrategyDetailsById : Scalar.Id -> SelectionSet (Maybe StrategyDetails) RootQuery
queryAdaptationStrategyDetailsById id =
    SelectionSet.succeed identity
        |> with (Query.adaptationStrategy { id = id } selectStrategyDetails)


--
-- GRAPHQL SELECTORS
--


selectActiveAdaptationStrategies : SelectionSet Strategy ChipApi.Object.AdaptationStrategy
selectActiveAdaptationStrategies =
    SelectionSet.succeed Strategy
        |> with AS.id
        |> with AS.name
        |> with AS.strategyPlacement
        |> hardcoded NotAsked


selectStrategyDetails : SelectionSet StrategyDetails ChipApi.Object.AdaptationStrategy
selectStrategyDetails =
    SelectionSet.succeed StrategyDetails
        |> with AS.description
        |> with AS.currentlyPermittable
        |> with AS.beachWidthImpactM
        |> with AS.imagePath
        |> with (AS.categories AC.id)
        |> with (AS.hazards CH.id)
        |> with (AS.scales selectImpactScale)
        |> with (AS.lifeSpans selectImpactLifeSpans)
        |> with (AS.costs selectImpactCosts)
        |> with (AS.benefits selectBenefit)
        |> with (AS.advantages selectAdvantage)
        |> with (AS.disadvantages selectDisadvantage)
        |> with AS.applicability


selectCategoryId : SelectionSet Scalar.Id ChipApi.Object.AdaptationCategory
selectCategoryId =
    AC.id


selectCategory : SelectionSet Category ChipApi.Object.AdaptationCategory
selectCategory =
    SelectionSet.succeed Category
        |> with AC.id
        |> with AC.name
        |> with AC.description
        |> with AC.imagePathActive
        |> with AC.imagePathInactive


selectCoastalHazard : SelectionSet Scalar.Id ChipApi.Object.CoastalHazard
selectCoastalHazard =
    CH.id

selectCoastalHazardWithStrategyIds : SelectionSet CoastalHazard ChipApi.Object.CoastalHazard
selectCoastalHazardWithStrategyIds =
    SelectionSet.succeed CoastalHazard
        |> with CH.id
        |> with CH.name
        |> with CH.description
        |> with CH.duration
        |> with 
            ( AS.id
                |> CH.strategies (\optionals -> { optionals | isActive = Present True })
                |> SelectionSet.map Zipper.fromList
            )


selectImpactScale : SelectionSet ImpactScale ChipApi.Object.ImpactScale
selectImpactScale =
    SelectionSet.succeed ImpactScale
        |> with IS.name
        |> with IS.impact
        |> with IS.description


selectImpactCosts : SelectionSet ImpactCost ChipApi.Object.ImpactCost
selectImpactCosts =
    SelectionSet.succeed ImpactCost
        |> with IC.name
        |> with IC.cost
        |> with IC.description


selectImpactLifeSpans : SelectionSet ImpactLifeSpan ChipApi.Object.ImpactLifeSpan
selectImpactLifeSpans =
    SelectionSet.succeed ImpactLifeSpan
        |> with ILS.name
        |> with ILS.lifeSpan
        |> with ILS.description
       

selectBenefit : SelectionSet Benefit ChipApi.Object.AdaptationBenefit
selectBenefit =
    SelectionSet.succeed identity
        |> with AB.name


selectAdvantage : SelectionSet Advantage ChipApi.Object.AdaptationAdvantages
selectAdvantage =
    SelectionSet.succeed identity
        |> with AA.name


selectDisadvantage : SelectionSet Disadvantage ChipApi.Object.AdaptationDisadvantages
selectDisadvantage =
    SelectionSet.succeed identity
        |> with AD.name


selectStrategyId : SelectionSet Scalar.Id ChipApi.Object.AdaptationStrategy
selectStrategyId =
    AS.id