module TrackingKeyChanges exposing (..)

import Browser
import Html exposing (Html, div, li, p, text, ul)
import Keyboard exposing (Key(..))
import Style


main : Program () Model Msg
main =
    Browser.embed
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type Msg
    = KeyboardMsg Keyboard.Msg


type alias Model =
    { pressedKeys : List Key
    , keyChanges : List Keyboard.KeyChange
    }


init : ( Model, Cmd Msg )
init =
    ( Model [] []
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardMsg keyMsg ->
            let
                ( pressedKeys, maybeKeyChange ) =
                    Keyboard.updateWithKeyChange keyMsg model.pressedKeys

                keyChanges =
                    case maybeKeyChange of
                        Just keyChange ->
                            keyChange :: model.keyChanges

                        Nothing ->
                            model.keyChanges
            in
            ( { model
                | pressedKeys = pressedKeys
                , keyChanges = keyChanges
              }
            , Cmd.none
            )


view : Model -> Html msg
view model =
    div Style.container
        [ p [] [ text "Try pressing, releasing and long-pressing keys." ]
        , keysView model
        ]


keysView : Model -> Html msg
keysView model =
    model.keyChanges
        |> List.map (\change -> li [] [ text (Debug.toString change) ])
        |> ul []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map KeyboardMsg Keyboard.subscriptions
