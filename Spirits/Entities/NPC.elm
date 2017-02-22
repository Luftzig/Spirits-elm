module Spirits.Entities.NPC exposing ( NPC
                                     , renderNPC
                                     )

import Color

import Game.TwoD.Render as Render exposing (Renderable)
import Spirits.Entities.Helpers as Helpers exposing (Position)
import Time exposing (Time)

type alias NPCEnvironment o =
  { o | player: {position: Position}
  , world: List Renderable
  , npcs: List NPC
  , time: Time
  }

type NPC =
  NPC
    { position: Position
    , behavior: (NPC -> NPCEnvironment a -> Helpers.Float2)
    }


renderNPC : NPC -> Renderable
renderNPC npc =
  let
    rotation = 0
  in
    Render.rectangleWithOptions
      { color = Color.lightBrown
      , size = (1, 1)
      , position = npc.position
      , rotation = rotation
      , pivot = (0, 0)
      }

