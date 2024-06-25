shader_type canvas_item;
render_mode blend_sub;

// --- Includes --- //
#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
global uniform sampler2D overworld_shader_texture: filter_nearest;
global uniform float wind_position;

uniform vec2 grass_size = vec2(480.0, 270.0);
uniform sampler2D wind_noise: filter_nearest, repeat_enable;
uniform float wind_speed = -0.25;

uniform float texture_height;
uniform float offset = 0.0;

// --- Constants --- //
const float MAX_GRASS_LENGTH = 9.0;

// --- Functions --- //
float get_noise(vec2 _uv, float _offset) {
	return step(0.5, texture(wind_noise, vec2(_uv.x + _offset, 0.0f)).g);
}

void fragment() {
	float height = ((1.0 - UV.y) * texture_height) - offset;
	float val = 0.0;
	
	COLOR.a = -1.0;
	
	vec2 uv = pixelize(SCREEN_UV, grass_size) + vec2(0.0, 1.0 / grass_size.y);
	
	// Bottom edge
	val += step(0.001, texture(overworld_shader_texture, uv).g);
	
	// Draw blades
	for (float dist = 0.0; dist < MAX_GRASS_LENGTH; dist ++) {
		float blade_len = texture(overworld_shader_texture, uv).g * 255.0;
		blade_len += get_noise(uv, 0.05 * wind_position * wind_speed) * min(blade_len, 1.0);
		float inc = 1.0 - step(blade_len, dist);
		
		COLOR.a += inc * step(height, blade_len);
		
		uv.y += (1.0 / grass_size.y);
	}
	
	uv = pixelize(SCREEN_UV, grass_size) + vec2(0.0, (1.0 + height) / grass_size.y);
	
	val += 1.0 - step(0.001, texture(overworld_shader_texture, uv).g);
	
	COLOR.a *= 1.0 - floor(val / 2.0);
}
