class_name UIInkBarPencil extends Node2D

var type : PencilType
var height : float
var width := 32.0

func set_height(h:float) -> void:
	height = h
	queue_redraw()

func _draw() -> void:
	var bounds := Rect2(-0.5*width, -height, width, height)
	draw_rect(bounds, type.color, true)
