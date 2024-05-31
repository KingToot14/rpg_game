shader_type canvas_item;

// --- Uniforms --- //
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;

uniform vec4 flash_color: source_color = vec4(1.0);
uniform float intensity: hint_range(0.0, 1.0, 0.05) = 0.0;

// --- Functions --- //
void fragment() {
	COLOR.rgb = mix(COLOR.rgb, flash_color.rgb, intensity);
}