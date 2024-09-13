shader_type canvas_item;

// --- Includes --- //
#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
global uniform vec2 player_position;
global uniform float wind_position;
global uniform vec2 screen_size;

uniform float transparency: hint_range(0.0, 1.0, 0.05) = 0.0;

group_uniforms wind;
uniform float wind_speed: hint_range(-5.0, 5.0, 0.05) = 2.0;
uniform float wind_threshold: hint_range(-1.0, 1.0, 0.05) = 0.75;
uniform float wind_offset: hint_range(0.0, 16.0, 1.0) = 0.0;
uniform float wave_count: hint_range(1.0, 10.0) = 3.0;
uniform float wind_angle: hint_range(0.0, 6.28318530718, 0.392699081699) = 0.0;

group_uniforms player;
uniform float player_influence: hint_range(0.0, 1.0, 0.05) = 0.60;
uniform float radius: hint_range(0.0, 1.0, 0.05) = 0.05;

// --- Constants --- //
const float TWO_PI = 6.28318530718;

const mat4 THRESHOLD_MATRIX = mat4(
		vec4(1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0),
		vec4(13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0),
		vec4(4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0),
		vec4(16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0));

// --- Functions --- //
float get_wind(float _height) {
	return step(wind_threshold, sin((2.0 * PI * wave_count * _height) / screen_size.y));
}
float get_sine(float _time, float _height) {
	return  1.0 * sin(_height * 1.0 + _time) + 
			0.6 * sin(_height * 2.3 + _time) + 
			0.4 * sin(_height * 4.2 + _time);
}

void fragment() {
	vec2 pos = pixelize(1.0 - UV + SCREEN_UV, vec2(textureSize(TEXTURE, 0))) * vec2(textureSize(TEXTURE, 0));
	pos = 1.0 - UV + SCREEN_UV;
	pos = rotate_to(pos, wind_angle) * vec2(textureSize(TEXTURE, 0));
	
	float pos_y = pos.y + 4.0 * get_sine(TIME, 0.1 * pos.x);
	float wind = get_wind(pos_y - 10.0 * wind_position * wind_speed);
	
	vec2 uv = UV;
	uv.x -= TEXTURE_PIXEL_SIZE.x * wind;
	
	COLOR = texture(TEXTURE, uv);
	
	// Transparency
	uv = UV / TEXTURE_PIXEL_SIZE;
	
	uv = pixelize(uv, vec2(textureSize(TEXTURE, 0)));
	
	float player_dist = (clamp(1.0 - distance(SCREEN_UV / SCREEN_PIXEL_SIZE, player_position / SCREEN_PIXEL_SIZE) * SCREEN_PIXEL_SIZE.x / radius, 0.0, 1.0)) * player_influence * step(0.01, transparency);
	COLOR.a *= step(0.0, THRESHOLD_MATRIX[int(uv.x) % 4][int(uv.y) % 4] - transparency - player_dist);
}