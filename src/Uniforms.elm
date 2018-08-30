module Minimal exposing (..)

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
        -- We pass time to aTriangle
        [ aTriangle model.time
        ]



------------------------------------------------------------------------------




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
        -- instead of {}, we specify the Uniforms!
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


vertexShader : WebGL.Shader VertexAttributes Uniforms {}
vertexShader =
    [glsl|
        // since uniform is visible by both shaders GLSL requires us to specify precision
        precision mediump float;

        attribute float x;
        attribute float y;

        uniform vec3 color;
        uniform float time;

        void main () {
            // Scale x with time
            gl_Position.x = x * sin(time / 1000.0);
            gl_Position.y = y;
            gl_Position.z = 0.0;
            gl_Position.w = 1.0;
        }
    |]


pixelShader : WebGL.Shader {} Uniforms {}
pixelShader =
    [glsl|
        precision mediump float;

        uniform vec3 color;
        uniform float time;

        void main () {
          // Instead of assigning each component by itself, I can assign the whole vector
          gl_FragColor = vec4(color, 1.0);
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
