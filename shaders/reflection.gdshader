shader_type canvas_item;

// --- Includes --- //
#include "general_methods.gdshaderinc"

// --- Uniforms --- //
global uniform vec2 screen_size;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;
uniform vec2 texture_size;

// --- Functions --- //
void fragment() {
	vec2 uv = pixelize(UV, texture_size);
	uv = UV;
	vec2 screen_uv = SCREEN_UV - vec2(0.0, 2.0 * uv.y * texture_size.y / screen_size.y);
	
	COLOR = texture(SCREEN_TEXTURE, screen_uv);
	
	COLOR.a = mix(0.0, COLOR.a, step(0.05, COLOR.r + COLOR.g + COLOR.b));
}