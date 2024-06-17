shader_type canvas_item;

// --- Includes --- //
#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
uniform float rotation: hint_range(0.0, 360.0, 5.0) = 0.0;

// --- Functions --- //
vec2 rotate(vec2 _pos, float _angle) {
	return vec2(_pos.x * cos(_angle) - _pos.y * sin(_angle), _pos.x * sin(_angle) + _pos.y * cos(_angle));
}

void fragment() {
	vec2 uv = pixelize(UV, vec2(60.0));
	uv = rotate(uv - vec2(0.5), radians(90.0 - rotation)) + vec2(0.5);
	vec2 pos = uv - 0.5;
	
	COLOR.a = 1.0 - step(0.456666, distance(uv, vec2(0.5)));
	
	COLOR.a *= 1.0 - step(1.0 / 60.0, abs(uv.x - 0.5));
	COLOR.a *= step(0.5, uv.y);
	
	// rotation
	COLOR.a *= smoothstep(145.0, 180.0, rotation);
	COLOR.a *= 1.0 - step(360.0, rotation);
}