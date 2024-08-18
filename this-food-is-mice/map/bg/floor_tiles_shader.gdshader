shader_type canvas_item;

uniform vec2 real_size = vec2(256.0, 256.0);
uniform float tile_size = 64.0;
uniform vec4 color1 : source_color = vec4(1,1,1,1);
uniform vec4 color2 : source_color = vec4(1,0,0,1);

void fragment() 
{
	vec2 uv = UV * real_size / tile_size;
	COLOR = color1;
	if( int(floor(uv.x) + floor(uv.y)) % 2 == 1 ) { COLOR = color2; }
}