-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module ChipApi.Query exposing (..)

import ChipApi.Enum.SortOrder
import ChipApi.InputObject
import ChipApi.Interface
import ChipApi.Object
import ChipApi.Scalar
import ChipApi.Union
import Graphqelm.Field as Field exposing (Field)
import Graphqelm.Internal.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Internal.Builder.Object as Object
import Graphqelm.Internal.Encode as Encode exposing (Value)
import Graphqelm.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)


{-| Select fields to build up a top-level query. The request can be sent with
functions from `Graphqelm.Http`.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) RootQuery
selection constructor =
    Object.selection constructor


type alias AdaptationBenefitsOptionalArguments =
    { order : OptionalArgument ChipApi.Enum.SortOrder.SortOrder }


{-| The list of adaptation benefits
-}
adaptationBenefits : (AdaptationBenefitsOptionalArguments -> AdaptationBenefitsOptionalArguments) -> SelectionSet decodesTo ChipApi.Object.AdaptationBenefit -> Field (List decodesTo) RootQuery
adaptationBenefits fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { order = Absent }

        optionalArgs =
            [ Argument.optional "order" filledInOptionals.order (Encode.enum ChipApi.Enum.SortOrder.toString) ]
                |> List.filterMap identity
    in
    Object.selectionField "adaptationBenefits" optionalArgs object (identity >> Decode.list)


type alias AdaptationCategoriesOptionalArguments =
    { order : OptionalArgument ChipApi.Enum.SortOrder.SortOrder }


{-| The list of adaptation categories
-}
adaptationCategories : (AdaptationCategoriesOptionalArguments -> AdaptationCategoriesOptionalArguments) -> SelectionSet decodesTo ChipApi.Object.AdaptationCategory -> Field (List decodesTo) RootQuery
adaptationCategories fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { order = Absent }

        optionalArgs =
            [ Argument.optional "order" filledInOptionals.order (Encode.enum ChipApi.Enum.SortOrder.toString) ]
                |> List.filterMap identity
    in
    Object.selectionField "adaptationCategories" optionalArgs object (identity >> Decode.list)


type alias AdaptationStrategiesOptionalArguments =
    { filter : OptionalArgument ChipApi.InputObject.StrategyFilter, order : OptionalArgument ChipApi.Enum.SortOrder.SortOrder }


{-| The list of adaptation strategies
-}
adaptationStrategies : (AdaptationStrategiesOptionalArguments -> AdaptationStrategiesOptionalArguments) -> SelectionSet decodesTo ChipApi.Object.AdaptationStrategy -> Field (List decodesTo) RootQuery
adaptationStrategies fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { filter = Absent, order = Absent }

        optionalArgs =
            [ Argument.optional "filter" filledInOptionals.filter ChipApi.InputObject.encodeStrategyFilter, Argument.optional "order" filledInOptionals.order (Encode.enum ChipApi.Enum.SortOrder.toString) ]
                |> List.filterMap identity
    in
    Object.selectionField "adaptationStrategies" optionalArgs object (identity >> Decode.list)


type alias AdaptationStrategyRequiredArguments =
    { id : ChipApi.Scalar.Id }


{-| Details for an individual adaptation strategy matched on id

  - id - The ID of the adaptation strategy

-}
adaptationStrategy : AdaptationStrategyRequiredArguments -> SelectionSet decodesTo ChipApi.Object.AdaptationStrategy -> Field (Maybe decodesTo) RootQuery
adaptationStrategy requiredArgs object =
    Object.selectionField "adaptationStrategy" [ Argument.required "id" requiredArgs.id (\(ChipApi.Scalar.Id raw) -> Encode.string raw) ] object (identity >> Decode.nullable)


type alias CoastalHazardRequiredArguments =
    { id : ChipApi.Scalar.Id }


{-| A coastal hazard matched on id

  - id - The ID of the coastal hazard

-}
coastalHazard : CoastalHazardRequiredArguments -> SelectionSet decodesTo ChipApi.Object.CoastalHazard -> Field (Maybe decodesTo) RootQuery
coastalHazard requiredArgs object =
    Object.selectionField "coastalHazard" [ Argument.required "id" requiredArgs.id (\(ChipApi.Scalar.Id raw) -> Encode.string raw) ] object (identity >> Decode.nullable)


type alias CoastalHazardsOptionalArguments =
    { order : OptionalArgument ChipApi.Enum.SortOrder.SortOrder }


{-| The list of coastal hazards
-}
coastalHazards : (CoastalHazardsOptionalArguments -> CoastalHazardsOptionalArguments) -> SelectionSet decodesTo ChipApi.Object.CoastalHazard -> Field (List decodesTo) RootQuery
coastalHazards fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { order = Absent }

        optionalArgs =
            [ Argument.optional "order" filledInOptionals.order (Encode.enum ChipApi.Enum.SortOrder.toString) ]
                |> List.filterMap identity
    in
    Object.selectionField "coastalHazards" optionalArgs object (identity >> Decode.list)


type alias ImpactScalesOptionalArguments =
    { order : OptionalArgument ChipApi.Enum.SortOrder.SortOrder }


{-| The list of geographic scales of impact
-}
impactScales : (ImpactScalesOptionalArguments -> ImpactScalesOptionalArguments) -> SelectionSet decodesTo ChipApi.Object.ImpactScale -> Field (List decodesTo) RootQuery
impactScales fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { order = Absent }

        optionalArgs =
            [ Argument.optional "order" filledInOptionals.order (Encode.enum ChipApi.Enum.SortOrder.toString) ]
                |> List.filterMap identity
    in
    Object.selectionField "impactScales" optionalArgs object (identity >> Decode.list)


type alias ShorelineLocationRequiredArguments =
    { id : ChipApi.Scalar.Id }


{-| An individual shoreline location matched on id

  - id - The ID of the shoreline location

-}
shorelineLocation : ShorelineLocationRequiredArguments -> SelectionSet decodesTo ChipApi.Object.ShorelineLocation -> Field (Maybe decodesTo) RootQuery
shorelineLocation requiredArgs object =
    Object.selectionField "shorelineLocation" [ Argument.required "id" requiredArgs.id (\(ChipApi.Scalar.Id raw) -> Encode.string raw) ] object (identity >> Decode.nullable)


type alias ShorelineLocationsOptionalArguments =
    { filter : OptionalArgument ChipApi.InputObject.LocationFilter, order : OptionalArgument ChipApi.Enum.SortOrder.SortOrder }


{-| The list of shoreline locations, filterable and sortable by name
-}
shorelineLocations : (ShorelineLocationsOptionalArguments -> ShorelineLocationsOptionalArguments) -> SelectionSet decodesTo ChipApi.Object.ShorelineLocation -> Field (List decodesTo) RootQuery
shorelineLocations fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { filter = Absent, order = Absent }

        optionalArgs =
            [ Argument.optional "filter" filledInOptionals.filter ChipApi.InputObject.encodeLocationFilter, Argument.optional "order" filledInOptionals.order (Encode.enum ChipApi.Enum.SortOrder.toString) ]
                |> List.filterMap identity
    in
    Object.selectionField "shorelineLocations" optionalArgs object (identity >> Decode.list)
