shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 bg = texture(SCREEN_TEXTURE,SCREEN_UV);
	COLOR = bg;
	COLOR *= vec4(0.5*(-4.0*pow(UV.x-0.5,2.0)+1.0)*(-4.0*pow(UV.y-0.5,2.0)+1.0),0.5*(-4.0*pow(UV.x-0.5,2.0)+1.0)*(-4.0*pow(UV.y-0.5,2.0)+1.0),0.5*(-4.0*pow(UV.x-0.5,2.0)+1.0)*(-4.0*pow(UV.y-0.5,2.0)+1.0),1.0);
}