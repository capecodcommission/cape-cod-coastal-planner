module AdaptationStrategy.CoastalHazards exposing (..)


import List.Zipper as Zipper exposing (..)
import ZipperHelpers as ZipHelp
import ChipApi.Scalar as Scalar


type alias CoastalHazards =
    Maybe (Zipper CoastalHazard)


type alias CoastalHazard =
    { id : Scalar.Id
    , name : String
    , description : Maybe String
    , strategyIds : StrategyIds
    }


type alias StrategyIds = Maybe (Zipper Scalar.Id)


fromList : List CoastalHazard -> CoastalHazards
fromList list =
    list |> Zipper.fromList


current : CoastalHazards -> Maybe CoastalHazard
current hazards =
    hazards |> Maybe.map Zipper.current


currentHazardName : CoastalHazards -> Maybe String
currentHazardName hazards =
    hazards
        |> Maybe.map Zipper.current
        |> Maybe.map .name


currentStrategyId : CoastalHazards -> Maybe Scalar.Id
currentStrategyId hazards =
    hazards
        |> Maybe.map Zipper.current
        |> Maybe.andThen .strategyIds
        |> Maybe.map Zipper.current


updateStrategyIds : (StrategyIds -> StrategyIds) -> CoastalHazards -> CoastalHazards
updateStrategyIds updateFn hazards =
    hazards
        |> ZipHelp.tryMapCurrent
            (\hazard ->
                { hazard | strategyIds = updateFn hazard.strategyIds }
            )

