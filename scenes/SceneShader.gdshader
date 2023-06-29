shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 bg = texture(SCREEN_TEXTURE,SCREEN_UV);
	COLOR = vec4((1.0-UV.y)*bg.r,(1.0-UV.y)*bg.g,(1.0-UV.y)*bg.b,0.7);
}
