module View.Landing exposing (landing)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import View.Header exposing (..)


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
