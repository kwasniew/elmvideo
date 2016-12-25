module Tests exposing (..)

import Test exposing (..)
import Fuzz exposing (..)
import Expect
import App exposing (..)
import Navigation exposing (Location)
import Types exposing (..)
import Decoder exposing (..)


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
        , describe "Movie List Decoder"
            [ test "results in empty list on parsing error" <|
                \() ->
                    let
                        json =
                            """{"gibberish": []}"""
                    in
                        Expect.equal (decodeMovies json) []
            , test "successfully decodes a valid json" <|
                \() ->
                    """ {"shows": [{
                            "title": "title",
                            "year": "2000",
                            "description": "desc",
                            "poster": "poster.jpg",
                            "imdbID": "tt1856010",
                            "trailer": "NTzycsqxYJ0"
                        }] }"""
                        |> decodeMovies
                        |> Expect.equal
                            [ { title = "title"
                              , year = "2000"
                              , description = "desc"
                              , poster = "poster.jpg"
                              , id = "tt1856010"
                              , trailer = "NTzycsqxYJ0"
                              }
                            ]
            , fuzz (list int) "sucessfully decodes one movie for each item in the JSON" <|
                \ids ->
                    let
                        jsonFromId id =
                            """ {
                                "title": "title",
                                "year": "2000",
                                "description": "desc",
                                "poster": "poster.jpg",
                                "imdbID":" """ ++ toString id ++ """ ",
                                "trailer": "NTzycsqxYJ0"
                            } """

                        jsonItems =
                            String.join ", " (List.map jsonFromId ids)

                        json =
                            """ {"shows": [""" ++ jsonItems ++ """]} """
                    in
                        Expect.equal (List.length (decodeMovies json)) (List.length ids)
            ]
        ]
