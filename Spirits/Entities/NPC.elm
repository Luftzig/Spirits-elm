module Spirits.Entities.NPC exposing (renderNPC)

import Spirits.Entities.EntitiesDefs exposing (NPC(..))
import Color
import Game.TwoD.Render as Render exposing (Renderable)
import Spirits.Entities.Helpers as Helpers exposing (Position)
import Time exposing (Time)


renderNPC : NPC -> Renderable
renderNPC (NPC npc) =
    let
        rotation =
            0
    in
        Render.rectangleWithOptions
            { color = Color.lightBrown
            , size = ( 1, 1 )
            , position = npc.position
            , rotation = rotation
            , pivot = ( 0, 0 )
            }
