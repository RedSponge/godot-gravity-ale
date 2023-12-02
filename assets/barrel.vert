#version 100

#ifdef GL_ES
    precision mediump float;
#endif

#define _in attribute
#define _out varying

_in vec4 a_position;
_in vec2 a_texCoord0;
_in vec4 a_color;

_out vec2 v_texCoords;
_out vec4 v_color;

uniform mat4 u_projTrans;

void main()
{
    gl_Position = u_projTrans * a_position;
    v_texCoords = a_texCoord0;
    v_color = a_color;
}