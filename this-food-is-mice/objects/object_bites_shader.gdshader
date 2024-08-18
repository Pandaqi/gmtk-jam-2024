shader_type canvas_item;

uniform sampler2D base_tex;
uniform int frame;
uniform sampler2D bite_tex;
uniform vec2 size_real;
uniform vec2[10] bite_centers;
uniform vec2[10] bite_sizes;
uniform vec2 spritesheet_size = vec2(4.0);

vec2 rotate_uv(vec2 uv, vec2 pivot, float rotation) 
{
    mat2 rotation_matrix = mat2(
		vec2(sin(rotation),-cos(rotation)),
		vec2(cos(rotation),sin(rotation))
	);
    uv -= pivot;
    uv = uv*rotation_matrix;
    uv += pivot;
    return uv;
}

void fragment() 
{
	vec2 uv_for_frame = UV / spritesheet_size;
	uv_for_frame += vec2(
		float(frame % int(spritesheet_size.y)),
		floor(float(frame) / spritesheet_size.x)
	) * 1.0 / spritesheet_size;
	
	vec2 uv_real = UV * size_real;
	vec4 base_col = texture(base_tex, uv_for_frame);
	for(int i = 0; i < 10; i++)
	{
		vec2 center = bite_centers[i];
		float size = bite_sizes[i].x;
		float rotation = bite_sizes[i].y;
		vec2 temp_uv = rotate_uv((uv_real - center) / size + vec2(0.5), vec2(0.5), rotation);
		if(temp_uv.x < 0.0 || temp_uv.x > 1.0 || temp_uv.y < 0.0 || temp_uv.y > 1.0) { continue; }
		float texture_val = texture(bite_tex, temp_uv).r;
		base_col.a *= 1.0 - texture_val;
	}
	
	COLOR = base_col;
}