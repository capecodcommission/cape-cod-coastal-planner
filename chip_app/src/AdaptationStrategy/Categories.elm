module AdaptationStrategy.Categories exposing (..)


import Dict exposing (Dict)
import Maybe.Extra as MEx
import ChipApi.Scalar as Scalar
import Types exposing (getId)


type alias Categories =
    Dict String Category


type alias Category =
    { id : Scalar.Id
    , name : String
    , description : Maybe String
    , imagePathActive : Maybe String
    , imagePathInactive : Maybe String
    }


fromList : List Category -> Categories
fromList list =
    list 
        |> List.map (\c -> (getId c.id, c))
        |> Dict.fromList


get : Scalar.Id -> Categories -> Maybe Category
get (Scalar.Id id) categories =
    Dict.get id categories


subset : List Scalar.Id -> Categories -> List Category
subset ids categories =
    ids
        |> List.map (\i -> get i categories)
        |> MEx.values