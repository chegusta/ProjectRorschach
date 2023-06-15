shader_type spatial;
render_mode unshaded, depth_test_disabled, cull_disabled, depth_prepass_alpha;

uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D instruction;

vec2 scale(vec2 uv, float x, float y)
{
	mat2 scale = mat2(vec2(x, 0.0), vec2(0.0, y));
	
	uv -= 0.5;
	uv = uv * scale;
	uv += 0.5;
	return uv;
}

void fragment() {
	vec2 instrUV = SCREEN_UV;
	instrUV = scale(instrUV, 3., 3.);
	vec4 instrTex = texture(instruction, SCREEN_UV);
	ALBEDO = instrTex.rgb;
	ALPHA = instrTex.a;
}
