-- Do not manually edit this file, it was auto-generated by Graphqelm
-- https://github.com/dillonkearns/graphqelm


module ChipApi.Object.ShorelineLocation exposing (..)

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
selection : (a -> constructor) -> SelectionSet (a -> constructor) ChipApi.Object.ShorelineLocation
selection constructor =
    Object.selection constructor


{-| The geographic extent of the location
-}
extent : Field ChipApi.Scalar.GeographicExtent ChipApi.Object.ShorelineLocation
extent =
    Object.fieldDecoder "extent" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map ChipApi.Scalar.GeographicExtent)


{-| The percentage of impervious surface area
-}
impervPercent : Field ChipApi.Scalar.Decimal ChipApi.Object.ShorelineLocation
impervPercent =
    Object.fieldDecoder "impervPercent" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map ChipApi.Scalar.Decimal)


{-| The length in miles of the shoreline
-}
lengthMiles : Field ChipApi.Scalar.Decimal ChipApi.Object.ShorelineLocation
lengthMiles =
    Object.fieldDecoder "lengthMiles" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map ChipApi.Scalar.Decimal)


{-| The easternmost longitude of the location's extent
-}
maxX : Field Float ChipApi.Object.ShorelineLocation
maxX =
    Object.fieldDecoder "maxX" [] Decode.float


{-| The northernmost latitude of the location's extent
-}
maxY : Field Float ChipApi.Object.ShorelineLocation
maxY =
    Object.fieldDecoder "maxY" [] Decode.float


{-| The westernmost longitude of the location's extent
-}
minX : Field Float ChipApi.Object.ShorelineLocation
minX =
    Object.fieldDecoder "minX" [] Decode.float


{-| The southernmost latitude of the location's extent
-}
minY : Field Float ChipApi.Object.ShorelineLocation
minY =
    Object.fieldDecoder "minY" [] Decode.float


{-| The name of the shoreline location
-}
name : Field String ChipApi.Object.ShorelineLocation
name =
    Object.fieldDecoder "name" [] Decode.string
