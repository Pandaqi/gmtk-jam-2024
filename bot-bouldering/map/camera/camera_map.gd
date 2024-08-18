class_name CameraMap extends Camera2D

@export var map_data : MapData

const MOVE_SPEED := 8.0
const ZOOM_SPEED := 8.0

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
	
	zoom_scale_from_players = 1.0
	for p in get_tree().get_nodes_in_group("PlayerBots"):
		var zs : float = clamp(1.0 - p.paper.zoomer.get_scale_ratio(), 0.1, 1.0)
		zoom_scale_from_players = min(zs, zoom_scale_from_players)
	
	var target_zoom : Vector2 = min(ratios.x, ratios.y) * Vector2.ONE
	target_zoom *= zoom_scale_from_players
	
	var move_factor := MOVE_SPEED*dt
	var zoom_factor := ZOOM_SPEED*dt
	set_position(get_position().lerp(target_position, move_factor))
	set_zoom(get_zoom().lerp(target_zoom, zoom_factor))

# center on some mid-point between map and paper, hence the position change
func get_bounds() -> Rect2:
	var map_bounds := map_data.get_bounds()
	map_bounds.position -= Vector2(0.25 * get_viewport_rect().size.x / zoom.x, 0)
	return map_bounds
