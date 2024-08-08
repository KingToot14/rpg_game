shader_type canvas_item;

// --- Includes --- //
#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
global uniform float wind_position;

uniform vec2 texture_size = vec2(480, 270);

group_uniforms reflections;
uniform sampler2D reflection_texture: filter_nearest;
uniform float reflection_intensity: hint_range(0.0, 1.0, 0.05) = 0.25;

group_uniforms water;
uniform vec4 water_color: source_color;
uniform vec4 dark_color: source_color;
uniform sampler2D patch_noise: filter_nearest, repeat_enable;

group_uniforms ground;
uniform vec4 dirt_color: source_color;
uniform float dirt_darkness: hint_range(0.0, 1.0, 0.05) = 0.15;
uniform sampler2D dirt_noise: filter_nearest, repeat_enable;
uniform vec4 grass_color: source_color;
uniform float wind_speed: hint_range(-1.0, 1.0, 0.05) = -0.50;

group_uniforms foam;
uniform vec4 foam_color: source_color;
uniform sampler2D foam_noise: filter_nearest, repeat_enable;
uniform float foam_speed: hint_range(-1.0, 1.0, 0.05) = -0.15;

// --- Constants --- //
const float TWO_PI = 6.28318530718;

// --- Functions --- //
float sine_wave(float _period, float _amp, float _phase, vec2 _dir, vec2 _pos) {
  return _amp * sin(TWO_PI / _period * dot(_dir, _pos) + _phase);
}

float get_noise(vec2 _uv) {
	return step(0.5, texture(foam_noise, _uv).b);
}

float get_patch(vec2 _uv) {
	return step(0.5, texture(patch_noise, _uv).b);
}

float get_dirt(vec2 _uv) {
	return step(0.5, texture(dirt_noise, _uv).b);
}

void fragment() {
	//COLOR.a = step(0.01, COLOR.b);
	COLOR.a = 0.0;
	
	vec2 uv = pixelize(UV, texture_size);
	//uv -= vec2(0.0, COLOR.b * 255.0 * TEXTURE_PIXEL_SIZE.y);
	
	// Set Base Water Color
	vec2 water_uv = uv + vec2(sine_wave(TWO_PI, 2.0 * TEXTURE_PIXEL_SIZE.x, 40.0 * uv.y + wind_position, vec2(-1, 0), uv), 0.0);
	//COLOR.rgb = mix(water_color.rgb, dark_color.rgb, get_patch(water_uv));
	
	// Calculate Reflection
	vec4 reflection_color = texture(reflection_texture, water_uv);
	reflection_color.a = step(0.90, reflection_color.a);
	COLOR = mix(COLOR, reflection_color, reflection_color.a) * step(0.01, COLOR.b);
	COLOR.a *= reflection_intensity;
	
	// Foam Color
	//float foam_val = get_noise(uv + vec2(TIME * foam_speed * 0.05, 0.0));
	//
	//COLOR.rgb = mix(COLOR.rgb, foam_color.rgb, 1.0 - step(0.01, texture(TEXTURE, uv - vec2(0.0, 1.0) * TEXTURE_PIXEL_SIZE).b));
	//COLOR.rgb = mix(COLOR.rgb, foam_color.rgb, 1.0 - step(0.01, texture(TEXTURE, uv - vec2(0.0, 2.0 * foam_val) * TEXTURE_PIXEL_SIZE).b));
	//COLOR.rgb = mix(COLOR.rgb, foam_color.rgb, 1.0 - step(0.01, texture(TEXTURE, uv - vec2(1.0, 0.0) * TEXTURE_PIXEL_SIZE).b));
	//COLOR.rgb = mix(COLOR.rgb, foam_color.rgb, 1.0 - step(0.01, texture(TEXTURE, uv + vec2(1.0, 0.0) * TEXTURE_PIXEL_SIZE).b));
	//
	//// Dirt Color
	//float dirt = get_dirt(uv);
	//COLOR.rgb = mix(COLOR.rgb, dirt_color.rgb - dirt * dirt_darkness, 1.0 - step(0.01, texture(TEXTURE, uv + vec2(0.0, dirt / 270.0)).b));
	//
	//// Grass Fringe
	//float wind_vert = get_noise(uv + vec2(0.0, wind_position * wind_speed * 0.05));
	//float wind_horz = get_noise(uv + vec2(wind_position * wind_speed * 0.05, 0.0));
	//
	//COLOR.a *= mix(1.0, 0.0, 1.0 - step(0.01, texture(TEXTURE, UV - vec2(0.0, 1.0 * wind_horz) * TEXTURE_PIXEL_SIZE).b));
	//COLOR.a *= mix(1.0, 0.0, 1.0 - step(0.01, texture(TEXTURE, UV + vec2(0.0, 1.0 * wind_horz) * TEXTURE_PIXEL_SIZE).b));
	//COLOR.a *= mix(1.0, 0.0, 1.0 - step(0.01, texture(TEXTURE, UV - vec2(1.0 * wind_vert, 0.0) * TEXTURE_PIXEL_SIZE).b));
	//COLOR.a *= mix(1.0, 0.0, 1.0 - step(0.01, texture(TEXTURE, UV + vec2(1.0 * wind_vert, 0.0) * TEXTURE_PIXEL_SIZE).b));
}
