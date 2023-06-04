shader_type canvas_item;

uniform sampler2D rorschach;
uniform sampler2D rorschach2;
uniform sampler2DArray rorschachArray;
uniform int arrayIterator;
uniform float multR1;
uniform float multR2;

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));
	
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

void fragment() {
	vec2 uv = UV;
	vec2 uv2 = UV;
	uv += .5;
	uv *= .5;
	uv2 += .5;
	uv2 *= .5;
	uv2 = rotate(uv2, vec2(0.5), TIME*3.);
	float n = texture(rorschach, uv).r*.3;
	//float n2 = texture(rorschach2, uv2).r*.3;
	float n2 = texture(rorschachArray, vec3(uv2.x, uv2.y, float(arrayIterator))).r*1.;
	vec2 displacedUV = uv + n;
	displacedUV.x += TIME*.1;
	vec2 displacedUV2 = uv + n2;
	//displacedUV2 *= random(uv2)+1.+fract(TIME);
	
	displacedUV2 = rotate(displacedUV2, vec2(.5), TIME);
	vec4 colorsampleR1 = texture(rorschach, displacedUV2);
	vec4 col = texture(TEXTURE, displacedUV);
	vec4 col2 = texture(TEXTURE, displacedUV2) + colorsampleR1*fract(TIME*.5);
	COLOR = col*(multR1) + col2*(multR2);
}
