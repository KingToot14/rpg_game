shader_type canvas_item;

// --- Uniforms --- //
uniform float threshold: hint_range(0.0, 1.0, 0.01) = 0.10;

uniform vec3 good_color: source_color;
uniform vec3 perf_color: source_color;

// --- Functions --- //
void fragment() {
	vec2 uv = round(UV * (61.0) - (UV - 0.5)) / (61.0);
	vec2 pos = uv - 0.5;
	
	float angle = atan(pos.y, pos.x);
	
	COLOR.rgb *= mix(good_color, perf_color, step(-PI * threshold, angle));
	
	//if (angle < -PI * threshold) {
		//COLOR.rb = vec2(0.0);
	//}
}