module Minimal exposing (..)

import Browser
import Html exposing (Html)
import Html.Attributes exposing (height, style, width)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import WebGL


view : Model -> Html a
view model =
    -- create a WebGL <canvas>
    WebGL.toHtml
        [ style "border" "1px blue solid"

        -- this is the number of pixels
        , width 50
        , height 50

        -- this is the DOM element size
        , style "width" "600px"
        , style "height" "300px"
        ]
        [ aTriangle
        ]


aTriangle : WebGL.Entity
aTriangle =
    WebGL.entity
        vertexShader
        pixelShader
        mesh
        {}


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


{-| Transforms the Mesh Attributes into a vertex position
-}
vertexShader : WebGL.Shader VertexAttributes {} {}
vertexShader =
    [glsl|
        attribute float x;
        attribute float y;

        void main () {
            gl_Position.x = x;
            gl_Position.y = y;
            gl_Position.z = 0.0;
            gl_Position.w = 1.0;
        }
    |]


pixelShader : WebGL.Shader {} {} {}
pixelShader =
    [glsl|
        void main () {
          gl_FragColor.r = 1.0;
          gl_FragColor.g = 0.0;
          gl_FragColor.b = 0.0;
          gl_FragColor.a = 1.0;
        }
    |]



--


type alias Model =
    {}


main =
    Browser.sandbox
        { init = {}
        , update = \msg model -> model
        , view = view
        }
