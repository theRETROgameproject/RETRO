shader_type canvas_item;

uniform float amplitude = 1.0;
uniform float speed = 3.0;

void vertex(){
	VERTEX.y += amplitude*sin(speed*TIME)-amplitude;
	VERTEX.x += 2.0*amplitude*sin(TIME)-2.0*amplitude;
}

