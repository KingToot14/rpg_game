shader_type canvas_item;

#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
uniform float radius: hint_range(0, 60, 1) = 2;
uniform float thickness: hint_range(0, 4, 1) = 2;

// --- Functions --- //
void fragment() {
	vec2 uv = pixelize(UV, vec2(60));
	vec2 pos = uv - 0.5;
	
	COLOR.a *= 1.0 - step(radius / 120.0, distance(uv, vec2(0.5)));
	COLOR.a *= step((radius - thickness * 2.0) / 120.0, distance(uv, vec2(0.5)));
}
