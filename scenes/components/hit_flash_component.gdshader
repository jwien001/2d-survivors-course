shader_type canvas_item;

uniform float lerp_percent : hint_range(0.0, 1.0);

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    vec3 final_color = mix(color.rgb, vec3(1.0, 1.0, 1.0), lerp_percent);
	COLOR.rgb = final_color;
}
