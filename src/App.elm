module App exposing (..)

import Html exposing (Html, text, div, img, h1, h3, h4, input, a, header, p)
import Html.Attributes exposing (class, placeholder, type_, value, src)
import Html.Events exposing (onSubmit, onInput, onClick)
import Navigation exposing (Location, newUrl)
import UrlParser exposing ((</>), s, int, string, parsePath)


type alias Model =
    { page : Page
    , searchTerm : String
    , movies : List Movie
    }


type alias Movie =
    { title : String
    , year : String
    , description : String
    , poster : String
    , id : String
    , trailer : String
    }


type Page
    = Landing
    | Search
    | Details String


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
    , movies = []
    }


type Msg
    = ChangePage Page
    | Navigate Page
    | SearchTerm String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Navigate page ->
            ( model, newUrl <| pageToPath page )

        ChangePage page ->
            ( { model | page = page }, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ case model.page of
            Landing ->
                landing

            Search ->
                search model

            Details id ->
                details
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


details : Html Msg
details =
    div [] []


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
