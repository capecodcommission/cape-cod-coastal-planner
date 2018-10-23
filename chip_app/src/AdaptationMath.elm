module AdaptationMath exposing (..)


import AdaptationHexes exposing (..)
import AdaptationStrategy exposing (..)
import AdaptationOutput exposing (..)
import ShorelineLocations exposing (..)
import Types exposing (..)


calculate : ShorelineExtent -> ZoneOfImpact -> AdaptationInfo -> AdaptationHexes -> Maybe AdaptationOutput
calculate { name } { shapeLength } { hazards, strategies } hexes =
    Nothing