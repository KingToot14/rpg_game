

// --- Functions --- //
vec2 pixelize(vec2 _uv, vec2 _texture_size) {
	return round(_uv * (_texture_size + 1.0) - (_uv - 0.5)) / (_texture_size + 1.0);
}