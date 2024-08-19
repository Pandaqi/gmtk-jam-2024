class_name MapEnvironment extends Node2D

var grass_bounds:Rect2

func update(bounds:Rect2) -> void:
	var mult_x := 10
	var mult_y := 0.75 * Global.config.sprite_size
	var new_anchor := Vector2(bounds.position.x * mult_x, bounds.position.y + bounds.size.y - mult_y)
	var new_size := Vector2(bounds.size.x * 2 * mult_x, 10 * mult_y)
	grass_bounds = Rect2(new_anchor, new_size)
	queue_redraw()

func _draw() -> void:
	draw_rect(grass_bounds, Color(0.5, 1, 0.5), true, -1, false)
