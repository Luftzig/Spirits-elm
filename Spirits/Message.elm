module Spirits.Message exposing (Message(..))

import Time exposing (Time)


type Message = Initialize
             | Start
             | Pause
             | Stop
             | Tick Time
