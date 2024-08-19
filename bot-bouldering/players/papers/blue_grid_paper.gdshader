shader_type canvas_item;

uniform vec2 real_size = vec2(256.0);
uniform float thickness = 16.0;
uniform vec2 tile_size = vec2(64.0);
uniform vec4 color : source_color = vec4(1,1,1,1);
uniform vec4 color_lines : source_color = vec4(0.5, 0.5, 1.0, 1);

void fragment() 
{
	vec2 uv_real = UV * real_size/tile_size;
	uv_real.x = uv_real.x - floor(uv_real.x);
	uv_real.y = uv_real.y - floor(uv_real.y);
	uv_real *= tile_size;
	vec4 new_color = color;
	float dist_to_edge = min(abs(uv_real.x - 0.5*tile_size.x), abs(uv_real.y - 0.5*tile_size.y));
	if(dist_to_edge <= 0.5*thickness) { new_color = color_lines; }
	COLOR = new_color;
}