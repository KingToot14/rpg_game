shader_type canvas_item;

// --- Uniforms --- //
global uniform float wind_position;

uniform float wind_speed = 0.5;

uniform sampler2D noise_texture: repeat_enable, filter_nearest;
uniform vec2 noise_size = vec2(512.0, 512.0);

// --- Functions --- //
float get_noise(vec2 uv, vec2 texture_pixel_size, float offset) {
	return step(0.5, texture(noise_texture, vec2(uv.x / texture_pixel_size.x / noise_size.x + offset, 0.0f)).g);
}

void fragment() {
	COLOR.g += get_noise(UV, TEXTURE_PIXEL_SIZE, -0.05 * wind_position * wind_speed) / 255.0;
}
