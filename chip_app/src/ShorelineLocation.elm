module ShorelineLocation exposing (..)

import List.Zipper as Zipper exposing (..)
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import RemoteData as Remote exposing (RemoteData(..))
import ChipApi.Object
import Graphqelm.OptionalArgument exposing (..)
import ChipApi.Query as Query
import ChipApi.Scalar as Scalar
import Types exposing (GqlData, GqlList)
import Json.Encode as E


-- TYPES


type alias ShorelineExtent =
    { id : Scalar.Id
    , name : String
    , minX : Float
    , minY : Float
    , maxX : Float
    , maxY : Float
    }


type alias ShorelineExtents = Maybe (Zipper ShorelineExtent)


type alias Extent =
    { minX : Float
    , minY : Float
    , maxX : Float
    , maxY : Float
    }


type alias BaselineInfo =
    { id : Scalar.Id
    , name : String
    , imagePath : Maybe String
    , lengthMiles : Scalar.Decimal
    , impervPercent : Scalar.Decimal
    , criticalFacilitiesCount : Int
    , coastalStructuresCount : Int
    , workingHarbor : Bool
    , publicBuildingsCount : Int
    , saltMarshAcres : Scalar.Decimal
    , eelgrassAcres : Scalar.Decimal
    , coastalDuneAcres : Scalar.Decimal
    , rareSpeciesAcres : Scalar.Decimal
    , publicBeachCount : Int
    , recreationOpenSpaceAcres : Scalar.Decimal
    , townWaysToWater : Int
    , nationalSeashore : Bool
    , totalAssessedValue : Scalar.Decimal
    }


-- TRANSFORM


shorelineExtentToExtent : ShorelineExtent -> Extent
shorelineExtentToExtent { minX, minY, maxX, maxY } =
    Extent minX minY maxX maxY


encodeShorelineExtent : ShorelineExtent -> E.Value
encodeShorelineExtent location =
    let
        extent =
            [ location.minX, location.minY, location.maxX, location.maxY ]
                |> List.map E.float
    in
        E.object
            [ ( "name", E.string location.name )
            , ( "extent", E.list extent )
            ]


extentToString : Extent -> String
extentToString extent =
    [ extent.minX, extent.minY, extent.maxX, extent.maxY ]
        |> List.map toString
        |> String.join ","