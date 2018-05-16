module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (on)
import Json.Decode as Json
import Keyboard as Keyboard
import Style


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    Maybe Keyboard.Key


init : Model
init =
    Nothing


type Msg
    = KeyPress Keyboard.Key


update : Msg -> Model -> Model
update msg model =
    case msg of
        KeyPress char ->
            Just char


view : Model -> Html Msg
view model =
    div Style.container
        [ p [] [ text "Enter text below:" ]
        , textarea [ on "keydown" <| Json.map KeyPress Keyboard.targetKey ] []
        , p [] [ text <| Debug.toString model ]
        ]
