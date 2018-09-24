
0.
  * Graphics Processing Units are basically arrays of hundreds of processors that work in parallel
  * WebGL is a standard that allows to use these processors
  * In fact, we can even write programs that are executed on them


1. Minimal.elm

  * Do not confuse width and height with CSS properties!

  * Defining a WebGL Entity

  * Mesh and mesh attributes
    - Mesh defines vertices and surfaces
    - coordinates go from -1 to 1, regardless of aspect ratio
    - -1,+1 interval is stretched over the canvas

  * Shaders
    - Special Elm syntax!!!
    - They are pure functions
    - They are passed to the GPU and executed there

  * Vertex Shader
    - Transforms the Mesh Attributes into a Vertex
    - Example usage: scale coordinates to keep aspect ratio regardless of canvas size
    - Example usage: rotate, scale and position an object in space

  * Pixel Shader
    - Called 'Fragment' Shader
    - Decides the color of a pixel
    - Pure function with no arguments!?


2. Uniforms

  * I modified the model, so that we get the current time in milliseconds

  * They are called Uniforms because they don't change with vertex or pixel position

  * They are accessible by both Vertex and Pixel shader


3. Varyings

  * How do we pass stuff from the vertex shader to the pixel shader?

  * Varyings are *interpolated*



-------------------




