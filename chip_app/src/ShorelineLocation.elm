module ShorelineLocation exposing (..)

import List.Zipper as Zipper exposing (..)
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet, with)
import RemoteData as Remote exposing (RemoteData(..))
import ChipApi.Object
import Graphql.OptionalArgument exposing (..)
import ChipApi.Query as Query
import ChipApi.Scalar as Scalar
import Types exposing (GqlData, GqlList, zipperFromGqlList, mapGqlError)
import Json.Encode as E


-- TYPES


type alias ShorelineExtent =
    { id : Scalar.Id
    , name : String
    , minX : Float
    , minY : Float
    , maxX : Float
    , maxY : Float
    , littoralCellId : Int
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
    -- , historicalPlacesCount : Int
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

locationsFromResponse : (GqlList ShorelineExtent) -> ShorelineExtents
locationsFromResponse =
    zipperFromGqlList identity


transformLocationsResponse : (GqlData (GqlList ShorelineExtent)) -> GqlData ShorelineExtents
transformLocationsResponse response =
    response
        |> Remote.mapBoth
            locationsFromResponse
            (mapGqlError locationsFromResponse)


shorelineExtentToExtent : ShorelineExtent -> Extent
shorelineExtentToExtent { minX, minY, maxX, maxY } =
    Extent minX minY maxX maxY


encodeShorelineExtent : ShorelineExtent -> E.Value
encodeShorelineExtent location =
        E.object
            [ ( "name", E.string location.name )
            , ( "extent", E.list E.float [location.minX, location.minY, location.maxX, location.maxY] )
            ]


extentToString : Extent -> String
extentToString extent =
    [ extent.minX, extent.minY, extent.maxX, extent.maxY ]
        |> List.map String.fromFloat
        |> String.join ","


-- ACCESS


matchesName : String -> { a | name : String } -> Bool
matchesName name item =
    name == item.name

findLocationByName : String -> ShorelineExtents -> ShorelineExtents
findLocationByName name locations =
    let 
        found = locations |> Maybe.andThen (Zipper.findFirst (matchesName name))
    in
        case found of
            Just foundLocations -> Just foundLocations

            Nothing -> locations