module View.Details exposing (details)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import View.Header exposing (..)
import Http


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
