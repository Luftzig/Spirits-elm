module Spirits.Model exposing (Model
                              , Scene(..)
                              , initial
                              )

import Game.TwoD.Camera as Camera
import Game.TwoD.Render as Render exposing(Renderable)

import Spirits.Entities.Helpers exposing (Position, PositionOrNPC)
import Spirits.Entities.NPC exposing (NPC)
import Spirits.Entities.Player exposing (Player, initPlayer)
import Time exposing (Time)


type alias Keys =
    { up: Bool
    , down : Bool
    , left : Bool
    , right : Bool
    }


type alias View =
    { width : Int
    , height : Int
    }

type alias Goal =
  { which: PositionOrNPC
  , isAchieved: Bool
  }

type Scene = StartScreen
           | Paused
           | FirstScene
           | Completed Scene

type alias Model =
    { player: Player
    , time: Time
    , npcs: List NPC
    , world: List Renderable
    , view: View
    , moveTarget: Position
    , goals: List Goal
    , scene: Scene
    , camera: Camera.Camera
    }


initial : Model
initial =
  { player = initPlayer
  , time = 0
  , npcs = []
  , world = []
  , view = (640, 480)
  , moveTarget = (0, 0)
  , goals = []
  , scene = StartScreen
  , camera = Camera.fixedArea (16 * 10) (0, 0)
  }
