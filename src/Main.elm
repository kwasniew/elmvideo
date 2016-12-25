module Main exposing (..)

import App exposing (..)
import Navigation exposing (..)
import Types exposing (..)


main : Program Never Model Msg
main =
    Navigation.program locationToMsg
        { view = view, init = init, update = update, subscriptions = subscriptions }
