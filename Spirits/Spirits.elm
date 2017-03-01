module Main exposing (..)

import Html
import Task
import AnimationFrame
import Keyboard
import Mouse
import Spirits.Model exposing (Model, initial)
import Spirits.Message exposing (Msg(..))
import Spirits.View as View
import Spirits.Update as Update


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ AnimationFrame.diffs Tick ]


game : Program Never Model Msg
game =
    Html.program
        { init = init
        , view = View.view
        , update = Update.update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( initial, Task.perform (always Initialize) (Task.succeed 0) )


main : Program Never Model Msg
main =
    game
