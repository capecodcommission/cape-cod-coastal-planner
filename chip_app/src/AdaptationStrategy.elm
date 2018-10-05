module AdaptationStrategy exposing (..)

import Dict exposing (Dict)
import Graphqelm.Http exposing (..)
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import ChipApi.Object
import ChipApi.Object.AdaptationStrategy as AS
import ChipApi.InputObject exposing (..)
import Graphqelm.OptionalArgument exposing (..)
import ChipApi.Query as Query
import ChipApi.Scalar as Scalar


-- TYPES


type alias Strategies = Dict String Strategy
    

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

-- TRANSFORM


activeStrategiesFromCache : Strategies -> List ActiveStrategy
activeStrategiesFromCache strategies =
    strategies
        |> Dict.values
        |> List.map (\(Strategy s) -> ActiveStrategy s.id s.name)


strategiesFromResponse : ActiveStrategies -> Strategies
strategiesFromResponse response =
    response.items
        |> List.map 
            (\item -> 
                let
                    getId (Scalar.Id id) = id
                in
                ( getId item.id
                , newStrategy item
                )            
            )
        |> Dict.fromList

-- HTTP


type alias ActiveStrategy = 
    { id : Scalar.Id
    , name : String
    }


type alias ActiveStrategies =
    { items : List ActiveStrategy }


queryAdaptationStrategies : SelectionSet ActiveStrategies RootQuery
queryAdaptationStrategies =
    Query.selection ActiveStrategies
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
        

