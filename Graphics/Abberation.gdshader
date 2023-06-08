shader_type canvas_item;

uniform float abberation_value : hint_range (0.0, 0.02);


void fragment() {
	
	vec4 original = texture(TEXTURE, UV);
	COLOR = original;
	//abberation
	COLOR.r = texture(TEXTURE,UV+abberation_value).r;
	COLOR.g = texture(TEXTURE,vec2(UV.x+abberation_value, UV.y-abberation_value)).g;
	COLOR.b = texture(TEXTURE, UV-abberation_value).b;
	
}
