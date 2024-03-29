-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module ChipApi.Object.AdaptationCategory exposing (..)

import ChipApi.InputObject
import ChipApi.Interface
import ChipApi.Object
import ChipApi.Scalar
import ChipApi.ScalarCodecs
import ChipApi.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


{-| The description of the category
-}
description : SelectionSet (Maybe String) ChipApi.Object.AdaptationCategory
description =
    Object.selectionForField "(Maybe String)" "description" [] (Decode.string |> Decode.nullable)


{-| The ID of the category
-}
id : SelectionSet ChipApi.ScalarCodecs.Id ChipApi.Object.AdaptationCategory
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (ChipApi.ScalarCodecs.codecs |> ChipApi.Scalar.unwrapCodecs |> .codecId |> .decoder)


{-| The server path to an image of the adaptation category when it is applicable
-}
imagePathActive : SelectionSet (Maybe String) ChipApi.Object.AdaptationCategory
imagePathActive =
    Object.selectionForField "(Maybe String)" "imagePathActive" [] (Decode.string |> Decode.nullable)


{-| The server path to an image of the adapation category when it is inapplicable
-}
imagePathInactive : SelectionSet (Maybe String) ChipApi.Object.AdaptationCategory
imagePathInactive =
    Object.selectionForField "(Maybe String)" "imagePathInactive" [] (Decode.string |> Decode.nullable)


{-| The name of the category
-}
name : SelectionSet String ChipApi.Object.AdaptationCategory
name =
    Object.selectionForField "String" "name" [] Decode.string


{-| The adaptation strategies that are associated with the category
-}
strategies :
    SelectionSet decodesTo ChipApi.Object.AdaptationStrategy
    -> SelectionSet (List decodesTo) ChipApi.Object.AdaptationCategory
strategies object____ =
    Object.selectionForCompositeField "strategies" [] object____ (Basics.identity >> Decode.list)
