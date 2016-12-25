module Tests exposing (..)

import Test exposing (..)
import Expect
import App exposing (..)
import Navigation exposing (Location)


location : String -> Location
location pathname =
    { href = ("http://localhost:3000" ++ pathname)
    , host = "localhost:3000"
    , hostname = "localhost"
    , protocol = "http:"
    , origin = "http://localhost:3000"
    , port_ = "3000"
    , pathname = pathname
    , search = ""
    , hash = ""
    , username = ""
    , password = ""
    }


page : String -> Page
page pathname =
    pathname |> location |> pathToPage


all : Test
all =
    describe "Elmflix"
        [ test "Navigation: Details" <|
            \() ->
                Expect.equal (page "/details/1234") (Details "1234")
        , test "Navigation: Search" <|
            \() ->
                Expect.equal (page "/search") Search
        , test "Navigation: Landing" <|
            \() ->
                Expect.equal (page "/") Landing
        , test "Navigation: default" <|
            \() ->
                Expect.equal (page "/gibberish") Landing
        ]
