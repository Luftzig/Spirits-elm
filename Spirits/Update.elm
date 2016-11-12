module Spirits.Update exposing (update)

import Spirits.Model exposing (Model, GameState(..))
import Spirits.Message as Messages


update : Messages.Message -> Model -> (Model, Cmd Messages.Message)
update msg model =
  case msg of
    Messages.Initialize -> (model, Cmd.none)
    Messages.Start -> ({model | state = Playing}, Cmd.none)
    _ -> (model, Cmd.none)
