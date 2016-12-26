module App exposing (..)

import Html exposing (Html, text, div, img, h1, h2, h3, h4, input, a, header, p, section, iframe)
import Html.Attributes exposing (class, placeholder, type_, value, src, attribute)
import Html.Events exposing (onSubmit, onInput, onClick)
import Navigation exposing (Location, newUrl)
import UrlParser exposing ((</>), s, int, string, parsePath)
import Types exposing (..)
import Data
import Http
import Decoder exposing (decodeMovies)


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


type Msg
    = ChangePage Page
    | Navigate Page
    | SearchTerm String
    | RatingFetched String (Result Http.Error String)


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


elmvideo : Html Msg
elmvideo =
    h1 [ onClick (Navigate Landing) ] [ text "elmvideo" ]


landing : Html Msg
landing =
    div [ class "landing" ]
        [ elmvideo
        , Html.form
            [ onSubmit (Navigate Search)
            ]
            [ input [ type_ "text", placeholder "Search", onInput SearchTerm ] []
            ]
        , a [ onClick (Navigate Search) ] [ text "Browse All" ]
        ]


showCard : Movie -> Html Msg
showCard movie =
    div [ class "show-card", onClick (Navigate (Details movie.id)) ]
        [ img [ src ("/public/img/posters/" ++ movie.poster) ] []
        , div []
            [ h3 [] [ text movie.title ]
            , h4 [] [ text movie.year ]
            , p [] [ text movie.description ]
            ]
        ]


movieMatching : String -> Movie -> Bool
movieMatching searchTerm movie =
    String.contains (String.toUpper searchTerm) (String.toUpper (movie.title ++ " " ++ movie.description))


search : Model -> Html Msg
search model =
    div [ class "search" ]
        [ header []
            [ elmvideo
            , input [ type_ "text", placeholder "Search", onInput SearchTerm, value model.searchTerm ] []
            ]
        , div [] (model.movies |> List.filter (movieMatching model.searchTerm) |> List.map showCard)
        ]


details : Maybe Movie -> Html Msg
details movie =
    case movie of
        Just movie ->
            div [ class "details" ]
                [ header []
                    [ header []
                        [ elmvideo
                        , h2 [ onClick (Navigate Search) ] [ text "Back" ]
                        ]
                    ]
                , section []
                    [ h1 [] [ text movie.title ]
                    , h2 [] [ text movie.year ]
                    , ratingView movie.rating
                    , img [ src ("/public/img/posters/" ++ movie.poster) ] []
                    , p [] [ text movie.description ]
                    ]
                , div []
                    [ iframe
                        [ src ("https://www.youtube-nocookie.com/embed/" ++ movie.trailer ++ "?rel=0&amp;controls=0&amp;showinfo=0")
                        , attribute "frameBorder" "0"
                        , attribute "allowFullScreen" ""
                        ]
                        []
                    ]
                ]

        Nothing ->
            div [] []


ratingView : Maybe (Result Http.Error String) -> Html Msg
ratingView rating =
    case rating of
        Just rating ->
            case rating of
                Ok value ->
                    h3 [] [ text value ]

                Err error ->
                    div [] [ text (toString error) ]

        Nothing ->
            img [ src "/public/img/loading.png" ] []


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
