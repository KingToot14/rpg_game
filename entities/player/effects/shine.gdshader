shader_type canvas_item;

// --- Includes --- //
#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
uniform float position = 1.0;
uniform float rotation = 90.0;
uniform float size = 0.2;

uniform vec4 shine_color: source_color;

// --- Functions --- //
void fragment() {
	vec2 uv = pixelize(UV, vec2(textureSize(TEXTURE, 0)));
	uv = rotate_to(uv - 0.5, radians(rotation)) + 0.5;
	
	vec4 color = mix(COLOR, shine_color, shine_color.a);
	
	COLOR.rgb = mix(color, COLOR, step(size, abs(uv.x + uv.y - position))).rgb;
}