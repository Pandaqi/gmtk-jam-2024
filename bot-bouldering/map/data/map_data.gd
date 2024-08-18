extends Resource
class_name MapData

@export var all_obstacles : Array[ObstacleType] = []
var bounds : Rect2
var chunk_size : Vector2
var finish_node : Obstacle
var generator : MapGenerator

func get_chunk_from_y(val:float) -> int:
	return floor(abs(val) / chunk_size.y)

func is_above_mountain_top(pos:Vector2) -> bool:
	var chunk := get_chunk_from_y(pos.y)
	return chunk > Global.config.mountain_size_in_chunks.y

func get_bounds() -> Rect2:
	return bounds

func convert_line_pos_to_absolute_pos(pos_rel:Vector2) -> Vector2:
	return bounds.position + Vector2(pos_rel.x, pos_rel.y) * bounds.size

func get_player_starting_position() -> Vector2:
	var finish_in_right_half := finish_node.global_position.x > bounds.get_center().x
	var in_left_half := true if finish_in_right_half else false
	if in_left_half:
		return Vector2(bounds.position.x + randf()*0.33*bounds.size.x, 0)
	return Vector2(bounds.position.x + (0.66 + randf()*0.33) * bounds.size.x, 0)
