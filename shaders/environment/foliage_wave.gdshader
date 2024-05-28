shader_type canvas_item;

// --- Uniforms --- //
global uniform vec2 player_position;

uniform float transparency: hint_range(0.0, 1.0, 0.05) = 0.0;

group_uniforms wind;
uniform float amplitude: hint_range(0.0, 5.0, 0.5) = 1.0;
uniform float vert_influence: hint_range(0.0, 20.0, 0.5) = 8.0;
uniform float wind_speed: hint_range(-5.0, 5.0, 0.05) = 2.0;
uniform float wind_falloff: hint_range(0.0, 1.0, 0.05) = 0.0;

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
float sine_wave(float _period, float _amp, float _phase, vec2 _dir, vec2 _pos) {
  return _amp * sin(TWO_PI / _period * dot(_dir, _pos) + _phase);
}

void fragment() {
	vec2 uv = UV / TEXTURE_PIXEL_SIZE;
	
	// Wind
	vec2 texture_size = vec2(textureSize(TEXTURE, 0));
	vec2 wind_uv = round(UV * (texture_size + 1.0) - (UV - 0.5)) / (texture_size + 1.0);
	float wind = sine_wave(TWO_PI, amplitude * TEXTURE_PIXEL_SIZE.x, vert_influence * SCREEN_UV.y + TIME * wind_speed, vec2(-1, 0), wind_uv);
	wind_uv -= vec2((amplitude * TEXTURE_PIXEL_SIZE.x - wind) * (1.0 - UV.y * wind_falloff), 0.0);
	
	COLOR = texture(TEXTURE, wind_uv);
	
	// Transparency
	float player_dist = (clamp(1.0 - distance(SCREEN_UV / SCREEN_PIXEL_SIZE, player_position / SCREEN_PIXEL_SIZE) * SCREEN_PIXEL_SIZE.x / radius, 0.0, 1.0)) * player_influence * step(0.01, transparency);
	COLOR.a *= step(0.0, THRESHOLD_MATRIX[int(uv.x) % 4][int(uv.y) % 4] - transparency - player_dist);
}