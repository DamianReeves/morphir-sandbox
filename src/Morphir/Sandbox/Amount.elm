module Morphir.Sandbox.Amount exposing (..)

{-| This module defines the `Amount` type and related functions.
-}


{-| The `Amount` type represents a monetary amount. It is a simple wrapper around an `Int` value.
-}
type Amount
    = Amount Int


amount : Int -> Amount
amount value =
    Amount value
