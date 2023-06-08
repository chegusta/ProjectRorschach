shader_type spatial;
render_mode unshaded, depth_test_disabled, cull_disabled;

uniform sampler2D displacement_noise;
uniform sampler2D screen_texture : hint_screen_texture;
uniform float impactIntensity;
uniform float abberation_value;
uniform float stretch_multiplier;
uniform float blackout;
uniform float offset : hint_range(0.0, 1.0, 0.01);
uniform float invert : hint_range(0., 1.0, 1.0);

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
	float n = texture(displacement_noise, texCoords+TIME).r;
	texCoords.x += n * impactIntensity;
	vec3 color = texture(screen_texture, texCoords).rgb;
	vec4 abberationColor = texture(screen_texture, SCREEN_UV);
	abberationColor.r = texture(screen_texture,SCREEN_UV+abberation_value).r;
	abberationColor.g = texture(screen_texture,vec2(SCREEN_UV.x+abberation_value, UV.y-abberation_value)).g;
	abberationColor.b = texture(screen_texture, SCREEN_UV-abberation_value).b;
	
	vec2 uv = SCREEN_UV;
	//random number, multily to make it very small.
	float r = rand(vec2(uv.x, uv.y)) * .008;
	//threshold: if UV.x is below offset, throw 1;
	//add some random offset to UV.x
	float threshold = step(offset, uv.x+r);
	//for threshold inversion
	threshold = abs(invert-threshold);
	vec2 sampleFrom = vec2(offset, uv.y);
	vec4 original = texture(screen_texture, SCREEN_UV);
	vec4 deformed = texture(screen_texture, sampleFrom);
	//use the threshold as mask again (transparent or not)
	vec4 colGlitch= deformed;
	colGlitch = mix(original, colGlitch, threshold);
	ALBEDO = (abberationColor.rgb*abberation_value*.5) + color;
	ALBEDO = mix(ALBEDO, colGlitch.rgb, stretch_multiplier).rgb;
	ALBEDO = mix(ALBEDO, vec3(0.,0.,0.), blackout).rgb;
}
