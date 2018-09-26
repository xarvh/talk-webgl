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
    , varyingAmplitude : Float
    }


type alias Uniforms =
    { time : Float
    }


aTriangle : Float -> WebGL.Entity
aTriangle time =
    WebGL.entity
        vertexShader
        pixelShader
        mesh
        { time = time
        }


type alias VertexAttributes =
    { x : Float
    , y : Float

    -- We add new attributes!
    , vertexColor : Vec3
    , vertexPhase : Float
    }


mesh : WebGL.Mesh VertexAttributes
mesh =
    WebGL.triangles
        [ ( { x = -1, y = -1, vertexColor = vec3 1 0 0, vertexPhase = 0.4 }
          , { x = 1, y = -1, vertexColor = vec3 0 1 0, vertexPhase = 0.6 }
          , { x = -1, y = 1, vertexColor = vec3 0 0 1, vertexPhase = 0.7 }
          )
        ]


vertexShader : WebGL.Shader VertexAttributes Uniforms Varyings
vertexShader =
    [glsl|
        precision mediump float;

        attribute float x;
        attribute float y;
        attribute vec3 vertexColor;
        attribute float vertexPhase;

        uniform float time;

        varying vec3 varyingColor;
        varying float varyingAmplitude;

        void main () {
            varyingColor = vertexColor;
            varyingAmplitude = 0.5 + 0.5 * sin(time / 1000.0 + vertexPhase);
            gl_Position.x = x * varyingAmplitude;
            gl_Position.y = y * (1.0 - varyingAmplitude);
            gl_Position.z = 0.0;
            gl_Position.w = 1.0;
        }
    |]


pixelShader : WebGL.Shader {} Uniforms Varyings
pixelShader =
    [glsl|
        precision mediump float;

        uniform float time;

        varying vec3 varyingColor;
        varying float varyingAmplitude;

        void main () {
          gl_FragColor = vec4(varyingColor * (0.5 + varyingAmplitude), 1.0);
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
