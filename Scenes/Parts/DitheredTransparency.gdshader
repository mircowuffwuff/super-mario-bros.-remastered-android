shader_type canvas_item;

uniform vec4 transparent_colour: source_color = vec4(0, 0, 0, 0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec4 color = tex_color;

    // Get pixel coordinate in texture space
    vec2 tex_size = vec2(textureSize(TEXTURE, 0)); // Godot 4
    ivec2 coord = ivec2(floor(UV * tex_size));

    // Simple checker pattern based on texture pixel positions
    bool checker = (coord.x + coord.y) % 2 == 0;

    if (checker)
	{
		if (COLOR.a <= 0.0) {discard;}
		COLOR = transparent_colour;
	}
}
