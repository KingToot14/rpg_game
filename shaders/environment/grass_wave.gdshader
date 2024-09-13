shader_type canvas_item;

// --- Includes --- //
#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
global uniform float wind_position;
global uniform vec2 screen_size;

group_uniforms wind;
uniform float wind_speed: hint_range(-5.0, 5.0, 0.05) = 2.0;
uniform float wind_threshold: hint_range(-1.0, 1.0, 0.05) = 0.75;
uniform float wave_count: hint_range(1.0, 10.0) = 3.0;
uniform float wind_angle: hint_range(0.0, 6.28318530718, 0.392699081699) = 0.0;

// --- Constants --- //
const float TWO_PI = 6.28318530718;

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
	vec2 pos = pixelize(1.0 - UV, vec2(textureSize(TEXTURE, 0))) * vec2(textureSize(TEXTURE, 0));
	pos = rotate_to(pos, wind_angle);
	
	float pos_y = pos.y + 4.0 * get_sine(TIME, 0.01 * pos.x);
	float wind = get_wind(pos_y - 10.0 * wind_position * wind_speed);
	
	vec2 uv = UV;
	
	uv.x -= TEXTURE_PIXEL_SIZE.y * wind;
	
	COLOR = texture(TEXTURE, uv);
}