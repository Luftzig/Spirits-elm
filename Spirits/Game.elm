import Html.App as Html
import Task
import AnimationFrame
import Keyboard

import Spirits.Model exposing (Model, initial, GameState(..))
import Spirits.Message exposing (Message(..))
import Spirits.View as View
import Spirits.Update as Update


subscriptions : Model -> Sub Message
subscriptions model =
  Sub.batch
   [ if model.state == Playing then
      AnimationFrame.diffs Tick
     else
      Sub.none
   , Sub.none  -- Keyboard listening events should be here
   ]

game : Program Never
game =
  Html.program
  { init = init
  , view = View.view
  , update = Update.update
  , subscriptions = subscriptions
  }


init : (Model, Cmd Message)
init = (initial, Task.perform (always Initialize) (always Initialize) (Task.succeed 0))


main : Program Never
main = game
