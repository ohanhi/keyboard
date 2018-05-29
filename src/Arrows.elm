module Arrows
    exposing
        ( Arrows
        , Direction(..)
        , arrows
        , arrowsDirection
        , wasd
        , wasdDirection
        )

{-| Arrow keys and WASD get special treatment using the functions in this module. This is particularly useful for games.

@docs Arrows, arrows, wasd, Direction, arrowsDirection, wasdDirection

-}

import Keyboard exposing (Key(..))


{-| Record type used for `arrows` and `wasd`.
Both `x` and `y` can range from `-1` to `1`, and are `0` if no keys are pressed.
-}
type alias Arrows =
    { x : Int, y : Int }


{-| Gives the arrow keys' pressed down state as follows:

    arrows []                      --> { x = 0, y = 0 }

    arrows [ ArrowLeft ]           --> { x = -1, y = 0 }

    arrows [ ArrowUp, ArrowRight ] --> { x = 1, y = 1 }

    arrows [ ArrowDown, ArrowLeft, ArrowRight ]
                                   --> { x = 0, y = -1 }

-}
arrows : List Key -> Arrows
arrows keys =
    let
        toInt key =
            keys
                |> List.member key
                |> boolToInt

        x =
            toInt ArrowRight - toInt ArrowLeft

        y =
            toInt ArrowUp - toInt ArrowDown
    in
    { x = x, y = y }


{-| Similar to `arrows`, gives the W, A, S and D keys' pressed down state.

    wasd []                       --> { x = 0, y = 0 }

    wasd [ CharA ]                --> { x = -1, y = 0 }

    wasd [ CharW, CharD ]         --> { x = 1, y = 1 }

    wasd [ CharA, CharS, CharD ]  --> { x = 0, y = -1 }

-}
wasd : List Key -> Arrows
wasd keys =
    let
        toInt key =
            keys
                |> List.member key
                |> boolToInt

        x =
            toInt CharD - toInt CharA

        y =
            toInt CharW - toInt CharS
    in
    { x = x, y = y }


{-| Type representation of the arrows.
-}
type Direction
    = North
    | NorthEast
    | East
    | SouthEast
    | South
    | SouthWest
    | West
    | NorthWest
    | NoDirection


{-| Gives the arrow keys' pressed down state as follows:

    arrowsDirection []                      --> NoDirection

    arrowsDirection [ ArrowLeft ]           --> West

    arrowsDirection [ ArrowUp, ArrowRight ] --> NorthEast

    arrowsDirection [ ArrowDown, ArrowLeft, ArrowRight ]
                                            --> South

-}
arrowsDirection : List Key -> Direction
arrowsDirection =
    arrowsToDir << arrows


{-| Similar to `arrows`, gives the W, A, S and D keys' pressed down state.

    wasdDirection []                      --> NoDirection

    wasdDirection [ CharA ]               --> West

    wasdDirection [ CharW, CharD ]        --> NorthEast

    wasdDirection [ CharA, CharS, CharD ] --> South

-}
wasdDirection : List Key -> Direction
wasdDirection =
    arrowsToDir << wasd


arrowsToDir : Arrows -> Direction
arrowsToDir { x, y } =
    let
        x1 =
            x + 1

        y1 =
            y + 1
    in
    case ( x1, y1 ) of
        ( 1, 2 ) ->
            North

        ( 2, 2 ) ->
            NorthEast

        ( 2, 1 ) ->
            East

        ( 2, 0 ) ->
            SouthEast

        ( 1, 0 ) ->
            South

        ( 0, 0 ) ->
            SouthWest

        ( 0, 1 ) ->
            West

        ( 0, 2 ) ->
            NorthWest

        _ ->
            NoDirection


boolToInt : Bool -> Int
boolToInt bool =
    if bool then
        1

    else
        0
