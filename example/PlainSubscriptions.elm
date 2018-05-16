module PlainSubscriptions exposing (..)

import Browser
import Html exposing (Html, div, li, p, text, ul)
import Keyboard exposing (Key)
import Style



{- Subscribing to keyboard events without the whole model-update -thing. -}


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        ]


main : Program () Model Msg
main =
    Browser.embed
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type Msg
    = KeyDown Key
    | KeyUp Key


type alias Model =
    { events : List String
    }


init : ( Model, Cmd Msg )
init =
    ( Model []
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( { model | events = Debug.toString msg :: model.events }
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
    model.events
        |> List.map (\event -> li [] [ text event ])
        |> ul []
