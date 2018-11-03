module AdaptationStrategy.Impacts exposing (..)


type alias ImpactScale =
    { name : String
    , impact : Int
    , description : Maybe String
    }

 
type alias ImpactCost =
    { name : String
    , cost : Int
    , description : Maybe String
    }


type alias ImpactLifeSpan =
    { name : String
    , lifeSpan : Int
    , description : Maybe String
    }


hasScale : String -> List ImpactScale -> Bool
hasScale name scales =
    scales |> List.any (matchesName name)


matchesName : String -> ImpactScale -> Bool
matchesName name scale =
    String.toLower name == String.toLower scale.name