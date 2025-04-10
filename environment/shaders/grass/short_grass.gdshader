shader_type canvas_item;

// --- Includes --- //
#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
global uniform float wind_position;
global uniform vec2 screen_size;

uniform sampler2D wind_noise: filter_nearest, repeat_enable;
uniform float wind_speed: hint_range(-1.0, 1.0, 0.05) = -0.50;

uniform vec4 normal_color: source_color;
uniform vec4 patch_color: source_color;

// --- Functions --- //
float get_wind(vec2 _uv) {
	return step(0.5, texture(wind_noise, _uv).g);
}

void fragment() {
	vec2 uv = pixelize(UV, screen_size);
	
	uv.y -= get_wind(vec2(0.0, uv.y + wind_position * wind_speed * 0.05)) * TEXTURE_PIXEL_SIZE.y;
	
	float grass_val = texture(TEXTURE, uv).g * 255.0;
	
	COLOR.rgb = mix(normal_color, patch_color, grass_val).rgb;
}