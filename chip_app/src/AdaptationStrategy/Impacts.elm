module AdapationStrategy.Impacts exposing (..)


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