#version 100

#ifdef GL_ES
    precision mediump float;
#endif

#define _in varying

uniform sampler2D u_texture;
uniform float u_barrelPower;
uniform float u_greyscalePercent;
uniform float u_fadePercent;

_in vec4 v_color;
_in vec2 v_texCoords;

vec2 distort(vec2 pos) {
    float theta = atan(pos.y, pos.x);
    float radius = length(pos);
    radius = pow(radius, 1.0 + u_barrelPower);

    pos.x = radius * cos(theta);
    pos.y = radius * sin(theta);

    return 0.5 * (pos + 1.0);
}

vec4 greyscale(vec4 col) {
    float f = col.r * 0.21 + col.g * 0.71 + col.b * 0.07;
    return vec4(vec3(f), 1.0);
}

vec4 getColorsSeperated(vec2 pos) {
    float red = texture2D(u_texture, pos + vec2(u_barrelPower * 0.02, 0)).r;
    float green = texture2D(u_texture, pos + vec2(0, u_barrelPower * 0.02)).g;
    vec2 blueAlpha = texture2D(u_texture, pos).ba;

    return vec4(red, green, blueAlpha);
}

void main() {
    vec2 newTexCoords = v_texCoords * 2.0 - 1.0;

    vec2 distorted = distort(newTexCoords);

    vec4 seperated = getColorsSeperated(distorted);
    vec4 withColor = seperated * v_color;
    vec4 greyscaled = greyscale(withColor);

    vec4 mixed = withColor * (1.0 - u_greyscalePercent) + greyscaled * u_greyscalePercent;

    gl_FragColor = vec4((mixed * (1.0 - u_fadePercent)).rgb, 1);
}