shader_type canvas_item;

// --- Includes --- //
#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
uniform vec4 shadow_color: source_color = vec4(0.0, 0.0, 0.0, 0.1);

uniform float radius: hint_range(0.0, 0.5, 0.01) = 0.25;
uniform vec2 squash_factor = vec2(1.0);

// --- Functions --- //
void fragment() {
	vec2 uv = pixelize(UV, vec2(textureSize(TEXTURE, 0)));
	uv = (uv - 0.5) * squash_factor + 0.5;
	float dist = distance(uv, vec2(0.5));
	
	COLOR = mix(shadow_color, vec4(0.0), step(radius, dist));
}