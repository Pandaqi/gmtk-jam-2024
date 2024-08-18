class_name CameraPlayer extends Camera2D

const MOVE_SPEED := 8.0
const ZOOM_SPEED := 8.0

var min_bounds_pos : Vector2
var max_bounds_pos : Vector2

var zoom_scale_from_players := 1.0

func _process(dt:float) -> void:
	var bounds : Rect2 = get_bounds()
	if not bounds: return
	
	var target_position := bounds.get_center()

	var vp_size := get_viewport_rect().size - 2*Global.config.camera_edge_margin
	var desired_size := bounds.size
	var min_size := Global.config.scale_vector(Global.config.camera_min_size)
	desired_size.x = max(desired_size.x, min_size.x)
	desired_size.y = max(desired_size.y, min_size.y)
	
	var ratios := vp_size / desired_size
	
	var target_zoom : Vector2 = min(ratios.x, ratios.y) * Vector2.ONE
	target_zoom *= zoom_scale_from_players
	
	var move_factor := MOVE_SPEED*dt
	var zoom_factor := ZOOM_SPEED*dt
	set_position(get_position().lerp(target_position, move_factor))
	set_zoom(get_zoom().lerp(target_zoom, zoom_factor))

func get_bounds() -> Rect2:
	# determine smallest rectangle that fits around the players
	min_bounds_pos = Vector2(INF, INF)
	max_bounds_pos = Vector2(-INF, -INF)
	
	for p in get_tree().get_nodes_in_group("PlayerBots"):
		var rect = p.get_bounds()
		expand_bounds(rect)
		zoom_scale_from_players = clamp(1.0 - p.paper.zoomer.get_scale_ratio(), 0.1, 1.0)

	return Rect2(min_bounds_pos.x, min_bounds_pos.y, max_bounds_pos.x - min_bounds_pos.x, max_bounds_pos.y - min_bounds_pos.y)

func expand_bounds(rect:Rect2) -> void:
	min_bounds_pos.x = min(min_bounds_pos.x, rect.position.x)
	min_bounds_pos.y = min(min_bounds_pos.y, rect.position.y)
	max_bounds_pos.x = max(max_bounds_pos.x, rect.position.x + rect.size.x)
	max_bounds_pos.y = max(max_bounds_pos.y, rect.position.y + rect.size.y)
