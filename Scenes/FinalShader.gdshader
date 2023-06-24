shader_type spatial;
render_mode unshaded, depth_test_disabled, cull_disabled;

uniform sampler2D displacement_noise;
uniform sampler2D screen_texture : hint_screen_texture;
uniform float impactIntensity;
uniform float stretch_multiplier;
uniform float offset : hint_range(0.0, 1.0, 0.01);
uniform float invert : hint_range(0., 1.0, 1.0);
uniform int pixel_size;
uniform float pixelation;
uniform float shader_trans;

uniform float rorScale;
uniform float rorMove;

uniform sampler2D instr;

vec3 screen(vec3 base, vec3 blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));
	
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}


vec2 scale(vec2 uv, float x, float y)
{
	mat2 scale = mat2(vec2(x, 0.0), vec2(0.0, y));
	
	uv -= 0.5;
	uv = uv * scale;
	uv += 0.5;
	return uv;
}

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void vertex(){
	// needs to be 1.0
	VERTEX *= 1.0;
	// needs to be 1.0
	POSITION = vec4(VERTEX, 1.0);
}
void fragment() {
	// Place fragment code here.
	vec2 texCoords = SCREEN_UV;
	float n = texture(displacement_noise, (texCoords*.5)-.75).r;
	texCoords.x += n * (impactIntensity * sin(20.*TIME));
	vec3 color = texture(screen_texture, texCoords).rgb;
	vec2 rorUVs = SCREEN_UV;
	rorUVs = scale(rorUVs, rorScale, rorScale);
	rorUVs.x += rorMove;
	rorUVs = rotate(rorUVs, vec2(.5), TIME);
	float rorschachs = texture(displacement_noise, rorUVs).g;
	vec3 rorschachsC = vec3(rorschachs);
	
	vec2 uv = SCREEN_UV;
	//random number, multily to make it very small.
	float r = rand(vec2(uv.x, uv.y)) * .008;
	//threshold: if UV.x is below offset, throw 1;
	//add some random offset to UV.x
	float threshold = step(offset, uv.x+r);
	//for threshold inversion
	threshold = abs(invert-threshold);
	vec2 sampleFrom = vec2(offset, uv.y);
	vec4 original = texture(screen_texture, texCoords);
	vec4 deformed = texture(screen_texture, sampleFrom);
	//use the threshold as mask again (transparent or not)
	vec4 colGlitch= deformed;
	colGlitch = mix(original, colGlitch, threshold);

	color = colGlitch.rgb + color;
	
	//pixelation
	float x = float (int(FRAGCOORD.x) % pixel_size);
	float y = float (int(FRAGCOORD.y) % pixel_size);
	
	x = FRAGCOORD.x + floor(float(pixel_size) / 2.0) - x;
	y = FRAGCOORD.y + floor(float(pixel_size) / 2.0) - y;
	
	vec3 pixelated = texture(screen_texture, vec2(x,y) / VIEWPORT_SIZE).xyz;
	vec3 finfin = mix(original.rgb+rorschachsC, color, shader_trans);
	ALBEDO = mix(finfin, pixelated, pixelation);
	
	vec2 instrUV = SCREEN_UV;
	instrUV = scale(instrUV, 3., 3.);
	vec4 instrTex = texture(instr, instrUV);
	
	ALPHA = rorschachsC.r*.8;
}
