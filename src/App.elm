module App exposing (..)

import Html exposing (Html, text, div, img)
import Navigation exposing (Location)
import UrlParser exposing ((</>), s, int, string, parsePath)


type alias Model =
    { page : Page
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
    }


type Msg
    = NoOp
    | ChangePage Page


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ text (toString model.page)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


locationToMsg : Location -> Msg
locationToMsg location =
    location
        |> pathToPage
        |> ChangePage


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
