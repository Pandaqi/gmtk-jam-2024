extends Resource
class_name MapData

@export var all_obstacles : Array[ObstacleType] = []
var bounds : Rect2
var chunk_size : Vector2

func get_chunk_from_y(val:float) -> int:
	return floor(abs(val) / chunk_size.y)

func is_above_mountain_top(pos:Vector2) -> bool:
	var chunk := get_chunk_from_y(pos.y)
	return chunk > Global.config.mountain_size_in_chunks.y
