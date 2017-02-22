module Spirits.Entities.Player exposing ( Player
                                        , initPlayer
                                        , renderPlayer
                                        )

import Color
import Math.Vector2 as V2 exposing (Vec2)
import Game.TwoD.Render as Render exposing (Renderable)

import Spirits.Entities.Helpers exposing (Position, Size)
import Spirits.Entities.NPC exposing (NPC)

type PositionOrNPC = Floating Position
                    | Possessing NPC

type alias Player =
  { position: PositionOrNPC
  , moving: Vec2
  , size: Size
  , energy: Int}


initPlayer =
  { position = (0, 0, 0)
  , moving = V2.vec2 0 0
  , size = (16, 16)
  , energy = 100
  }

renderPlayer : Player -> Renderable
renderPlayer {position, moving} =
  let
    rotation = 0
  in
    Render.rectangleWithOptions
      { color = Color.lightBlue
      , position = position
      , size = (1, 1)
      , rotation = rotation
      , pivot = (0, 0)
      }
