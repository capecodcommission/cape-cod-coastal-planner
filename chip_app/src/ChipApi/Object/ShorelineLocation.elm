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


{-| The total acreage of coastal dunes in the area
-}
coastalDuneAcres : Field ChipApi.Scalar.Decimal ChipApi.Object.ShorelineLocation
coastalDuneAcres =
    Object.fieldDecoder "coastalDuneAcres" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map ChipApi.Scalar.Decimal)


{-| The number of coastal structures in the area
-}
coastalStructuresCount : Field Int ChipApi.Object.ShorelineLocation
coastalStructuresCount =
    Object.fieldDecoder "coastalStructuresCount" [] Decode.int


{-| The number of critical facilities in the area
-}
criticalFacilitiesCount : Field Int ChipApi.Object.ShorelineLocation
criticalFacilitiesCount =
    Object.fieldDecoder "criticalFacilitiesCount" [] Decode.int


{-| The total acreage of eelgrass in the area
-}
eelgrassAcres : Field ChipApi.Scalar.Decimal ChipApi.Object.ShorelineLocation
eelgrassAcres =
    Object.fieldDecoder "eelgrassAcres" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map ChipApi.Scalar.Decimal)


{-| The geographic extent of the location
-}
extent : Field ChipApi.Scalar.GeographicExtent ChipApi.Object.ShorelineLocation
extent =
    Object.fieldDecoder "extent" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map ChipApi.Scalar.GeographicExtent)


{-| The ID of the shoreline location
-}
id : Field ChipApi.Scalar.Id ChipApi.Object.ShorelineLocation
id =
    Object.fieldDecoder "id" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map ChipApi.Scalar.Id)


{-| The server path to an image of the shoreline location
-}
imagePath : Field (Maybe String) ChipApi.Object.ShorelineLocation
imagePath =
    Object.fieldDecoder "imagePath" [] (Decode.string |> Decode.nullable)


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


{-| Whether or not the location is a national seashore
-}
nationalSeashore : Field Bool ChipApi.Object.ShorelineLocation
nationalSeashore =
    Object.fieldDecoder "nationalSeashore" [] Decode.bool


{-| The number of public beaches in the area
-}
publicBeachCount : Field Int ChipApi.Object.ShorelineLocation
publicBeachCount =
    Object.fieldDecoder "publicBeachCount" [] Decode.int


{-| The number of public buildings in the area
-}
publicBuildingsCount : Field Int ChipApi.Object.ShorelineLocation
publicBuildingsCount =
    Object.fieldDecoder "publicBuildingsCount" [] Decode.int


{-| The total acreage of rare species habitat in the area
-}
rareSpeciesAcres : Field ChipApi.Scalar.Decimal ChipApi.Object.ShorelineLocation
rareSpeciesAcres =
    Object.fieldDecoder "rareSpeciesAcres" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map ChipApi.Scalar.Decimal)


{-| The total acreage of recreational open space in the area
-}
recreationOpenSpaceAcres : Field ChipApi.Scalar.Decimal ChipApi.Object.ShorelineLocation
recreationOpenSpaceAcres =
    Object.fieldDecoder "recreationOpenSpaceAcres" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map ChipApi.Scalar.Decimal)


{-| The total acreage of salt marsh in the area
-}
saltMarshAcres : Field ChipApi.Scalar.Decimal ChipApi.Object.ShorelineLocation
saltMarshAcres =
    Object.fieldDecoder "saltMarshAcres" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map ChipApi.Scalar.Decimal)


{-| The total assessed value of property in the area
-}
totalAssessedValue : Field ChipApi.Scalar.Decimal ChipApi.Object.ShorelineLocation
totalAssessedValue =
    Object.fieldDecoder "totalAssessedValue" [] (Decode.oneOf [ Decode.string, Decode.float |> Decode.map toString, Decode.int |> Decode.map toString, Decode.bool |> Decode.map toString ] |> Decode.map ChipApi.Scalar.Decimal)


{-| The number of town ways to water in the area
-}
townWaysToWater : Field Int ChipApi.Object.ShorelineLocation
townWaysToWater =
    Object.fieldDecoder "townWaysToWater" [] Decode.int


{-| Whether or not the location has a working harbor
-}
workingHarbor : Field Bool ChipApi.Object.ShorelineLocation
workingHarbor =
    Object.fieldDecoder "workingHarbor" [] Decode.bool
