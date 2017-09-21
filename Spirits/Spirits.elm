module Main exposing (..)

import Html
import Task
import AnimationFrame
import Keyboard
import Mouse
import Color
import Game.TwoD.Camera as Camera
import Game.TwoD.Render as Render exposing (Renderable)
import Math.Vector2 exposing (Vec2, vec2)
import Math.Vector3 exposing (Vec3, add, direction, distance, fromTuple, getZ, scale, sub, toTuple, vec3)
import Time exposing (Time)
import Keyboard exposing (KeyCode)
import Math.Vector2 as Vec2
import Mouse
import Time exposing (Time)
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
import Time exposing (Time)
import Keyboard exposing (KeyCode)
import Mouse exposing (Position)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ AnimationFrame.diffs Tick ]


game : Program Never Model Msg
game =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( initial, Task.perform (always Initialize) (Task.succeed 0) )


main : Program Never Model Msg
main =
    game


type alias Keys =
    { up : Bool
    , down : Bool
    , left : Bool
    , right : Bool
    }


type alias View =
    { width : Int
    , height : Int
    }


type alias Goal =
    { which : PlayerPosition
    , isAchieved : Bool
    }


type Scene
    = StartScreen
    | Paused
    | FirstScene
    | Completed Scene


type alias MoveTarget =
    { target : GamePosition
    , since : Time
    }


type alias Model =
    { player : Player
    , time : Time
    , npcs : List NPC
    , world : List Renderable
    , view : View
    , moveTarget : Maybe MoveTarget
    , goals : List Goal
    , scene : Scene
    , camera : Camera.Camera
    }


initial : Model
initial =
    { player = initPlayer
    , time = 0
    , npcs = []
    , world =
        [ Render.rectangleWithOptions
            { color = Color.lightBrown
            , position = ( 0, 0, 0 )
            , size = ( 10, 10 )
            , rotation = 0
            , pivot = ( 0, 0 )
            }
        , Render.rectangleWithOptions
            { color = Color.lightGreen
            , position = ( -10, -10, 0 )
            , size = ( 10, 10 )
            , rotation = 0
            , pivot = ( 0, 0 )
            }
        ]
    , view = { width = 640, height = 480 }
    , moveTarget = Nothing
    , goals = []
    , scene = StartScreen
    , camera = Camera.fixedArea (16 * 10) ( 0, 0 )
    }


type NPC
    = NPC
        { position : GamePosition
        , behavior : NPC -> Model -> GamePosition
        }


type PlayerPosition
    = Floating GamePosition
    | Possessing NPC


type alias Player =
    { position : PlayerPosition
    , moving : Vec2
    , size : Size
    , energy : Int
    }


type alias Float3 =
    ( Float, Float, Float )


type alias GamePosition =
    Vec3


type alias Float2 =
    ( Float, Float )


type alias Size =
    Float2


renderNPC : NPC -> Renderable
renderNPC (NPC npc) =
    let
        rotation =
            0
    in
        Render.rectangleWithOptions
            { color = Color.lightBrown
            , size = ( 1, 1 )
            , position = toTuple npc.position
            , rotation = rotation
            , pivot = ( 0, 0 )
            }


initPlayer =
    { position = Floating (vec3 0 0 0.5)
    , moving = vec2 0 0
    , size = ( 1, 1 )
    , energy = 100
    }


renderPlayer : Player -> Renderable
renderPlayer { size, position, moving } =
    let
        rotation =
            0

        actualPosition =
            case position of
                Floating p ->
                    p

                Possessing (NPC { position }) ->
                    position

        ( w, h ) =
            size
    in
        Render.rectangleWithOptions
            { color = Color.lightBlue
            , position = toTuple <| sub actualPosition <| vec3 (w / 2) (h / 2) 0
            , size = size
            , rotation = rotation
            , pivot = ( w / 2, h / 2 )
            }


type alias ScreenPosition =
    Mouse.Position


