shader_type canvas_item;
uniform float amplitude = 0.5;
uniform float speed = 0.5;
void vertex() {
	if(UV.y <= 0.9){
		VERTEX.x += UV.x*amplitude*sin(speed*TIME);
	}
}
