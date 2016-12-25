module Tests exposing (..)

import Test exposing (..)
import Expect
import App exposing (..)
import Navigation exposing (Location)
import Types exposing (..)


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
        [ describe "Navigation"
            [ describe "Path to Page"
                [ test "Details" <|
                    \() ->
                        Expect.equal (page "/details/1234") (Details "1234")
                , test "Search" <|
                    \() ->
                        Expect.equal (page "/search") Search
                , test "Landing" <|
                    \() ->
                        Expect.equal (page "/") Landing
                , test "Default" <|
                    \() ->
                        Expect.equal (page "/gibberish") Landing
                ]
            , describe "Page to Path"
                [ test "Details" <|
                    \() ->
                        Expect.equal (pageToPath (Details "1234")) "/details/1234"
                , test "Search" <|
                    \() ->
                        Expect.equal (pageToPath Search) "/search"
                , test "Landing" <|
                    \() ->
                        Expect.equal (pageToPath Landing) "/"
                ]
            ]
        ]
