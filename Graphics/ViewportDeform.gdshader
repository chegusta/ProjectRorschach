shader_type canvas_item;

uniform float offset : hint_range(0.0, 1.0, 0.01);
uniform float invert : hint_range(0., 1.0, 1.0);

//pseudorandom function to sample randomness from
float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}


void fragment() {
	vec2 uv = UV;
	vec2 defUv = UV;
	//random number, multily to make it very small.
	float r = rand(vec2(uv.x, uv.y)) * .008;
	//threshold: if UV.x is below offset, throw 1;
	//add some random offset to UV.x
	float threshold = step(offset, UV.x+r);
	//for threshold inversion
	threshold = abs(invert-threshold);
	/*Defines the UVs the deformed texture will sample from
	Threshold can be 0 or 1 -> multiplication results in either
	0 or something inbetween zero and 1.0.
	This results in our sample x to be synced with the offset
	uv.y just stays the same since it should take the corresponding y coordinate 
	for the sample
	*/ 
	vec2 sampleFrom = vec2(offset, uv.y);
	vec4 original = texture(TEXTURE, UV);
	vec4 deformed = texture(TEXTURE, sampleFrom);
	//use the threshold as mask again (transparent or not)
	COLOR = deformed;
	COLOR = mix(original, COLOR, threshold);
	COLOR = mix(COLOR, original, 1.);
}
