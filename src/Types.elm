module Types exposing (..)


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
