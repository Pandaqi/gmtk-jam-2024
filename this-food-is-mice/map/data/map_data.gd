extends Resource
class_name MapData

@export var all_tools : Array[ToolType] = []

var map_node : Map
var bounds : Rect2

func get_bounds() -> Rect2:
	return bounds

func query_position(params:Dictionary = {}) -> Vector2:
	var bad_pos = true
	var pos : Vector2
	
	var avoid : Array = params.avoid if ("avoid" in params) else []
	var dist : float = params.dist if ("dist" in params) else 0
	var edge_margin : Vector2 = params.edge_margin if ("edge_margin" in params) else Vector2.ZERO
	
	var num_tries := 0
	var max_tries := 300
	
	while bad_pos:
		bad_pos = false
		pos = get_random_position(edge_margin)
		
		for node in avoid:
			var temp_dist : float = node.global_position.distance_to(pos)
			if temp_dist > dist: continue
			bad_pos = true
			break 
		
		num_tries += 1
		if num_tries >= max_tries:
			break
	
	return pos

func get_random_position(edge_margin := Vector2.ZERO) -> Vector2:
	return bounds.position + edge_margin + Vector2(randf(), randf()) * (bounds.size - 2*edge_margin)

func get_random_edge_position() -> Vector2:
	var is_horiz := randf() <= 0.5
	var base_pos := bounds.position
	var offset := Vector2.ZERO
	if is_horiz:
		if randf() <= 0.5: offset = Vector2(0, randf()*bounds.size.y)
		else: offset = Vector2(bounds.size.x, randf()*bounds.size.y)
	else:
		if randf() <= 0.5: offset = Vector2(randf()*bounds.size.x, 0)
		else: offset = Vector2(randf()*bounds.size.x, bounds.size.y)
	return base_pos + offset
