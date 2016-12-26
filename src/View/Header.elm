module View.Header exposing (elmvideo)

import Types exposing (..)
import Html exposing (..)
import Html.Events exposing (..)


elmvideo : Html Msg
elmvideo =
    h1 [ onClick (Navigate Landing) ] [ text "elmvideo" ]
