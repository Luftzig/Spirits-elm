module Spirits.View exposing (view)

import Game.TwoD.Render exposing (Renderable)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (style)
import Html.Events as Events
import Element exposing (toHtml)
import Color
import Json.Decode as Decode
import List
import Debug
import Spirits.Message exposing (Message(..))
import Spirits.Model exposing (Model)

import Game.TwoD as Game
import Spirits.Entities.NPC exposing (renderNPC)
import Spirits.Entities.Player exposing (renderPlayer)


view : Model -> Html Message
view model =
  let
    screenSize = (model.view.width, model.view.height)
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
            [Events.on "click" relativeDecoder ]
            { time = model.time
            , size = screenSize
            , camera = model.camera
            }
            |> render model
        ]


relativeDecoder : Decode.Decoder Click
relativeDecoder = Click |>
  (Decode.map2 (-)
    |> Decode.at ["pageX"] Decode.int
    |> Decode.at ["target", "offsetLeft"] Decode.int
  , Decode.map2 (-)
    |> Decode.at ["pageY"] Decode.int
    |> Decode.at ["target", "offsetTop"] Decode.int
  )


render : Model -> List Renderable
render model =
  model.world ++
  (List.map renderNPC model.npcs) ++
  (renderPlayer model.player)


(=>) : a -> b -> ( a, b )
(=>) a b =
    ( a, b )
