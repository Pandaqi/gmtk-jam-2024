extends Resource
class_name MapData

@export var all_tools : Array[ToolType] = []

var map_node : Map
var bounds : Rect2

func get_bounds() -> Rect2:
	return bounds

func query_position(params:Dictionary = {}) -> Vector2:
	return get_random_position()

func get_random_position() -> Vector2:
	return bounds.position + Vector2(randf(), randf()) * bounds.size

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
