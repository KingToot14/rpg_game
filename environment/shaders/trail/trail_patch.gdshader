shader_type canvas_item;

// --- Uniforms --- //
uniform vec2 texture_size = vec2(480, 270);

uniform sampler2D patch_nosie: filter_nearest, repeat_enable;
uniform float patch_threshold: hint_range(0.0, 1.0, 0.05) = 0.10;

// --- Functions --- //
void fragment() {
	vec2 uv = round(SCREEN_UV * (texture_size + 1.0) - (SCREEN_UV - 0.5)) / (texture_size + 1.0);
	COLOR.a *= 1.0 - step(1.0 - patch_threshold, texture(patch_nosie, uv).r);
}