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
    { amplitude : Float
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
    }


mesh : WebGL.Mesh VertexAttributes
mesh =
    WebGL.triangles
        [ ( { x = -1
            , y = -1
            }
          , { x = 1
            , y = -1
            }
          , { x = -1
            , y = 1
            }
          )
        ]


vertexShader : WebGL.Shader VertexAttributes Uniforms Varyings
vertexShader =
    [glsl|
        precision mediump float;

        attribute float x;
        attribute float y;

        uniform vec3 color;
        uniform float time;

        // Varying!
        varying float amplitude;

        void main () {
            amplitude = sin(time / 1000.0);
            gl_Position.x = x * amplitude;
            gl_Position.y = y;
            gl_Position.z = 0.0;
            gl_Position.w = 2.0;
        }
    |]


pixelShader : WebGL.Shader {} Uniforms Varyings
pixelShader =
    [glsl|
        precision mediump float;

        uniform vec3 color;
        uniform float time;

        // We receive the amplitude from the vertex shader
        varying float amplitude;

        void main () {
          // We can use amplitude like any other variable
          gl_FragColor = vec4(color * amplitude, 1.0);
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
