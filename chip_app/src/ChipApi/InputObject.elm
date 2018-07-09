-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module ChipApi.InputObject exposing (..)

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


buildStrategyFilter : (StrategyFilterOptionalFields -> StrategyFilterOptionalFields) -> StrategyFilter
buildStrategyFilter fillOptionals =
    let
        optionals =
            fillOptionals
                { isActive = Absent, name = Absent }
    in
    { isActive = optionals.isActive, name = optionals.name }


type alias StrategyFilterOptionalFields =
    { isActive : OptionalArgument Bool, name : OptionalArgument String }


{-| Type for the StrategyFilter input object.
-}
type alias StrategyFilter =
    { isActive : OptionalArgument Bool, name : OptionalArgument String }


{-| Encode a StrategyFilter into a value that can be used as an argument.
-}
encodeStrategyFilter : StrategyFilter -> Value
encodeStrategyFilter input =
    Encode.maybeObject
        [ ( "isActive", Encode.bool |> Encode.optional input.isActive ), ( "name", Encode.string |> Encode.optional input.name ) ]