shader_type canvas_item;

uniform vec4 c;
uniform float timeMultiplier;
uniform int uvScale;
uniform float dirChange;
uniform float visMult;
uniform float bigScale;
uniform float angle;
uniform sampler2D noise;

vec2 ScaleUVs(vec2 scale, vec2 uvs, float pivot)
{
	uvs -= pivot;
	mat2 sm = mat2(vec2(scale.x, 0),
	vec2(0, scale.y));
	uvs = sm*uvs;
	uvs += pivot;
	return uvs;
}


void fragment() {
	vec2 uv = UV;
	vec2 uv2 = UV;
	uv *= float(uvScale);

	if(mod(dirChange, 2.0) < 1.0)
		uv.x += step(1.0, mod(uv.y, 2.0))*timeMultiplier;
	else
		uv.y += step(1.0, mod(uv.x, 2.0))*timeMultiplier;
	
	uv = ScaleUVs(vec2(.5), uv, 0.0);
	uv = fract(uv);
	
	uv2 = fract(uv2);
	uv2 = ScaleUVs(vec2(bigScale), uv2, 0.5);
	
	float r = texture(TEXTURE, uv2).r;
	uv2.x = uv2.x + (r * sin(TIME)*.1);
	float n = texture(noise, uv2+sin(.5*TIME)).r*0.1;
	uv2.x = uv2.x + (n) - .05;
	
	vec4 og = texture(TEXTURE, uv2)*vec4(vec3(UV, 0.), 1.);
	vec4 col = texture(TEXTURE, uv);
	COLOR = col + (og*visMult);

}
