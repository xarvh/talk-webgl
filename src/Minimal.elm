module Minimal exposing (..)

import Browser
import Html exposing (Html)
import Html.Attributes exposing (style)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import WebGL


type alias Model =
    {}


view : Model -> Html String
view model =
    WebGL.toHtmlWith
        []
        [ style "border" "1px blue solid" ]
        [ aTriangle ]


aTriangle : WebGL.Entity
aTriangle =
    WebGL.entity
        vertexShader
        pixelShader
        mesh
        {}


type alias MeshAttributes =
    -- TODO: transform to { x : Float, y : Float }
    { position : Vec2 }


mesh : WebGL.Mesh MeshAttributes
mesh =
    WebGL.triangles
        [ ( { position = vec2 -1 -1 }
          , { position = vec2 1 -1 }
          , { position = vec2 1 1 }
          )
        ]


vertexShader : WebGL.Shader MeshAttributes {} {}
vertexShader =
    [glsl|
        attribute vec2 position;

        void main () {
            gl_Position.x = position.x;
            gl_Position.y = position.y;
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


main =
    Browser.sandbox
        { init = {}
        , update = \msg model -> model
        , view = view
        }
