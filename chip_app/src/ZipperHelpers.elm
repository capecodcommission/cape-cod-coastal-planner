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


tryNextUntil : (a -> Bool) -> Maybe (Zipper a) -> Maybe (Zipper a)
tryNextUntil predicate items =
    let
        nextItems = items |> Maybe.andThen Zipper.next

        next = nextItems |> Maybe.map Zipper.current
    in
    case next of
        Just n ->
            case predicate n of
                True ->
                    nextItems

                False ->
                    tryNextUntil predicate nextItems

        Nothing ->
            items



tryPrevious : Maybe (Zipper a) -> Maybe (Zipper a)
tryPrevious items =
    items
        |> Maybe.andThen Zipper.previous
        |> MEx.orElse items


tryPreviousUntil : (a -> Bool) -> Maybe (Zipper a) -> Maybe (Zipper a)
tryPreviousUntil predicate items =
    let
        prevItems = items |> Maybe.andThen Zipper.previous

        prev = prevItems |> Maybe.map Zipper.current
    in
    case prev of
        Just n ->
            case predicate n of
                True ->
                    prevItems

                False ->
                    tryPreviousUntil predicate prevItems

        Nothing ->
            items


tryPreviousOrLast : Maybe (Zipper a) -> Maybe (Zipper a)
tryPreviousOrLast items =
    items
        |> Maybe.andThen Zipper.previous
        |> MEx.orElse (items |> Maybe.map Zipper.last)


tryNextOrFirst : Maybe (Zipper a) -> Maybe (Zipper a)
tryNextOrFirst items =
    items 
        |> Maybe.andThen Zipper.next
        |> MEx.orElse (items |> Maybe.map Zipper.first)


tryMapCurrent : (a -> a) -> Maybe (Zipper a) -> Maybe (Zipper a)
tryMapCurrent fn items =
    items
        |> Maybe.map (Zipper.mapCurrent fn)
        |> MEx.orElse items


tryMap : (a -> b) -> Maybe (Zipper a) -> Maybe (Zipper b)
tryMap fn items =
    items
        |> Maybe.map (Zipper.map fn)
        |> MEx.orElse Nothing


--
-- COMMON PREDICATES
-- 


matches : a -> a -> Bool
matches item1 item2 =
    item1 == item2


matchesId : Scalar.Id -> { a | id : Scalar.Id } -> Bool
matchesId id item =
    id == item.id


matchesName : String -> { a | name : String } -> Bool
matchesName name item =
    name == item.name