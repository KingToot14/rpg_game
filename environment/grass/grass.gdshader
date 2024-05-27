shader_type canvas_item;

// --- Uniforms --- //
group_uniforms colors;
uniform vec4 tip_color: source_color;
uniform sampler2D side_gradient;
uniform sampler2D patch_noise: filter_nearest;
uniform float patch_intensity: hint_range(0.0, 1.0, 0.01) = 0.05;

group_uniforms wind;
uniform float wind_speed: hint_range(0.0, 5.0, 0.1) = 1.0;
uniform vec2 wind_direction = vec2(-1, -1);

uniform sampler2D noise_texture: repeat_enable, filter_nearest;
uniform vec2 noise_size = vec2(512.0, 512.0);

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

float get_wind(vec2 _uv) {
	float wind = sine_wave(500.0, 0.25, wind_speed * TIME, wind_direction, _uv);
	return step(0.0, wind) * step(0.8, 1.0 - wind);
}

float get_noise(vec2 uv, vec2 texture_pixel_size, float offset) {
	return step(0.5, texture(noise_texture, vec2(uv.x / texture_pixel_size.x / noise_size.x + offset, 0.0f)).g);
}

void fragment() {
	// Hide roots
	COLOR = mix(vec4(0.0), get_side_color(0.0), step(0.001, COLOR.g));
	
	// Small-scale wind
	vec2 uv = UV + vec2(0.0, TEXTURE_PIXEL_SIZE.y * get_noise(UV, TEXTURE_PIXEL_SIZE, 0.05 * TIME * wind_speed));
	
	// Draw blade
	for (float dist = 1.0; dist < MAX_GRASS_LENGTH; dist++) {
		uv.y += TEXTURE_PIXEL_SIZE.y;
		
		float blade_len = texture(TEXTURE, uv).g * 255.0;
		blade_len += step(0.50, texture(patch_noise, uv).g) * step(0.1, blade_len);
		float curr_wind = get_wind(uv / TEXTURE_PIXEL_SIZE);
		
		// Large-scale wind
		blade_len -= curr_wind;
		
		// Color side if distance < blade length
		COLOR = mix(COLOR, get_side_color(dist / 8.0), step(dist, blade_len));
		// Color tip if distance == blade length
		COLOR = mix(COLOR, tip_color + 0.1 * curr_wind + step(0.50, texture(patch_noise, uv)) * patch_intensity, 
				1.0 - step(0.1, abs(dist - blade_len)));
	}
  }
