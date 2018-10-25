module AdaptationMath exposing (..)


-- import AdaptationStrategy exposing (..)
import AdaptationOutput exposing (..)
-- import ShorelineLocation exposing (..)
-- import Types exposing (..)


{-| Need to know the current hazard and the current strategy.

-}
--calculate : ShorelineExtent -> ZoneOfImpact -> AdaptationInfo -> GqlData AdaptationHexes -> AdaptationOutput
calculate : String -> String -> String -> String -> AdaptationOutput
calculate name shapeLength info hexResponse =
    NotCalculated