module Spirits.Entities.Player
    exposing
        ( initPlayer
        , renderPlayer
        )

import Spirits.Entities.EntitiesDefs exposing (Player, PlayerPosition(..), NPC(..))
import Color
import Math.Vector2 as V2 exposing (Vec2)
import Game.TwoD.Render as Render exposing (Renderable)
import Spirits.Entities.Helpers exposing (Position, Size)


initPlayer =
    { position = Floating ( 0, 0, 0 )
    , moving = V2.vec2 0 0
    , size = ( 16, 16 )
    , energy = 100
    }


renderPlayer : Player -> Renderable
renderPlayer { position, moving } =
    let
        rotation =
            0

        actualPosition =
            case position of
                Floating p ->
                    p

                Possessing (NPC { position }) ->
                    position
    in
        Render.rectangleWithOptions
            { color = Color.lightBlue
            , position = actualPosition
            , size = ( 1, 1 )
            , rotation = rotation
            , pivot = ( 0, 0 )
            }
