module AdaptationMath exposing (..)


import AdaptationStrategy.CoastalHazards exposing (CoastalHazard)
import AdaptationStrategy.Strategies exposing (Strategy)
import AdaptationHexes exposing (AdaptationHexes)
import AdaptationOutput exposing (..)
import ShorelineLocation exposing (..)
import RemoteData as Remote exposing (WebData, RemoteData(..))
import Types exposing (..)


{-| Need to know the current hazard and the current strategy.

-}
calculate : 
    WebData AdaptationHexes 
    -> ShorelineExtent 
    -> ZoneOfImpact 
    -> CoastalHazard
    -> Strategy
    -> AdaptationOutput
calculate hexResponse {name} {shapeLength} hazard strategy =
    case hexResponse of
        NotAsked -> 
            NotCalculated

        Loading -> 
            CalculatingOutput

        Failure err ->
            HexHttpError err

        Success hexData ->
            CalculationError
                [ "There was an error doing a thing."
                , "There was another error doing something else."
                , "Finally, this thing exploded."
                ]

