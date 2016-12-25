module App exposing (..)

import Html exposing (Html, text, div, img, h1, input, a)
import Html.Attributes exposing (class, placeholder, type_)
import Html.Events exposing (onSubmit, onInput, onClick)
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
    | Navigate Page
    | SearchTerm String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ landing ]


landing : Html Msg
landing =
    div [ class "landing" ]
        [ h1 [] [ text "elmvideo" ]
        , Html.form
            [ onSubmit (Navigate Search)
            ]
            [ input [ type_ "text", placeholder "Search", onInput SearchTerm ] []
            ]
        , a [ onClick (Navigate Search) ] [ text "Browse All" ]
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
