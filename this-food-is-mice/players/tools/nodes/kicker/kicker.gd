class_name ToolKicker extends ToolNode

@onready var area : Area2D = $Area2D

func on_button_pressed(pressed:bool) -> void:
	super.on_button_pressed(pressed)
	if pressed:
		kick_away_nearby_mice()

# @TODO: some clear blast effect or radius tween or whatever
func kick_away_nearby_mice() -> void:
	var force := Global.config.scale(Global.config.tool_knockback_force)
	for body in area.get_overlapping_bodies():
		if body is not Mouse: continue
		body.mover.knockback(global_position, force)
