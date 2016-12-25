module Decoder exposing (..)

import Json.Decode exposing (string, int, list, Decoder, decodeString)
import Json.Decode.Pipeline exposing (required, decode)
import Types exposing (..)


ratingDecoder : Decoder String
ratingDecoder =
    decode identity
        |> required "imdbRating" string


movieDecoder : Decoder Movie
movieDecoder =
    decode Movie
        |> required "title" string
        |> required "year" string
        |> required "description" string
        |> required "poster" string
        |> required "imdbID" string
        |> required "trailer" string


moviesDecoder : Decoder (List Movie)
moviesDecoder =
    decode identity
        |> required "shows" (list movieDecoder)


decodeMovies : String -> List Movie
decodeMovies json =
    case decodeString moviesDecoder json of
        Ok searchResults ->
            searchResults

        Err err ->
            let
                err1 =
                    Debug.log "error" err
            in
                []
