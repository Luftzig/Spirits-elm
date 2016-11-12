module Spirits.Entity exposing (Entity, initPlayer, initNpc, initTree)

import Color exposing (Color, lightBlue, brown, lightBrown, green)


type alias Entity =
  { position : Position
  , color : Color
  , collidable : Bool
  , height : Float
  , width : Float
  , isPlayer : Bool
  , name : String
  }

type alias Position =
  { x : Float
  , y : Float
  , z : Int
  }


backgroundZ = 0
stageZ = 100
canopyZ = 200

initPlayer : Float -> Float -> Entity
initPlayer initX initY =
  { position = {x=initX, y=initY, z=stageZ}
  , color = lightBlue
  , collidable = False
  , height = 20
  , width = 20
  , isPlayer = True
  , name = "Player"
  }

initNpc : Float -> Float -> Entity
initNpc initX initY =
  { position = {x=initX, y=initY, z=stageZ}
  , color = brown
  , collidable = True
  , height = 25
  , width = 25
  , isPlayer = False
  , name = "Npc"
  }

initTree : Float -> Float -> Entity
initTree initX initY =
  { position = {x=initX, y=initY, z=canopyZ}
  , color = green
  , collidable = True
  , height = 25
  , width = 25
  , isPlayer = False
  , name = "Tree"
  }

initBackground : Int -> Int -> Entity
initBackground stageWidth stageHeight =
  { position = {x=0.0, y=0.0, z=backgroundZ}
  , color = lightBrown
  , collidable = False
  , height = toFloat stageHeight
  , width = toFloat stageWidth
  , isPlayer = False
  , name = "background"
  }

