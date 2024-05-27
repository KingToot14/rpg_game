shader_type canvas_item;

// --- Uniforms --- //
group_uniforms colors;
uniform vec4 water_color: source_color;
uniform vec4 dark_color: source_color;
uniform vec4 foam_color: source_color;

group_uniforms noise;
uniform sampler2D patch_noise: filter_nearest;

// --- Constants --- //
const float TWO_PI = 6.28318530718;

// --- Functions --- //
float sine_wave(float _period, float _amp, float _phase, vec2 _dir, vec2 _pos) {
  return _amp * sin(TWO_PI / _period * dot(_dir, _pos) + _phase);
}

void fragment() {
	vec2 uv = UV + vec2(sine_wave(1.0, 1.0, TIME, vec2(1.0), UV) * TEXTURE_PIXEL_SIZE);
	//vec2 uv = UV + vec2(sin(TIME));
	
	// Dark Patches
	COLOR.rgb = mix(water_color.rgb, dark_color.rgb, step(0.5, texture(patch_noise, uv).b));
	
	// Foam Color
	COLOR.rgb = mix(COLOR.rgb, foam_color.rgb, 1.0 - step(0.01, texture(TEXTURE, uv - vec2(0.0, 1.0) * TEXTURE_PIXEL_SIZE).a));
	COLOR.rgb = mix(COLOR.rgb, foam_color.rgb, 1.0 - step(0.01, texture(TEXTURE, uv - vec2(0.0, 2.0) * TEXTURE_PIXEL_SIZE).a));
	COLOR.rgb = mix(COLOR.rgb, foam_color.rgb, 1.0 - step(0.01, texture(TEXTURE, uv - vec2(1.0, 0.0) * TEXTURE_PIXEL_SIZE).a));
	COLOR.rgb = mix(COLOR.rgb, foam_color.rgb, 1.0 - step(0.01, texture(TEXTURE, uv + vec2(1.0, 0.0) * TEXTURE_PIXEL_SIZE).a));
}