type Msg
    = Initialize
    | Start
    | Pause
    | Stop
    | Tick Time
    | KeyChange Bool KeyCode
    | Click ScreenPosition
    | Something GamePosition


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Initialize ->
            ( model, Cmd.none )

        Start ->
            ( model, Cmd.none )

        Pause ->
            ( model, Cmd.none )

        Stop ->
            ( model, Cmd.none )

        Tick delta ->
            ( updateWorld delta model, Cmd.none )

        Click position ->
            let
                ( x, y ) =
                    fromRelativePosition model.camera model.view position |> Vec2.toTuple

                gamePosition =
                    vec3 x y (getPlayerPosition model.player |> getZ)
            in
                ( { model | moveTarget = Just { target = gamePosition, since = model.time } }, Cmd.none )

        otherwise ->
            ( model, Cmd.none )


updateWorld : Time -> Model -> Model
updateWorld timeDelta model =
    let
        playerNewPosition =
            updatePlayerPosition model.player timeDelta model
    in
        { model
            | npcs = moveNPCs model.npcs model
            , player = playerNewPosition
            , time = model.time + timeDelta
            , moveTarget = updateMoveTarget playerNewPosition model.moveTarget
        }


moveNPCs : List NPC -> Model -> List NPC
moveNPCs npcList model =
    let
        updateNpc : Model -> NPC -> NPC
        updateNpc model (NPC npc) =
            NPC { npc | position = npc.behavior (NPC npc) model }
    in
        List.map (updateNpc model) npcList


updateMoveTarget : Player -> Maybe MoveTarget -> Maybe MoveTarget
updateMoveTarget player moveTarget =
    case moveTarget of
        Nothing ->
            Nothing

        Just moveTarget ->
            if distance (getPlayerPosition player) moveTarget.target < 0.01 then
                Nothing
            else
                Just moveTarget


updatePlayerPosition : Player -> Time -> Model -> Player
updatePlayerPosition player timeDelta model =
    let
        playerPosition =
            getPlayerPosition player

        newPosition =
            case model.moveTarget of
                Just { target } ->
                    Floating <|
                        add playerPosition <|
                            movePlayerToward (getPlayerPosition player) target

                Nothing ->
                    player.position

        movePlayerToward : GamePosition -> GamePosition -> GamePosition
        movePlayerToward from to =
            direction to from |> scale (timeDelta / 1000)
    in
        { player | position = newPosition }


getPlayerPosition : Player -> GamePosition
getPlayerPosition player =
    case player.position of
        Floating position ->
            position

        Possessing (NPC { position }) ->
            position


fromRelativePosition : Camera.Camera -> View -> ScreenPosition -> Vec2
fromRelativePosition camera { width, height } { x, y } =
    let
        {- Screen is (Ws, Hs) and starts at (0,0) to (Ws, Hs)
           view size is (Wv, Hv) starting from (-Wv / 2, -Hv / 2) to (Wv / 2, Hv / 2)
           so screen position (Ws, Hs) should be (Wv / 2, Hv / 2)
           so Ws = Wv / 2 -> Wv = 2 Ws
        -}
        ( screenWidth, screenHeight ) =
            ( width, height )

        ( gameWidth, gameHeight ) =
            Camera.getViewSize ( toFloat width, toFloat height ) camera

        ( relativeWidth, relativeHeight ) =
            ( gameWidth / toFloat screenWidth, gameHeight / toFloat screenHeight )
    in
        vec2 (relativeWidth * (toFloat x) - gameWidth / 2) (relativeHeight * (-(toFloat y)) + gameHeight / 2)


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
            , Game.renderCenteredWithOptions
                []
                [ Events.on "click" relativeDecoder
                , style [ "border" => "1px blue solid" ]
                ]
                { time = model.time
                , size = screenSize
                , camera = model.camera
                }
              <|
                render model
            , div [] [ text <| toString model.moveTarget ++ toString model.player.position ]
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

        positionDecoder : Decode.Decoder Mouse.Position
        positionDecoder =
            Decode.map2 Mouse.Position xRelative yRelative
    in
        Decode.map Click positionDecoder


render : Model -> List Renderable
render model =
    model.world
        ++ (List.map renderNPC model.npcs)
        ++ [ renderPlayer model.player ]


(=>) : a -> b -> ( a, b )
(=>) a b =
    ( a, b )
