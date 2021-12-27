shader_type canvas_item;
uniform bool should_flicker;

void fragment(){
	COLOR = texture(TEXTURE, UV);

	if (should_flicker)
	{
	COLOR.x = sin(TIME*70.0);
	}
}


