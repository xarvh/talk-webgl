module Varyings exposing (..)

import Browser
import Browser.Events
import Html exposing (Html)
import Html.Attributes exposing (height, style, width)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import WebGL


view : Model -> Html a
view model =
    WebGL.toHtml
        [ style "border" "1px blue solid"
        , width 600
        , height 600
        ]
        [ aTriangle model.time
        ]



------------------------------------------------------------------------------


{-| Now we have Varyings!
-}
type alias Varyings =
    { varyingColor : Vec3
    }


type alias Uniforms =
    { color : Vec3
    , time : Float
    }


aTriangle : Float -> WebGL.Entity
aTriangle time =
    WebGL.entity
        vertexShader
        pixelShader
        mesh
        { color = vec3 0 1 0
        , time = time
        }


type alias VertexAttributes =
    { x : Float
    , y : Float

    -- We add a new attribute!
    , vertexColor : Vec3
    }


mesh : WebGL.Mesh VertexAttributes
mesh =
    WebGL.triangles
        [ ( { x = -1, y = -1, vertexColor = vec3 1 0 0 }
          , { x = 1, y = -1, vertexColor = vec3 0 1 0 }
          , { x = -1, y = 1, vertexColor = vec3 0 0 1 }
          )
        ]


vertexShader : WebGL.Shader VertexAttributes Uniforms Varyings
vertexShader =
    [glsl|
        precision mediump float;

        attribute float x;
        attribute float y;
        attribute vec3 vertexColor;

        uniform vec3 color;
        uniform float time;

        varying vec3 varyingColor;

        void main () {
            varyingColor = vertexColor;
            gl_Position.x = x;
            gl_Position.y = y;
            gl_Position.z = 0.0;
            gl_Position.w = 1.0;
        }
    |]


pixelShader : WebGL.Shader {} Uniforms Varyings
pixelShader =
    [glsl|
        precision mediump float;

        uniform vec3 color;
        uniform float time;

        varying vec3 varyingColor;

        void main () {
          gl_FragColor = vec4(varyingColor, 1.0);
        }

    |]



--


type alias Model =
    { time : Float
    }


noCmd : a -> ( a, Cmd b )
noCmd model =
    ( model, Cmd.none )


init : Model
init =
    { time = 0
    }


update : Float -> Model -> Model
update dt model =
    { model | time = model.time + dt }


main : Program {} Model Float
main =
    Browser.document
        { init = \flags -> noCmd init
        , update = \msg model -> noCmd (update msg model)
        , view = \model -> { title = "WebGL", body = [ view model ] }
        , subscriptions = \model -> Browser.Events.onAnimationFrameDelta identity
        }
