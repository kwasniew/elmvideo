module View.Search exposing (search)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import View.Header exposing (..)


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
