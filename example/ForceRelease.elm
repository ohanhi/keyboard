module Main exposing (..)

import Browser
import Html exposing (Html, button, div, li, p, text, ul)
import Html.Events exposing (onClick)
import Keyboard as KeyEx exposing (Key)
import Style


type Msg
    = KeyboardMsg KeyEx.Msg
    | ForceRelease


{-| We don't need any other info in the model, since we can get everything we
need using the helpers right in the `view`!

This way we always have a single source of truth, and we don't need to remember
to do anything special in the update.

-}
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
                | pressedKeys = KeyEx.update keyMsg model.pressedKeys
              }
            , Cmd.none
            )

        ForceRelease ->
            ( { model
                | pressedKeys = List.filter ((/=) KeyEx.CharA) model.pressedKeys
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div Style.container
        [ p [] [ button [ onClick ForceRelease ] [ text "Force release of CharA" ] ]
        , p [] [ text "Currently pressed down:" ]
        , ul []
            (List.map (\key -> li [] [ text (Debug.toString key) ]) model.pressedKeys)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map KeyboardMsg KeyEx.subscriptions


main : Program () Model Msg
main =
    Browser.embed
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
