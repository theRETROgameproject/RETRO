shader_type canvas_item;

uniform float amplitude = 8.0;
uniform float speed = 0.1;

void vertex(){
	VERTEX.y += amplitude*sin(speed*TIME)-amplitude;
	VERTEX.x += 6.0*amplitude*cos(TIME)-6.0*amplitude;
}
