shader_type canvas_item;

void vertex()
{
	VERTEX += vec2(0,sin(TIME)*-5.2);
}