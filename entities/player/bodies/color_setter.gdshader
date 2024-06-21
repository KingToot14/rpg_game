shader_type canvas_item;

// --- Uniforms --- //
uniform vec4 outline_color: source_color;
uniform vec4 normal_color: source_color;
uniform vec4 shadow_color: source_color;

uniform vec4 flash_color: source_color = vec4(1.0);
uniform float intensity: hint_range(0.0, 1.0, 0.05) = 0.0;

void fragment() {
	vec3 color = vec3(0.0);
	color.rgb = mix(color, outline_color.rgb, COLOR.r);
	color.rgb = mix(color, normal_color.rgb, COLOR.g);
	color.rgb = mix(color, shadow_color.rgb, COLOR.b);
	
	COLOR.rgb = color;
	
	COLOR.rgb = mix(COLOR.rgb, flash_color.rgb, intensity);
}