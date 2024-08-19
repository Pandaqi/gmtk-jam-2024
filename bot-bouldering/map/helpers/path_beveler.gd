class_name PathBeveler

func bevel(pts:Array[Vector2], bevel_size:float) -> Array[Vector2]:
	var points : Array[Vector2] = []
	var num := pts.size()
	for i in range(num):
		var prev_point := pts[(i - 1 + num) % num]
		var cur_point := pts[i]
		var next_point := pts[(i + 1) % num]
		
		var max_bevel_back : float = min(0.5 * prev_point.distance_to(cur_point), bevel_size)
		var max_bevel_forward : float = min(0.5 * next_point.distance_to(cur_point), bevel_size) 
		
		var point_back := cur_point + (prev_point - cur_point).normalized() * max_bevel_back
		var point_forward := cur_point + (next_point - cur_point).normalized() * max_bevel_forward
		
		points.append(point_back)
		points.append(point_forward)
	return points 
