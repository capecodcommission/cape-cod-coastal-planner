module View.Dropdown exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input exposing (..)
import RemoteData exposing (RemoteData(..))
import Graphqelm.Http as GHttp exposing (Error(..))
import String.Extra as SEx
import List.Zipper as Zipper exposing (Zipper)
import Message exposing (..)
import Types exposing (..)
import Styles exposing (..)
import View.Helpers exposing (..)


type alias Dropdown a =
    { menu : SelectWith { a | name : String } Msg
    , isOpen : Bool
    , name : String
    }


view : 
    Dropdown a 
    -> GqlData (Maybe (Zipper { a | name : String }))
    -> Element MainStyles Variations Msg
view dropdown data =
    let
        placeholderPadding =
            dropdown.menu
                |> Input.selected
                |> Maybe.map (\_ -> 0)
                |> Maybe.withDefault 16
    in
        Input.select (Header HeaderMenu)
            [ height (px 42)
            , width (px 327)
            , paddingLeft placeholderPadding
            , paddingRight 16
            , vary SelectMenuOpen dropdown.isOpen
            , vary SelectMenuError <| RemoteData.isFailure data
            ]
            { label = dropdownPlaceholder dropdown.name data
            , with = dropdown.menu
            , max = getMaxItems data
            , options = dropdownOptions data
            , menu =
                Input.menu (Header HeaderSubMenu)
                    [ forceTransparent 327 500 ]
                    (menuItemsView data)
            }


dropdownPlaceholder : 
    String 
    -> GqlData (Maybe (Zipper { a | name : String }))
    -> Label MainStyles Variations Msg
dropdownPlaceholder name data =
    let
        titlecased =
            SEx.toTitleCase name

        ( placeholderText, hiddenText ) =
            case data of
                NotAsked ->
                    ( "", "Select " ++ titlecased )

                Loading ->
                    ( "Loading " ++ titlecased ++ "...", "Select " ++ titlecased )

                Failure err ->
                    err
                        |> errorText name
                        |> Tuple.mapFirst (\e -> "(" ++ e ++ ")")
                        |> Tuple.mapSecond (\e -> "Select " ++ titlecased ++ ": " ++ e)

                Success _ ->
                    ( "Select " ++ titlecased, "Select " ++ titlecased )
    in
        Input.placeholder
            { text = placeholderText
            , label = Input.hiddenLabel hiddenText
            }


dropdownOptions : 
    GqlData (Maybe (Zipper { a | name : String })) 
    -> List (Input.Option MainStyles Variations Msg)
dropdownOptions data =
    case data of
        Success (Just items) ->
            []

        _ ->
            [ Input.disabled ]


menuItemsView : 
    GqlData (Maybe (Zipper { a | name : String })) 
    -> List (Input.Choice { a | name : String } MainStyles Variations Msg)
menuItemsView data =
    case data of
        Success (Just items) ->
            let
                listItems = Zipper.toList items
            in
            List.indexedMap (menuItemView ((List.length listItems) - 1)) listItems

        _ ->
            []


menuItemView : 
    Int 
    -> Int 
    -> { a | name : String } 
    -> Input.Choice { a | name : String } MainStyles Variations Msg
menuItemView lastIndex currentIndex item =
    Input.styledSelectChoice item <|
        (\state ->
            el (Header HeaderMenuItem)
                [ vary (choiceStateToVariation state) True
                , vary LastMenuItem (lastIndex == currentIndex)
                , paddingXY 16 5
                ]
                (Element.text item.name)
        )


getMaxItems : GqlData (Maybe (Zipper { b | name : String })) -> Int
getMaxItems data =
    case data of
        Success (Just items) ->
            List.length <| Zipper.toList items

        _ -> 
            0


errorText : String -> GHttp.Error a -> ( String, String )
errorText name error =
    error
        |> parseErrors
        |> List.head
        |> Maybe.withDefault ( "Failed to load " ++ String.toLower name, "" )


{-| `forceTransparent` is a hack to...force transparency...generally on select menus due to
the fact that the value is hardcoded to be `white`. See the link below for details (line 1883).

Additionally, we must also supply all other values that are inlined so as to keep
the correct functionality, since using `attribute` in this way seems to overwrite
`Element.Attributes.inlineStyle` as used in the source.

<https://github.com/mdgriffith/style-elements/blob/4.3.0/src/Element/Input.elm>

-}
forceTransparent : Float -> Float -> Element.Attribute Variations Msg
forceTransparent width maxHeight =
    let
        inlineStyles =
            [ "pointer-events:auto"
            , "display:flex"
            , "flex-direction:column"
            , "width:" ++ toString width ++ "px"
            , "max-height:" ++ toString maxHeight ++ "px"
            , "overflow-y:auto"
            , "position:relative"
            , "top:calc(100% * 0px)"
            , "left:0px"
            , "box-sizing:border-box"
            , "cursor:pointer"
            , "z-index: 20"
            , "background:transparent"
            ]
                |> String.join ";"
    in
        attribute "style" inlineStyles
