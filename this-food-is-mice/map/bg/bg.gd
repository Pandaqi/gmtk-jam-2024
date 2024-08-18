extends Node2D

@export var map_data : MapData
var size : Vector2

func activate() -> void:
	size = map_data.bounds.size
	material.set_shader_parameter("real_size", size)
	material.set_shader_parameter("tile_size", 0.33*Global.config.sprite_size)
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(1,1,1), true, -1, true)
