
0.
  * Graphics Processing Units are basically arrays of hundreds of processors that work in parallel
  * WebGL is a standard that allows use these processors
  * In fact, we can even program them directly


1. Minimal.elm

  * Canvas width & height

  * Defining a WebGL Entity

  * Mesh and mesh attributes
    - Do not modify meshes!
    - coordinates go from -1 to 1, regardless of aspect ratio

  * Shaders
    - Special Elm syntax!!!
    - They are pure functions
    - They are passed to the GPU and executed there

  * Vertex Shader
    - Transforms the Mesh Attributes into a Vertex
    - Example usage: scale triangle down

  * Pixel Shader
    - Called 'Fragment' Shader
    - Decides the color of a pixel
    - Pure function with no arguments!?


2. Uniforms

  * I modified the model, so that we get the current time in milliseconds

  * They are called Uniforms because they don't change with vertex or pixel position

  * They are accessible by both Vertex and Pixel shader


3. Varyings


