module Spirits.View exposing (view)

import Color
import Element exposing (toHtml)
import Game.TwoD as Game
import Game.TwoD.Render exposing (Renderable)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (style)
import Html.Events as Events
import Json.Decode as Decode
import List
import Mouse exposing (Position)
import Spirits.Entities.NPC exposing (renderNPC)
import Spirits.Entities.Player exposing (renderPlayer)
import Spirits.Message exposing (Msg(Click))
import Spirits.Model exposing (Model)


view : Model -> Html Msg
view model =
    let
        screenSize =
            ( model.view.width, model.view.height )
    in
        div
            [ style
                [ "padding" => "30px"
                , "margin-left" => "auto"
                , "margin-right" => "auto"
                ]
            ]
            [ h1
                []
                [ text "Spirits" ]
            , Game.renderWithOptions
                [ Events.on "click" relativeDecoder ]
                { time = model.time
                , size = screenSize
                , camera = model.camera
                }
              <|
                render model
            ]


relativeDecoder : Decode.Decoder Msg
relativeDecoder =
    let
        relative : String -> String -> Decode.Decoder Int
        relative pageProp targetProp =
            Decode.map2 (-)
                (Decode.at [ pageProp ] Decode.int)
                (Decode.at [ "target", targetProp ] Decode.int)

        xRelative =
            relative "pageX" "offsetLeft"

        yRelative =
            relative "pageY" "offsetTop"
    in
        Decode.map Click <| Decode.map2 Mouse.Position xRelative yRelative


render : Model -> List Renderable
render model =
    model.world
        ++ (List.map renderNPC model.npcs)
        ++ [ renderPlayer model.player ]


(=>) : a -> b -> ( a, b )
(=>) a b =
    ( a, b )
