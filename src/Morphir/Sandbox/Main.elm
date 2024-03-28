port module Morphir.Sandbox.Main exposing (..)


init : flags -> ( Int, Cmd msg )
init _ =
    ( 0, Cmd.none )


type Msg
    = Increment
    | Decrement
    | Set Int


update : Msg -> Int -> ( Int, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model, increment model )

        Decrement ->
            ( model, decrement model )

        Set value ->
            ( value, Cmd.none )


subscriptions : model -> Sub Msg
subscriptions _ =
    Sub.none


port increment : Int -> Cmd msg


port decrement : Int -> Cmd msg


port receiveCount : (Int -> msg) -> Sub msg


main : Program () Int Msg
main =
    Platform.worker { init = init, update = update, subscriptions = subscriptions }
