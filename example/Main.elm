module Main exposing (..)

import Browser
import Html exposing (Html, div, li, p, text, ul)
import Keyboard exposing (Key(..))
import Keyboard.Arrows
import Style


type Msg
    = KeyboardMsg Keyboard.Msg


{-| We don't need any other info in the model, since we can get everything we
need using the helpers right in the `view`!

This way we always have a single source of truth, and we don't need to remember
to do anything special in the update.

-}
type alias Model =
    { pressedKeys : List Key
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { pressedKeys = [] }
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
        shiftPressed =
            List.member Shift model.pressedKeys

        arrows =
            Keyboard.Arrows.arrows model.pressedKeys

        wasd =
            Keyboard.Arrows.wasd model.pressedKeys
    in
    div Style.container
        [ text ("Shift: " ++ Debug.toString shiftPressed)
        , p [] [ text ("Arrows: " ++ Debug.toString arrows) ]
        , p [] [ text ("WASD: " ++ Debug.toString wasd) ]
        , p [] [ text "Currently pressed down:" ]
        , ul []
            (List.map (\key -> li [] [ text (Debug.toString key) ]) model.pressedKeys)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map KeyboardMsg Keyboard.subscriptions


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
