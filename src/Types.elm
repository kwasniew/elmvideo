module Types exposing (..)

import Http


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
    , rating : Maybe (Result Http.Error String)
    }


type Page
    = Landing
    | Search
    | Details String
