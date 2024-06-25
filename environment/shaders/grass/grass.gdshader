shader_type canvas_item;

// --- Includes --- //
#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
global uniform float wind_position;
global uniform vec2 screen_size;

group_uniforms colors;
uniform vec4 tip_color: source_color;
uniform sampler2D side_gradient;
uniform sampler2D patch_noise: filter_nearest;
uniform sampler2D wind_noise: filter_nearest, repeat_enable;
uniform float patch_intensity: hint_range(0.0, 1.0, 0.01) = 0.05;
uniform float patch_threshold: hint_range(0.0, 1.0, 0.05) = 0.50;

group_uniforms wind;
uniform float wind_intensity: hint_range(0.0, 1.0, 0.05) = 0.5;
uniform float wind_speed: hint_range(0.0, 5.0, 0.1) = 1.0;
uniform vec2 wind_direction = vec2(-1, -1);

// --- Constants --- //
const float MAX_GRASS_LENGTH = 9.0;

const float TWO_PI = 6.28318530718;

// --- Functions --- //
vec4 get_side_color(float _dist) {
	return texture(side_gradient, vec2(_dist, 0.0));
}

float sine_wave(float _period, float _amp, float _phase, vec2 _dir, vec2 _pos) {
  return _amp * sin(TWO_PI / _period * dot(_dir, _pos) + _phase);
}

float get_patch(vec2 _uv) {
	return texture(patch_noise, _uv).g;
}

float get_noise(vec2 _uv, float _offset) {
	return step(0.5, texture(wind_noise, vec2(_uv.x + _offset, 0.0f)).g);
}

void fragment() {
	// Hide roots
	COLOR.a = step(0.01, COLOR.g);
	COLOR.rgb = mix(vec4(0.0), get_side_color(0.0), step(0.001, COLOR.g)).rgb;
	
	vec2 uv = pixelize(UV, screen_size);
	
	// Draw blade
	for (float dist = 1.0; dist < MAX_GRASS_LENGTH; dist++) {
		uv.y += TEXTURE_PIXEL_SIZE.y;
		
		float blade_len = texture(TEXTURE, uv).g * 255.0;
		blade_len += get_noise(uv, -0.05 * wind_position * wind_speed) * min(blade_len, 1.0);
		
		// Color side if distance < blade length
		COLOR = mix(COLOR, get_side_color(dist / 8.0), step(dist, blade_len));
		// Color tip if distance == blade length
		COLOR = mix(COLOR, tip_color + step(patch_threshold, get_patch(uv)) * patch_intensity, 
				1.0 - step(0.1, abs(dist - blade_len)));
	}
  }
