shader_type canvas_item;

// --- Uniforms --- //
uniform float threshold: hint_range(0.0, 1.0, 0.05) = 0.40;
uniform float transparency: hint_range(0.0, 1.0, 0.05) = 0.15;
uniform sampler2D cloud_noise: filter_nearest, repeat_enable;

group_uniforms wind;
uniform vec2 wind_direction = vec2(-1, -1);
uniform float wind_speed: hint_range(0.0, 5.0, 0.01) = 0.5;

// --- Functions --- //
void fragment() {
	//COLOR.a = (1.0 - step(threshold, texture(cloud_noise, UV + 0.5 * wind_speed * wind_direction * TIME).b)) * transparency;
	COLOR.a = texture(cloud_noise, UV + 0.5 * wind_speed * wind_direction * TIME).a * transparency;
}