module Spirits.Entities.EntitiesDefs exposing (..)

import Game.TwoD.Render as Render exposing (Renderable)
import Spirits.Entities.Helpers as Helpers exposing (..)
import Math.Vector2 as V2 exposing (Vec2)
import Time exposing (Time)

type NPCEnvironment =
  NPCEnvironment
    { world: List Renderable
    , npcs: List NPC
    , player: Player
    , time: Time
    }

type NPC =
  NPC
    { position: Position
    , behavior: (NPC -> NPCEnvironment -> Helpers.Float2)
    }

type PlayerPosition = Floating Position
                    | Possessing NPC

type alias Player =
  { position: PlayerPosition
  , moving: Vec2
  , size: Size
  , energy: Int}
