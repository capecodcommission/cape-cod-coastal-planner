module AdaptationMath exposing (..)


import AdaptationHexes exposing (..)
import AdaptationStrategy exposing (..)
import AdaptationOutput exposing (..)
import ShorelineLocation exposing (..)
import Types exposing (..)


{-| Need to know the current hazard and the current strategy.

-}
calculate : ShorelineExtent -> ZoneOfImpact -> AdaptationInfo -> GqlData AdaptationHexes -> AdaptationOutput
calculate { name } { shapeLength } { hazards, strategies } hexResponse =
    NotCalculated