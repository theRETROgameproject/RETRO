shader_type canvas_item;

void fragment() {
	vec4 bg = texture(TEXTURE,UV);
	
	COLOR = bg;
	if(UV.y <= (3.55/16.0)){
		COLOR *= vec4(1.0,1.0,1.0,0.5*sin(2.0*TIME)+1.0);
	}
}
