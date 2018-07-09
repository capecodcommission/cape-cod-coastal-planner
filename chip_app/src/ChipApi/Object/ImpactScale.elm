-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module ChipApi.Object.ImpactScale exposing (..)

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
selection : (a -> constructor) -> SelectionSet (a -> constructor) ChipApi.Object.ImpactScale
selection constructor =
    Object.selection constructor


{-| The description of the scale of impact
-}
description : Field (Maybe String) ChipApi.Object.ImpactScale
description =
    Object.fieldDecoder "description" [] (Decode.string |> Decode.nullable)


{-| The impact is an integer representing the relative scale of impact. A larger number means a larger scale.
-}
impact : Field (Maybe Int) ChipApi.Object.ImpactScale
impact =
    Object.fieldDecoder "impact" [] (Decode.int |> Decode.nullable)


{-| The name of the scale of impact
-}
name : Field (Maybe String) ChipApi.Object.ImpactScale
name =
    Object.fieldDecoder "name" [] (Decode.string |> Decode.nullable)


{-| The adaptation strategies that are associated with the scale of impact.
-}
strategies : SelectionSet decodesTo ChipApi.Object.AdaptationStrategy -> Field (Maybe (List (Maybe decodesTo))) ChipApi.Object.ImpactScale
strategies object =
    Object.selectionField "strategies" [] object (identity >> Decode.nullable >> Decode.list >> Decode.nullable)
