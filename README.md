# Keyboard [![Build Status](https://travis-ci.org/ohanhi/keyboard.svg?branch=master)](https://travis-ci.org/ohanhi/keyboard)

Nice keyboard inputs in Elm.

Install with
```
elm install ohanhi/keyboard
```

## Usage

You can use this package in two ways:

1. The "Msg and Update" way, which has some setting up to do but has a bunch of ways to help you get the information you need.
2. The "Plain Subscriptions" way, where you get subscriptions for keys' down and up events, and handle the rest on your own.


## Full examples

All of the examples are in the [`example` directory](https://github.com/ohanhi/keyboard/tree/master/example) in the repository.


## Msg and Update

If you use the "Msg and Update" way, you will get the most help, such as:

- All keyboard keys are named values of the `Key` type, such as `ArrowUp`, `Character "A"` and `Enter`
- You can find out whether e.g. `Shift` is pressed down when any kind of a `Msg` happens in your program
- Arrow keys and WASD can be used as `{ x : Int, y : Int }` or as a union type (e.g. `South`, `NorthEast`)
- You can also get a full list of keys that are pressed down

When using Keyboard like this, it follows The Elm Architecture. Its model is a list of keys, and it has an `update` function and some `subscriptions`. Below are the necessary parts to wire things up. Once that is done, you can use the list of keys in your program as you like. You can also get useful information using the helper functions such as [`arrows`](http://package.elm-lang.org/packages/ohanhi/keyboard/latest/Keyboard-Arrows#arrows) and [`arrowsDirection`](http://package.elm-lang.org/packages/ohanhi/keyboard/latest/Keyboard-Arrows#arrowsDirection).

------

Include the list of keys in your program's model

```elm
import Keyboard exposing (Key(..))
import Keyboard.Arrows

type alias Model =
    { pressedKeys : List Key
    -- ...
    }

init : ( Model, Cmd Msg )
init =
    ( { pressedKeys = []
      -- ...
      }
    , Cmd.none
    )
```


Add the message type in your messages

```elm
type Msg
    = KeyMsg Keyboard.Msg
    -- ...
```

Include the subscriptions for the events to come through (remember to add them in your `main` too)

```elm
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map KeyMsg Keyboard.subscriptions
        -- ...
        ]

```


And finally, you can use `update` to have the list of keys be up to date

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyMsg keyMsg ->
            ( { model | pressedKeys = Keyboard.update keyMsg model.pressedKeys }
            , Cmd.none
            )
        -- ...
```

Now you can get all the information anywhere where you have access to the model, for example like so:

```elm
calculateSpeed : Model -> Float
calculateSpeed model =
    let
        arrows =
            Keyboard.Arrows.arrows model.pressedKeys
    in
        model.currentSpeed + arrows.x


isShooting : Model -> Bool
isShooting model =
    List.member Spacebar model.pressedKeys
```


Have fun! :)

---

**PS.** The [Tracking Key Changes example](https://github.com/ohanhi/keyboard/blob/master/example/TrackingKeyChanges.elm) example shows how to use `updateWithKeyChange` to find out exactly which key was pressed down / released on that update cycle.

## Stuck down keys

If the user presses a key combination that shifts focus, such as `Alt-Tab` or `Ctrl-L`,
some keys may get "stuck" in the keys list. One solution to this issue is to create a port subscription to the window `blur` events and clearing the entire key list from your model:

JavaScript

```js
window.onblur = function() { elmApp.ports.blurs.send({}) }
```

Elm

```elm
port blurs : (() -> msg) -> Sub msg

subscriptions : Sub Msg
subscriptions =
    Sub.batch
        [ Keyboard.subscriptions KeyboardMsg
        , blurs Blur
        ]


-- update
    ...
    Blur ->
        { model | pressedKeys = [] }
    ...
```


## Plain Subscriptions

With the "plain subscriptions" way, you get the bare minimum:

- All keyboard keys are named values of the `Key` type, such as `ArrowUp`, `Character "A"` and `Enter`

Setting up is very straight-forward:

```elm
import Keyboard exposing (RawKey)

type Msg
    = KeyDown RawKey
    | KeyUp RawKey
    -- ...


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        -- ...
        ]
```

Note that you will probably want to use one of the `KeyParser`s (or many with `oneOf`) in your update.

There's an example for this, too: [Plain Subscriptions](https://github.com/ohanhi/keyboard/blob/master/example/PlainSubscriptions.elm)
