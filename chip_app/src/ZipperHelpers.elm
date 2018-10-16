module ZipperHelpers exposing (..)

import Dict exposing (Dict)
import Maybe.Extra as MEx
import List.Zipper as Zipper exposing (Zipper)
import ChipApi.Scalar as Scalar


--
-- CREATE ZIPPERS
--


fromDictKeys : Dict comparable a -> Maybe (Zipper comparable)
fromDictKeys dict =
    dict
        |> Dict.keys
        |> Zipper.fromList



--
-- MAYBE ZIPPER HELPERS
--


tryFindFirst : (a -> Bool) -> Maybe (Zipper a) -> Maybe (Zipper a)
tryFindFirst predicate items =
    items
        |> Maybe.andThen (Zipper.findFirst predicate)
        |> MEx.orElse items


tryCurrent : Maybe (Zipper a) -> Maybe a
tryCurrent items =
    Maybe.map Zipper.current items


tryFirst : Maybe (Zipper a) -> Maybe (Zipper a)
tryFirst items =
    Maybe.map Zipper.first items


tryNext : Maybe (Zipper a) -> Maybe (Zipper a)
tryNext items =
    items
        |> Maybe.andThen Zipper.next
        |> MEx.orElse items        


tryPrevious : Maybe (Zipper a) -> Maybe (Zipper a)
tryPrevious items =
    items
        |> Maybe.andThen Zipper.previous
        |> MEx.orElse items


--
-- COMMON PREDICATES
-- 


matchesId : Scalar.Id -> { a | id : Scalar.Id } -> Bool
matchesId id item =
    id == item.id


matchesName : String -> { a | name : String } -> Bool
matchesName name item =
    name == item.name