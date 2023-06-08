shader_type canvas_item;

uniform vec2 resolution;
uniform float pixel_position : hint_range(0.0, 1.0, 0.1);

uniform vec2 bottom_left;
uniform vec2 top_right;
uniform float square_offset_x;
uniform float square_offset_y;

void fragment() {
		
	vec2 size = 1./TEXTURE_PIXEL_SIZE;
	
	float xRes = size.x;
	float yRes = size.y;
	
	vec2 maskUV = UV;
	
	float thres = step(pixel_position, maskUV.x);
	
	float xFactor = xRes/resolution.x;
	float yFactor = yRes/resolution.y;
	
	float grid_uv_x = round(UV.x * xFactor) / xFactor;
	float grid_uv_y = round(UV.y * yFactor) / yFactor;
	vec4 original = texture(TEXTURE, UV);
	vec4 text = texture(TEXTURE, vec2(grid_uv_x, grid_uv_y));
	COLOR = text;
	
	maskUV.x += square_offset_x;
	maskUV.y += square_offset_y;
	//now for the square...
	vec2 bl = step(bottom_left,maskUV);
    float pct = bl.x * bl.y;

    // top-right
    vec2 tr = step(top_right,1.-maskUV);
    pct *= (tr.x * tr.y);

	COLOR = mix(original, COLOR, pct);
	//COLOR = vec4(vec3(pct), 1.);
}
