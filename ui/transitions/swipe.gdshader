shader_type canvas_item;

// --- Includes --- //
#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
uniform vec2 offset = vec2(0.0);
uniform vec2 separation = vec2(1.0);
uniform float fade_length: hint_range(0.0, 1.0, 0.05) = 0.20;

// --- Functions --- //
void fragment() {
	vec2 uv = UV - offset * (1.0 + fade_length);
	
	COLOR.a *= smoothstep(-fade_length + (1.0 - separation.x), (1.0 - separation.x), uv.x);
	COLOR.a *= 1.0 - smoothstep(separation.x, separation.x + fade_length, uv.x);
	COLOR.a *= smoothstep(-fade_length + (1.0 - separation.y), (1.0 - separation.y), uv.y);
	COLOR.a *= 1.0 - smoothstep(separation.y, separation.y + fade_length, uv.y);
	
	COLOR.a = 1.0 - COLOR.a;
}