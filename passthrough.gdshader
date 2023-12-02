shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float u_greyscale_percent = 0.0;
uniform float u_barrel_power = 0.0;
uniform float u_scatter_percent = 0.0;

vec4 compute_greyscale(vec4 color) {
	float avg = (color.r + color.g + color.b) / 3.0;
	return vec4(vec3(avg), color.a)	;
}

vec2 distort(vec2 position, float power) {
	// Vec2 where (0,0) is the center of the screen.
	vec2 centered_position = position * 2.0 - 1.0;
	
	float theta = atan(centered_position.y, centered_position.x);
	float radius = length(centered_position);
	radius = pow(radius, 1.0 + power);
	
	vec2 rounded_position = vec2(cos(theta) * radius, sin(theta) * radius);
	
	vec2 recornered_position = (rounded_position + 1.0) / 2.0;
	return recornered_position;
}

vec4 compute_scatter(vec2 position, float power) {
	float red = texture(SCREEN_TEXTURE, position - vec2(power * 0.02)).r;
	float green = texture(SCREEN_TEXTURE, position + vec2(power * 0.02)).g;
	vec2 blue_alpha = texture(SCREEN_TEXTURE, position).ba;
	
	return vec4(red, green, blue_alpha);
}

void fragment() {
	vec2 distorted = distort(SCREEN_UV, u_barrel_power);
	
	vec4 scattered = compute_scatter(distorted, u_scatter_percent);
	vec4 greyscale = compute_greyscale(scattered);	

	vec4 mixed = mix(scattered, greyscale, u_greyscale_percent);
	
	// Fix alpha from sampling edges
	mixed.a = 1.0;
	
	COLOR = mixed;
}
