module Spirits.Update exposing (update)

import Keyboard exposing (KeyCode)
import Time exposing (Time)
import Spirits.Model exposing (Model)
import Spirits.Message as Messages


update : Messages.Msg -> Model -> ( Model, Cmd Messages.Msg )
update msg model =
    case msg of
        Messages.Initialize ->
            ( model, Cmd.none )

        Messages.Start ->
            ( model, Cmd.none)

        Messages.Pause ->
            ( model, Cmd.none)

        Messages.Stop ->
            ( model, Cmd.none)

        Messages.Tick time ->
            ( model, Cmd.none)

        Messages.Click position ->
            ( model, Cmd.none)

        otherwise ->
            ( model, Cmd.none)
