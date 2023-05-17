shader_type spatial;

uniform sampler2D simulationTexture;
uniform sampler2D noiseTexture;
uniform vec2 shift = vec2(0.0, 0.0);

void fragment() {
	float noise = texture(noiseTexture, UV + shift * 0.005).r;
	float collision = texture(simulationTexture, UV + vec2(noise) * 0.004).r;
	ALBEDO = vec3(collision);
}
