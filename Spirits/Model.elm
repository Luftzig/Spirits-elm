module Spirits.Model exposing (Model, GameState(..), initial)

import Spirits.Entity exposing (Entity, initPlayer, initNpc, initTree)

type alias Model =
  { state : GameState
  , entities : List Entity
  }

type GameState = Stopped | Playing | Paused


initial : Model
initial =
  { state = Stopped
  , entities =
    [ initPlayer 10 20
    , initNpc -50 100
    , initTree 0 -60
    ]
  }