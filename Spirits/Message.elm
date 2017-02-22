module Spirits.Message exposing (Message(..))

import Time exposing (Time)
import Keyboard exposing (KeyCode)
import Mouse exposing (Position)


type Message
    = Initialize
    | Start
    | Pause
    | Stop
    | Tick Time
    | KeyChange Bool KeyCode
    | Click Position
