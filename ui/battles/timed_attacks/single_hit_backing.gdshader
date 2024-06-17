shader_type canvas_item;

// --- Includes --- //
#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
uniform float threshold: hint_range(0.0, 1.0, 0.01) = 0.10;

uniform vec3 good_color: source_color;
uniform vec3 perf_color: source_color;

// --- Functions --- //
void fragment() {
	vec2 uv = pixelize(UV, vec2(60.0));
	vec2 pos = uv - 0.5;
	
	float angle = atan(pos.y, pos.x);
	
	COLOR.rgb *= mix(good_color, perf_color, step(-PI * threshold, angle));
}