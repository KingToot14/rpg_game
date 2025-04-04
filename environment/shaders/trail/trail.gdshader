shader_type canvas_item;

// --- Includes --- //
#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
global uniform float wind_position;

uniform vec2 texture_size = vec2(480, 270);

group_uniforms color;
uniform vec4 trail_color: source_color;
uniform vec4 shadow_color: source_color;
uniform vec4 grass_color: source_color;

group_uniforms wind;
uniform sampler2D wind_noise: filter_nearest, repeat_enable;
uniform float wind_speed: hint_range(-1.0, 1.0, 0.05) = -0.50;

// --- Functiosn --- //
float get_noise(vec2 _uv) {
	return step(0.5, texture(wind_noise, _uv).r);
}

void fragment() {
	COLOR.a = step(0.01, COLOR.r);
	
	vec2 uv = pixelize(UV, texture_size);
	
	// Base Color
	COLOR.rgb = trail_color.rgb;
	
	float shadow_val = 1.0 - step(0.01, texture(TEXTURE, uv - vec2(0.0, 2.0) * TEXTURE_PIXEL_SIZE).r);
	
	COLOR.rgb = mix(COLOR.rgb, shadow_color.rgb, shadow_val);
	
	COLOR.rgb = mix(COLOR.rgb, shadow_color.rgb, 1.0 - step(0.01, texture(TEXTURE, uv - vec2(1.0, 0.0) * TEXTURE_PIXEL_SIZE).r));
	COLOR.rgb = mix(COLOR.rgb, shadow_color.rgb, 1.0 - step(0.01, texture(TEXTURE, uv + vec2(1.0, 0.0) * TEXTURE_PIXEL_SIZE).r));
	
	// Grass Fringe
	float wind_vert = get_noise(uv + vec2(0.0, wind_position * wind_speed * 0.05));
	float wind_horz = get_noise(uv + vec2(wind_position * wind_speed * 0.05, 0.0));
	
	COLOR.a *= mix(1.0, 0.0, 1.0 - step(0.01, texture(TEXTURE, UV - vec2(0.0, 1.0 * wind_horz) * TEXTURE_PIXEL_SIZE).r));
	COLOR.a *= mix(1.0, 0.0, 1.0 - step(0.01, texture(TEXTURE, UV + vec2(0.0, 1.0 * wind_horz) * TEXTURE_PIXEL_SIZE).r));
	COLOR.a *= mix(1.0, 0.0, 1.0 - step(0.01, texture(TEXTURE, UV - vec2(1.0 * wind_vert, 0.0) * TEXTURE_PIXEL_SIZE).r));
	COLOR.a *= mix(1.0, 0.0, 1.0 - step(0.01, texture(TEXTURE, UV + vec2(1.0 * wind_vert, 0.0) * TEXTURE_PIXEL_SIZE).r));
}