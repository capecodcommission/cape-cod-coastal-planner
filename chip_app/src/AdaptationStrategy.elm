module AdaptationStrategy exposing (..)

import List.Zipper as Zipper exposing (..)
import Graphqelm.Http exposing (..)
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import Graphqelm.Http.GraphqlError exposing (PossiblyParsedData(..))
import ChipApi.Object
import ChipApi.Object.AdaptationStrategy as AS
import Graphqelm.OptionalArgument exposing (..)
import ChipApi.Query as Query
import ChipApi.Scalar as Scalar


-- TYPES


type alias Strategies = Maybe (Zipper Strategy)
    

type Strategy =
    Strategy
        { id : Scalar.Id
        , name : String
        , description : Maybe String
        , currentlyPermittable : Maybe String
        , imagePath : Maybe String
        , categories : List Category
        , hazards : List CoastalHazard
        , scales : List ImpactScale
        , placements : List Placement
        , benefits : List Benefit
        , advantages : List Advantage
        , disadvantages : List Disadvantage
        }


type Category =
    Category
        { name : String
        , description : Maybe String
        }


type CoastalHazard =
    CoastalHazard
        { name : String
        , description : Maybe String
        }


type ImpactScale =
    ImpactScale
        { name : String
        , impact : Int
        , description : Maybe String
        }


type Placement =
    Placement String


type Benefit =
    Benefit String


type Advantage =
    Advantage String


type Disadvantage =
    Disadvantage String


-- CREATE


newStrategy : { a | id : Scalar.Id, name : String } -> Strategy
newStrategy { id, name } = 
    Strategy
        { id = id
        , name = name
        , description = Nothing
        , currentlyPermittable = Nothing
        , imagePath = Nothing
        , categories = []
        , hazards = []
        , scales = []
        , placements = []
        , benefits = []
        , advantages = []
        , disadvantages = []
        }


-- ACCESS


getStrategyHtmlId : Strategy -> String
getStrategyHtmlId (Strategy { id }) =
    case id of
        Scalar.Id theId ->
            "strategy-" ++ theId


getSelectedStrategyHtmlId : Strategies -> Maybe String
getSelectedStrategyHtmlId strategies =
    strategies
        |> Maybe.map Zipper.current
        |> Maybe.map getStrategyHtmlId            


currentStrategy : Strategies -> Maybe Strategy
currentStrategy strategies =
    strategies
        |> Maybe.map Zipper.current


findStrategy : Scalar.Id -> Strategies -> Strategies
findStrategy id strategies =
    let 
        found = strategies |> Maybe.andThen (Zipper.findFirst (matchesId id))
    in
        case found of
            Just foundStrategies -> Just foundStrategies

            Nothing -> strategies


nextStrategy : Strategies -> Strategies
nextStrategy strategies =
    let
        next = strategies |> Maybe.andThen Zipper.next
    in
        case next of
            Just nextStrategies -> Just nextStrategies

            Nothing -> strategies


previousStrategy : Strategies -> Strategies
previousStrategy strategies =
    let
        previous = strategies |> Maybe.andThen Zipper.previous
    in
        case previous of
            Just previousStrategies -> Just previousStrategies

            Nothing -> strategies


matchesId : Scalar.Id -> Strategy -> Bool
matchesId (Scalar.Id targetId) (Strategy strategy) =
    case strategy.id of
        Scalar.Id theId ->
            theId == targetId


-- TRANSFORM


strategiesFromResponse : ActiveStrategiesResponse -> Strategies
strategiesFromResponse response =
    response.items
        |> List.map newStrategy
        |> Zipper.fromList


mapErrorFromResponse : Graphqelm.Http.Error ActiveStrategiesResponse -> Graphqelm.Http.Error Strategies
mapErrorFromResponse error =
    case error of
        HttpError err ->
            HttpError err

        GraphqlError (ParsedData parsed) errs ->
            GraphqlError (ParsedData <| strategiesFromResponse parsed) errs

        GraphqlError (UnparsedData val) errs ->
            GraphqlError (UnparsedData val) errs


-- HTTP


type alias ActiveStrategy = 
    { id : Scalar.Id
    , name : String
    }


type alias ActiveStrategiesResponse =
    { items : List ActiveStrategy }


queryAdaptationStrategies : SelectionSet ActiveStrategiesResponse RootQuery
queryAdaptationStrategies =
    Query.selection ActiveStrategiesResponse
        |> with 
            (Query.adaptationStrategies 
                (\optionals -> 
                    { optionals 
                        | filter = Present { isActive = Present True, name = Absent }
                    } 
                ) activeAdaptationStrategies
            )


activeAdaptationStrategies : SelectionSet ActiveStrategy ChipApi.Object.AdaptationStrategy
activeAdaptationStrategies =
    AS.selection ActiveStrategy
        |> with AS.id
        |> with AS.name
        

