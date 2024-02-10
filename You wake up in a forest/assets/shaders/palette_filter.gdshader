// Shader by bram_dingelstad: https://godotshaders.com/shader/palette-shader-lospec-compatible/
shader_type canvas_item;

uniform sampler2D palette : source_color;
uniform int palette_size : hint_range(1, 100);
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment(){ 
	vec4 color = texture(screen_texture, SCREEN_UV);
	vec4 new_color = vec4(.0);
	
	for (int i = 0; i < palette_size; i++) {
		vec4 palette_color = texture(palette, vec2(1.0 / float(palette_size) * (float(i) + 0.5), .0));
		if (distance(palette_color, color) < distance(new_color, color)) {
			new_color = palette_color;
		}
	}
	
	COLOR = new_color;
}