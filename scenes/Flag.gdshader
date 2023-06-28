shader_type canvas_item;

void vertex() {
	VERTEX.y += sin(3.0*TIME*UV.x)*UV.x;
}
