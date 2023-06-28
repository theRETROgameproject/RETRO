shader_type canvas_item;

uniform float amplitude = 2.0;
uniform float speed = 3.0;

void vertex(){
	VERTEX.y += amplitude*sin(speed*TIME)-amplitude;
}

