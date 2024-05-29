shader_type canvas_item;

// --- Uniforms --- //
uniform sampler2D grass_texture: filter_nearest;
uniform vec2 grass_size = vec2(480.0, 270.0);

// --- Constants --- //
const float MAX_GRASS_LENGTH = 9.0;

// --- Functions --- //
void fragment() {
	float height = (1.0 - UV.y) / TEXTURE_PIXEL_SIZE.y;
	
	vec2 uv = SCREEN_UV + vec2(0.0, height * SCREEN_PIXEL_SIZE.y * (1.0 / SCREEN_PIXEL_SIZE.y / grass_size.y));
	
	// Draw blade
	for (float dist = 1.0; dist < MAX_GRASS_LENGTH; dist++) {
		uv.y += SCREEN_PIXEL_SIZE.y * (1.0 / SCREEN_PIXEL_SIZE.y / grass_size.y);
		
		float blade_len = texture(grass_texture, uv).g * 255.0;
		
		COLOR *= step(blade_len, height);
		
		height += 1.0;
	}
}
