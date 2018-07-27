module View.Dropdown exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input exposing (..)
import RemoteData exposing (RemoteData(..))
import Graphqelm.Http exposing (Error(..))
import String.Extra as SEx
import Message exposing (..)
import Types exposing (..)
import Styles exposing (..)
import View.Helpers exposing (..)


type alias Dropdown a b =
    { data : GqlData { a | items : List { b | name : String } }
    , menu : SelectWith { b | name : String } Msg
    , isOpen : Bool
    , name : String
    }


view : Dropdown a b -> Element MainStyles Variations Msg
view dropdown =
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
            , vary SelectMenuError <| RemoteData.isFailure dropdown.data
            ]
            { label = dropdownPlaceholder dropdown.name dropdown.data
            , with = dropdown.menu
            , max = getMaxItems dropdown.data
            , options = dropdownOptions dropdown.data
            , menu =
                Input.menu (Header HeaderSubMenu)
                    [ forceTransparent 327 500 ]
                    (menuItemsView dropdown.data)
            }


dropdownPlaceholder : String -> GqlData { a | items : List { b | name : String } } -> Label MainStyles Variations Msg
dropdownPlaceholder name data =
    let
        titlecased =
            SEx.toTitleCase name

        lowercased =
            String.toLower name

        ( placeholderText, hiddenText ) =
            case data of
                NotAsked ->
                    ( "", "Select " ++ titlecased )

                Loading ->
                    ( "loading " ++ lowercased ++ "...", "Select " ++ titlecased )

                Failure err ->
                    err
                        |> errorText name
                        |> Tuple.mapFirst (\e -> "(" ++ e ++ ")")
                        |> Tuple.mapSecond (\e -> "Select " ++ titlecased ++ ": " ++ e)

                Success _ ->
                    ( "select " ++ lowercased, "Select " ++ titlecased )
    in
        Input.placeholder
            { text = placeholderText
            , label = Input.hiddenLabel hiddenText
            }


dropdownOptions : GqlData { a | items : List { b | name : String } } -> List (Input.Option MainStyles Variations Msg)
dropdownOptions data =
    case data of
        Success _ ->
            []

        _ ->
            [ Input.disabled ]


menuItemsView : GqlData { a | items : List { b | name : String } } -> List (Input.Choice { b | name : String } MainStyles Variations Msg)
menuItemsView data =
    case data of
        Success data ->
            data.items
                |> List.indexedMap (menuItemView ((List.length data.items) - 1))

        _ ->
            []


menuItemView : Int -> Int -> { b | name : String } -> Input.Choice { b | name : String } MainStyles Variations Msg
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


getMaxItems : GqlData { a | items : List { b | name : String } } -> Int
getMaxItems data =
    case data of
        NotAsked ->
            0

        Loading ->
            0

        Success val ->
            List.length val.items

        Failure _ ->
            0


errorText : String -> Graphqelm.Http.Error a -> ( String, String )
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
