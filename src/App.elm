module App exposing (..)

import Html exposing (Html, text, div, img, h1, h2, h3, h4, input, a, header, p, section, iframe)
import Html.Attributes exposing (class, placeholder, type_, value, src, attribute)
import Navigation exposing (Location, newUrl)
import UrlParser exposing ((</>), s, int, string, parsePath)
import Types exposing (..)
import Data
import Http
import Decoder exposing (decodeMovies)
import View.Landing exposing (landing)
import View.Search exposing (search)
import View.Details exposing (details)


init : Location -> ( Model, Cmd Msg )
init path =
    let
        page =
            pathToPage path
    in
        ( initModel page, Cmd.none )


initModel : Page -> Model
initModel page =
    { page = page
    , searchTerm = ""
    , movies = decodeMovies Data.json
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Navigate page ->
            ( model, newUrl <| pageToPath page )

        ChangePage (Details id) ->
            ( { model | page = Details id }, Http.send (RatingFetched id) <| Http.get ("http://www.omdbapi.com/?i=" ++ id) Decoder.ratingDecoder )

        ChangePage page ->
            ( { model | page = page }, Cmd.none )

        SearchTerm txt ->
            ( { model | searchTerm = txt }, Cmd.none )

        RatingFetched id response ->
            ( { model
                | movies =
                    (List.map
                        (\movie ->
                            if movie.id == id then
                                { movie | rating = Just response }
                            else
                                movie
                        )
                        model.movies
                    )
              }
            , Cmd.none
            )


movieById : String -> List Movie -> Maybe Movie
movieById id movies =
    List.filter (\movie -> movie.id == id) movies |> List.head


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ case model.page of
            Landing ->
                landing

            Search ->
                search model

            Details id ->
                details (movieById id model.movies)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


locationToMsg : Location -> Msg
locationToMsg location =
    location
        |> pathToPage
        |> ChangePage


pageToPath : Page -> String
pageToPath page =
    case page of
        Landing ->
            "/"

        Search ->
            "/search"

        Details id ->
            "/details/" ++ id


pathToPage : Location -> Page
pathToPage location =
    let
        parsed =
            parsePath
                (UrlParser.oneOf
                    [ UrlParser.map Search (UrlParser.s "search")
                    , UrlParser.map Details (UrlParser.s "details" </> string)
                    ]
                )
                location
    in
        case parsed of
            Just Search ->
                Search

            Just (Details id) ->
                Details id

            _ ->
                Landing
