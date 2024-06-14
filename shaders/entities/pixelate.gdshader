shader_type canvas_item;

#include "res://shaders/general_methods.gdshaderinc"

// --- Uniforms --- //
uniform sampler2D screen_texture: hint_screen_texture;

// --- Functions --- //
void fragment() {
	vec2 uv = pixelize(SCREEN_UV, vec2(480.0, 270.0));
	
	vec4 c = textureLod(screen_texture, uv, 0.0);

	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}

	COLOR *= c;
	
	//vec2 uv = pixelize(UV, vec2(textureSize(TEXTURE, 0)));
	
	//COLOR = texture(TEXTURE, uv);
	//COLOR = texture(TEXTURE, UV);
}