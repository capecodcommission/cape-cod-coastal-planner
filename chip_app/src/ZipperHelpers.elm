module ZipperHelpers exposing (..)


import List.Zipper as Zipper exposing (Zipper)
import ChipApi.Scalar as Scalar


--
-- MAYBE ZIPPER HELPERS
--


tryFindFirst : (a -> Bool) -> Maybe (Zipper a) -> Maybe (Zipper a)
tryFindFirst predicate items =
    items
        |> Maybe.map (Zipper.findFirst predicate)
        |> Maybe.withDefault items


tryCurrent : Maybe (Zipper a) -> Maybe a
tryCurrent items =
    Maybe.map Zipper.current items


tryFirst : Maybe (Zipper a) -> Maybe (Zipper a)
tryFirst items =
    Maybe.map Zipper.first items


tryNext : Maybe (Zipper a) -> Maybe (Zipper a)
tryNext items =
    items
        |> Maybe.map Zipper.next
        |> Maybe.withDefault items        


tryPrevious : Maybe (Zipper a) -> Maybe (Zipper a)
tryPrevious items =
    items
        |> Maybe.map Zipper.previous
        |> Maybe.withDefault items


--
-- COMMON PREDICATES
-- 


matchesId : Scalar.Id -> { a | id : Scalar.Id } -> Bool
matchesId id item =
    id == item.id


matchesName : String -> { a | name : String } -> Bool
matchesName name item =
    name == item.name