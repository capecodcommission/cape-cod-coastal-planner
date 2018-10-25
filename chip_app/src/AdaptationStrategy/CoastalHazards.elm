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
    hazards |> ZipHelp.tryCurrent


currentHazardName : CoastalHazards -> Maybe String
currentHazardName hazards =
    hazards
        |> ZipHelp.tryCurrent
        |> Maybe.map .name


currentStrategyIds : CoastalHazards -> StrategyIds
currentStrategyIds hazards =
    hazards
        |> ZipHelp.tryCurrent
        |> Maybe.andThen .strategyIds


currentStrategyId : CoastalHazards -> Maybe Scalar.Id
currentStrategyId hazards =
    hazards
        |> ZipHelp.tryCurrent
        |> Maybe.andThen .strategyIds
        |> ZipHelp.tryCurrent


updateStrategyIds : (StrategyIds -> StrategyIds) -> CoastalHazards -> CoastalHazards
updateStrategyIds updateFn hazards =
    hazards
        |> ZipHelp.tryMapCurrent
            (\hazard ->
                { hazard | strategyIds = updateFn hazard.strategyIds }
            )