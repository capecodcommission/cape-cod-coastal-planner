module AdaptationStrategy.Strategies exposing (..)


import Dict exposing (Dict)
import Maybe.Extra as MEx
import RemoteData as Remote
import ChipApi.Scalar as Scalar
import Types exposing (GqlData, ZoneOfImpact, getId)
import AdaptationStrategy.StrategyDetails as Details exposing (StrategyDetails)


type alias Strategies =
    Dict String Strategy


type alias Strategy =
    { id : Scalar.Id
    , name : String
    , placement : Maybe Placement
    , details : GqlData (Maybe StrategyDetails)
    }


type alias Placement = String


type StrategyType
    = NoAction
    | Undevelopment
    | OpenSpaceProtection
    | SaltMarshRestoration
    | Revetment
    | DuneCreation
    | BankStabilization
    | LivingShoreline
    | BeachNourishment
    | ManagedRelocation
    | RetrofittingAssets


toType : Strategy -> Result String StrategyType
toType strategy =   
    toTypeFromStr strategy.name


toTypeFromStr : String -> Result String StrategyType
toTypeFromStr strategyName =
    case String.toLower strategyName of
        "no action" -> Ok NoAction

        "undevelopment" -> Ok Undevelopment

        "open space protection" -> Ok OpenSpaceProtection
        
        "salt marsh restoration" -> Ok SaltMarshRestoration

        "revetment" -> Ok Revetment

        "dune creation" -> Ok DuneCreation

        "bank stabilization" -> Ok BankStabilization

        "living shoreline" -> Ok LivingShoreline

        "beach nourishment" -> Ok BeachNourishment

        "managed relocation" -> Ok ManagedRelocation
        
        "retrofitting assets" -> Ok RetrofittingAssets

        badName -> Err badName


fromList : List Strategy -> Strategies
fromList list =
    list
        |> List.map (\s -> (getId s.id, s))
        |> Dict.fromList


get : Scalar.Id -> Strategies -> Maybe Strategy
get (Scalar.Id id) strategies =
    Dict.get id strategies



getDetailsById : Scalar.Id -> Strategies -> Maybe (GqlData (Maybe StrategyDetails))
getDetailsById id strategies =
    strategies
        |> get id
        |> Maybe.map .details


subset : List Scalar.Id -> Strategies -> List Strategy
subset ids strategies =
    ids
        |> List.map (\i -> get i strategies)
        |> MEx.values


updateStrategyDetails : Scalar.Id -> GqlData (Maybe StrategyDetails) -> Strategies -> Strategies
updateStrategyDetails (Scalar.Id id) data strategies = 
    strategies
        |> Dict.get id
        |> Maybe.map (\s -> { s | details = data })
        |> Maybe.map (\s -> Dict.insert id s strategies)
        |> Maybe.withDefault strategies


isApplicableToZoneOfImpact : ZoneOfImpact -> Strategy -> Bool
isApplicableToZoneOfImpact { placementMajorities } { placement } =
    case placement of
        Just "anywhere" ->
            True

        Just "undeveloped_only" ->
            placementMajorities.majorityUndeveloped

        Just "coastal_bank_only" ->
            placementMajorities.majorityCoastalBank

        Just "anywhere_but_salt_marsh" ->
            not placementMajorities.majoritySaltMarsh

        Just _ ->
            False

        Nothing ->
            True


hasCategory : Scalar.Id -> Strategy -> Bool
hasCategory id strategy =
    strategy.details
        |> Remote.toMaybe
        |> MEx.join
        |> Maybe.map (Details.hasCategory id)
        |> Maybe.withDefault False


hasHazard : Scalar.Id -> Strategy -> Bool
hasHazard id strategy =
    strategy.details
        |> Remote.toMaybe
        |> MEx.join
        |> Maybe.map (Details.hasHazard id)
        |> Maybe.withDefault False