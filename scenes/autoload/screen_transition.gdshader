shader_type canvas_item;

uniform vec4 transition_color : source_color;
uniform sampler2D transition_texture;
uniform float percent : hint_range(0.0, 1.0);

void fragment() {
	vec4 color = texture(transition_texture, UV);
    if (color.r > percent) {
        COLOR.a = 0.0;
    } else {
        COLOR = transition_color;
    }
}
