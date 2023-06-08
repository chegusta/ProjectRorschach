shader_type canvas_item;

uniform float visMult : hint_range(0.0, 1.0);

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	COLOR = col * visMult;
}
