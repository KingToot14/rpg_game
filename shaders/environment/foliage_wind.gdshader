shader_type canvas_item;

// --- Uniforms --- //
global uniform float wind_position;

group_uniforms wind;
uniform float amplitude: hint_range(0.0, 5.0, 0.5) = 1.0;
uniform float wind_size: hint_range(0.0, 1.0, 0.05) = 0.20;
uniform vec2 wind_direction = vec2(-1.0);
uniform float wind_speed: hint_range(0.0, 5.0, 0.10) = 2.0;
uniform float wind_falloff: hint_range(0.0, 1.0, 0.05) = 0.0;

// --- Constants --- //
const float TWO_PI = 6.28318530718;

// --- Functions --- //
float sine_wave(float _period, float _amp, float _phase, vec2 _dir, vec2 _pos) {
  return _amp * sin(TWO_PI / _period * dot(_dir, _pos) + _phase);
}

float get_wind(vec2 _uv) {
	float wind = sine_wave(500.0, 0.25, wind_speed * wind_position, wind_direction, vec2(wind_position) + _uv);
	return step(0.0, wind) * step(1.0 - wind_size, 1.0 - wind);
}

void fragment() {
	vec2 uv = UV / TEXTURE_PIXEL_SIZE;
	
	// Wind
	vec2 texture_size = vec2(textureSize(TEXTURE, 0));
	vec2 wind_uv = round(UV * (texture_size + 1.0) - (UV - 0.5)) / (texture_size + 1.0);
	wind_uv += wind_direction * amplitude * get_wind(SCREEN_UV / TEXTURE_PIXEL_SIZE) * TEXTURE_PIXEL_SIZE * (1.0 - wind_uv.y * wind_falloff);
	
	COLOR = texture(TEXTURE, wind_uv);
}
