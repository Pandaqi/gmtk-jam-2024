class_name ToolRepairer extends ToolNode

@onready var area : Area2D = $Area2D

func set_active(val:bool) -> void:
	super.set_active(val)
	prevent_switching = active
	if active:
		recheck_bodies()

func recheck_bodies() -> void:
	for body in area.get_overlapping_bodies():
		_on_area_2d_body_entered(body)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not active: return
	if body is not Obstacle: return
	body.bite_receiver.heal()
