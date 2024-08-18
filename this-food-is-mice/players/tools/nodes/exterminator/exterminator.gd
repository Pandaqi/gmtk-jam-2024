class_name ToolExterminator extends ToolNode

@onready var area : Area2D = $Area2D

func on_button_pressed(pressed:bool) -> void:
	super.on_button_pressed(pressed)
	
	if not pressed:
		kill_closest_mouse()

# @TODO: some clear blast effect or radius tween or whatever
func kill_closest_mouse() -> void:
	var closest_mouse : Mouse = null
	var closest_dist := INF
	for body in area.get_overlapping_bodies():
		if body is not Mouse: continue
		var dist := global_position.distance_to(body.global_position)
		if dist >= closest_dist: continue
		closest_dist = dist
		closest_mouse = body
	
	if not closest_mouse: return
	closest_mouse.kill()
