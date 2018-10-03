-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module ChipApi.Object.AdaptationBenefit exposing (..)

import ChipApi.InputObject
import ChipApi.Interface
import ChipApi.Object
import ChipApi.Scalar
import ChipApi.Union
import Graphqelm.Field as Field exposing (Field)
import Graphqelm.Internal.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Internal.Builder.Object as Object
import Graphqelm.Internal.Encode as Encode exposing (Value)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


{-| Select fields to build up a SelectionSet for this object.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) ChipApi.Object.AdaptationBenefit
selection constructor =
    Object.selection constructor


{-| The name of the benefit
-}
name : Field String ChipApi.Object.AdaptationBenefit
name =
    Object.fieldDecoder "name" [] Decode.string


{-| The adaptation strategies that are associated with the benefit
-}
strategies : SelectionSet decodesTo ChipApi.Object.AdaptationStrategy -> Field (Maybe (List (Maybe decodesTo))) ChipApi.Object.AdaptationBenefit
strategies object =
    Object.selectionField "strategies" [] object (identity >> Decode.nullable >> Decode.list >> Decode.nullable)