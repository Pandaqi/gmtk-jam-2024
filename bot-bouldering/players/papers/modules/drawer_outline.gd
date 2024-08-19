class_name ModuleDrawerOutline extends Node2D

@export var zoomer : ModuleZoomer

func _draw() -> void:
	draw_rect(zoomer.bounds, Color(0.1, 0.1, 0.1), false, 2, true)
