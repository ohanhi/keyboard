module KeyboardTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode exposing (decodeString)
import Json.Encode as Encode
import Keyboard exposing (..)
import Test exposing (..)
import Tuple exposing (pair)


suite : Test
suite =
    concat
        [ fuzz keyboardEventJson "Decoder turns object to RawKey" <|
            \{ original, json } ->
                decodeString Keyboard.eventKeyDecoder json
                    |> Result.map Keyboard.rawValue
                    |> Expect.equal (Ok original)
        , fuzz randomRawKey "Random raw key with no parsers" <|
            \rawKey ->
                rawKey
                    |> Maybe.andThen (Keyboard.oneOf [])
                    |> Expect.equal Nothing
        , fuzz charRawKey "Character keys (always uppercase)" <|
            \( original, rawKey ) ->
                rawKey
                    |> Maybe.andThen Keyboard.characterKeyUpper
                    |> Expect.equal (Just (Character (String.toUpper original)))
        , fuzz charRawKey "Character key with case" <|
            \( original, rawKey ) ->
                rawKey
                    |> Maybe.andThen Keyboard.characterKeyOriginal
                    |> Expect.equal (Just (Character original))
        , describe "Non-ASCII characters" <|
            List.map characterUpperTest nonAscii
                ++ List.map (Tuple.first >> characterOriginalTest) nonAscii
        ]


nonAscii : List ( String, String )
nonAscii =
    [ pair "ä" "Ä"
    , pair "å" "Å"
    , pair "ñ" "Ñ"
    , pair "Ñ" "Ñ"
    , pair "ü" "Ü"
    , pair "ï" "Ï"
    , pair "â" "Â"
    , pair "ø" "Ø"
    , pair "€" "€"
    , pair "½" "½"
    ]


characterUpperTest : ( String, String ) -> Test
characterUpperTest ( original, expected ) =
    stringToJson original
        |> (\{ json } _ ->
                decodeString Keyboard.eventKeyDecoder json
                    |> Result.toMaybe
                    |> Maybe.andThen Keyboard.characterKeyUpper
                    |> Expect.equal (Just (Character expected))
           )
        |> test ("Uppercased " ++ original)


characterOriginalTest : String -> Test
characterOriginalTest original =
    stringToJson original
        |> (\{ json } _ ->
                decodeString Keyboard.eventKeyDecoder json
                    |> Result.toMaybe
                    |> Maybe.andThen Keyboard.characterKeyOriginal
                    |> Expect.equal (Just (Character original))
           )
        |> test ("With original case " ++ original)


charRawKey : Fuzzer ( String, Maybe RawKey )
charRawKey =
    Fuzz.char
        |> Fuzz.map (String.fromChar >> stringToJson)
        |> Fuzz.map
            (\{ original, json } ->
                ( original
                , json
                    |> decodeString Keyboard.eventKeyDecoder
                    |> Result.toMaybe
                )
            )


randomRawKey : Fuzzer (Maybe RawKey)
randomRawKey =
    keyboardEventJson
        |> Fuzz.map
            (\{ json } ->
                json
                    |> decodeString Keyboard.eventKeyDecoder
                    |> Result.toMaybe
            )


keyboardEventJson : Fuzzer { original : String, json : String }
keyboardEventJson =
    string
        |> Fuzz.map stringToJson


stringToJson : String -> { original : String, json : String }
stringToJson value =
    [ ( "key", Encode.string value ) ]
        |> Encode.object
        |> Encode.encode 0
        |> (\json -> { original = value, json = json })
