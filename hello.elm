module Hello exposing (main)

import Html exposing (Html, Attribute, div, input, text, h2, span)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String
import Svg exposing (circle, svg)
import Svg.Attributes exposing (..)
import Time exposing (Time, inSeconds, millisecond)
import Keyboard exposing (presses, KeyCode)
import Platform.Sub exposing (batch)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { position : Position
    , speed : Position
    }


type alias Position =
    ( Int, Int )


type Msg
    = Up
    | Down
    | Left
    | Right
    | NoMove
    | Tick Time


toMsg : KeyCode -> Msg
toMsg code =
    case code of
        37 ->
            Left

        38 ->
            Up

        39 ->
            Right

        40 ->
            Down

        _ ->
            NoMove


init : ( Model, Cmd Msg )
init =
    ( { position = ( 50, 50 ), speed = ( 0, 0 ) }, Cmd.none )


xPosition : Model -> String
xPosition model =
    toString <| Tuple.first model.position


yPosition : Model -> String
yPosition model =
    toString <| Tuple.second model.position


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Got key" ]
        , svg [ viewBox "0 0 300 300", Svg.Attributes.width "300px" ]
            [ circle [ cx <| xPosition model, cy <| yPosition model, r "10", fill "#045555" ] []
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( nextPosition msg model, Cmd.none )


nextPosition : Msg -> Model -> Model
nextPosition msg model =
    let
        accel =
            8

        deaccel =
            1.2
    in
        case msg of
            Right ->
                { model | speed = ( Tuple.first model.speed + accel, Tuple.second model.speed ) }

            Left ->
                { model | speed = ( Tuple.first model.speed - accel, Tuple.second model.speed ) }

            Down ->
                { model | speed = ( Tuple.first model.speed, Tuple.second model.speed + accel ) }

            Up ->
                { model | speed = ( Tuple.first model.speed, Tuple.second model.speed - accel ) }

            NoMove ->
                model

            Tick _ ->
                { model
                    | position = ( Tuple.first model.position + Tuple.first model.speed, Tuple.second model.position + Tuple.second model.speed )
                    , speed =
                        ( truncate <| (toFloat <| Tuple.first model.speed) / deaccel
                        , truncate <| (toFloat <| Tuple.second model.speed) / deaccel
                        )
                }


subscriptions : Model -> Sub Msg
subscriptions model =
    batch [ presses toMsg, Time.every (inSeconds 25) Tick ]
