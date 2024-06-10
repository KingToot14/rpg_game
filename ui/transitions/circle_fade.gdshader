shader_type canvas_item;

// --- Uniforms --- //
uniform float cutoff = 0.0;
uniform float fade_length = 0.25;

// --- Functions --- //
void fragment() {
	COLOR.a -= smoothstep(cutoff - fade_length, cutoff, distance(UV, vec2(0.5)));
}