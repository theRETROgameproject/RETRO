shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float para(float u, float v, float x){
	float a = -1.0/pow(u-((v+u)/2.0),2.0);
	float b = pow(x-((v+u)/2.0),2.0);
	float pa = a*b+1.0;
	return pa;
}

void fragment() {
	vec4 bg = texture(SCREEN_TEXTURE,SCREEN_UV);
	COLOR = bg;
	COLOR.r += (0.05*sin(TIME*2.0)+0.4)*para(0.0,1.0,UV.x)*para(0.0,1.0,UV.y);
}