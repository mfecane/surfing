shader_type canvas_item;

#define attenuation 0.95
#define phase 0.1

uniform sampler2D simultationTexture;
uniform sampler2D collisionTexture;

uniform float deltaUV = 3.0;

uniform vec2 shift = vec2(0.0, 0.0);

void fragment() {
	vec2 oldUV = UV + shift;

	float dv = 1.0 / 1024.0;
	float du = 1.0 / 1024.0;
	vec3 duv = vec3(du, dv, 0) * deltaUV;

	vec3 currentPixel = texture(simultationTexture, UV).rgb;
	vec3 previousPixel = texture(simultationTexture, oldUV).rgb;

	float pixel = (2.0 * previousPixel.r - previousPixel.g + phase * (
		texture(simultationTexture, oldUV - duv.zy).r +
		texture(simultationTexture, oldUV + duv.zy).r +
		texture(simultationTexture, oldUV - duv.xz).r +
		texture(simultationTexture, oldUV + duv.xz).r - 4.0 * previousPixel.r)) * attenuation;
	
	float collisionPixel = texture(collisionTexture, vec2(UV.x, 1.0 - UV.y)).r;
	float previousCollision = previousPixel.b;
	
	if (collisionPixel > 0.0 && previousCollision == 0.0) {
		pixel += collisionPixel * 0.5;
	}
	
	if (previousCollision > 0.0 && collisionPixel == 0.0) {
		pixel -= previousCollision * 0.5;
	}
		
	COLOR = vec4(pixel, previousPixel.r, collisionPixel, 1);
}
