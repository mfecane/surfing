shader_type spatial;

uniform sampler2D simulationTexture;

void fragment() {
	ALBEDO = vec3(texture(simulationTexture, UV).r, 0.0, 0.0);
}
