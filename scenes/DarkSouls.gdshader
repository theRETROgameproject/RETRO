shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D noise : repeat_enable;

void fragment() {
	vec4 bg = texture(SCREEN_TEXTURE,SCREEN_UV);
	COLOR = bg;
	COLOR *= texture(noise,vec2(SCREEN_UV.x+TIME*0.08,SCREEN_UV.y))*(0.6+0.1*sin(TIME));
}