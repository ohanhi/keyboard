module VisualArrows exposing (..)

import Browser
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (style)
import Keyboard exposing (Key)
import Keyboard.Arrows exposing (Direction(..))
import Style


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type Msg
    = KeyboardMsg Keyboard.Msg


type alias Model =
    { pressedKeys : List Key
    }


init : ( Model, Cmd Msg )
init =
    ( Model []
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardMsg keyMsg ->
            ( { model
                | pressedKeys = Keyboard.update keyMsg model.pressedKeys
              }
            , Cmd.none
            )


view : Model -> Html msg
view model =
    let
        arrows =
            Keyboard.Arrows.arrowsDirection model.pressedKeys

        wasd =
            Keyboard.Arrows.wasdDirection model.pressedKeys
    in
    div Style.container
        [ div []
            [ p [] [ text ("Arrows: " ++ Debug.toString arrows) ]
            , directionView arrows
            ]
        , div
            []
            [ p [] [ text ("WASD: " ++ Debug.toString wasd) ]
            , directionView wasd
            ]
        ]


directionView : Direction -> Html msg
directionView direction =
    let
        angle =
            directionToAngle direction
                |> String.fromFloat

        char =
            case direction of
                NoDirection ->
                    "🞄"

                _ ->
                    "↑"
    in
    p
        [ style "transform" ("rotate(" ++ angle ++ "rad)")
        , style "width" "1em"
        , style "height" "1em"
        , style "line-height" "1"
        , style "text-align" "center"
        , style "margin" "auto"
        , style "font-size" "10em"
        ]
        [ text char
        ]


directionToAngle : Direction -> Float
directionToAngle direction =
    case direction of
        North ->
            0

        NorthEast ->
            pi * 0.25

        East ->
            pi * 0.5

        SouthEast ->
            pi * 0.75

        South ->
            pi * 1

        SouthWest ->
            pi * 1.25

        West ->
            pi * 1.5

        NorthWest ->
            pi * 1.75

        NoDirection ->
            0


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map KeyboardMsg Keyboard.subscriptions
