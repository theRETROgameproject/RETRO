shader_type canvas_item;

float para(float u, float v, float x){
	float a = -1.0/pow(u-((v+u)/2.0),2.0);
	float b = pow(x-((v+u)/2.0),2.0);
	float pa = a*b+1.0;
	return pa;
}

void fragment() {
	vec2 uv;
	vec4 bg = texture(TEXTURE,UV);
	COLOR = bg;
	for(float i = 0.0; i<160.0;i+= 16.0){
    	uv.x = UV.x-(i/128.0);
		if(i==0.0 || i==4.0){
			if((uv.x >= (0.75/16.0)) && (uv.x <= (1.375/16.0))){
				if((UV.y >= (5.0/16.0)) && (UV.y <= (8.0/16.0))){
					COLOR = vec4(para(0.3125,0.5,UV.y)*para(0.046875,0.0859375,uv.x)*(3.5+2.0*sin(TIME))*bg.r,1.0*bg.g,1.0*bg.b,1.0);
				}
			}
		}else if((uv.x >= (0.75/16.0)) && (uv.x <= (1.375/16.0))){
			if((UV.y >= (4.0/16.0)) && (UV.y <= (7.0/16.0))){
				COLOR = vec4(para(0.25,0.4375,UV.y)*para(0.046875,0.0859375,uv.x)*(3.5+2.0*sin(TIME))*bg.r,1.0*bg.g,1.0*bg.b,1.0);
			}
		}
	}
}