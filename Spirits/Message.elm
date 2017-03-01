module Spirits.Message exposing (Msg(..))

import Time exposing (Time)
import Keyboard exposing (KeyCode)
import Mouse exposing (Position)


type Msg
    = Initialize
    | Start
    | Pause
    | Stop
    | Tick Time
    | KeyChange Bool KeyCode
    | Click Position
    | Somthing Position
