module Spirits.View exposing (view)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (style)
import Collage exposing (collage, Form, rect, filled, move, alpha)
import Element exposing (toHtml)
import Color
import List
import Debug

import Spirits.Message exposing (Message(..))
import Spirits.Model exposing (Model)
import Spirits.Entity exposing (Entity)


view : Model -> Html Message
view model =
  div
  [ style
    [ "padding" => "30px"
    , "margin-left" => "auto"
    , "margin-right" => "auto"
    ]
  ]
  [ h1
    [] [text "Spirits" ]
  , renderGameView model
  ]


screenWidth = 640
screenHeight = 320


renderGameView : Model -> Html Message
renderGameView model =
  collage screenWidth screenHeight (renderBackground :: renderEntities model) |> toHtml


renderBackground : Form
renderBackground = alpha 0.1 <| filled Color.lightGreen <| rect screenWidth screenHeight


renderEntities : Model -> List Form
renderEntities {entities} =
  List.map renderEntity <| List.sortBy (\e -> e.position.z) entities


renderEntity : Entity -> Form
renderEntity {position, color, width, height, name} =
  Debug.log (toString position ++ toString color ++ toString name)
  <| move (position.x, position.y) <| filled color <| rect width height


(=>) : a -> b -> (a, b)
(=>) a b = (a, b)


