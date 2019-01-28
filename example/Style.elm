module Style exposing (container)

import Html
import Html.Attributes exposing (style)


container : List (Html.Attribute msg)
container =
    [ style "background-color" "rebeccapurple"
    , style "color" "white"
    , style "font-family" "sans-serif"
    , style "width" "100vw"
    , style "height" "100vh"
    , style "display" "flex"
    , style "align-items" "center"
    , style "justify-content" "flex-start"
    , style "box-sizing" "border-box"
    , style "padding" "4em 2em"
    , style "flex-direction" "column"
    ]
