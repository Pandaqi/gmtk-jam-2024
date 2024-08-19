class_name ModuleTooltip extends Node2D

var text := ""
@export var world_to_screen := false

func set_desc(txt:String) -> void:
	text = txt

func get_anchor_position() -> Vector2:
	if world_to_screen:
		return (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()) * global_position
	return global_position

func _on_area_2d_mouse_entered() -> void:
	GSignal.tooltip.emit(true, self)

func _on_area_2d_mouse_exited() -> void:
	GSignal.tooltip.emit(false, self)
