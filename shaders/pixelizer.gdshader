shader_type canvas_item;

// --- Includes --- //
#include "general_methods.gdshaderinc"

// --- Uniforms --- //
global uniform vec2 screen_size;

// --- Functions --- //
void fragment() {
	vec2 uv = pixelize(UV, screen_size);
	COLOR = texture(TEXTURE, uv);
}