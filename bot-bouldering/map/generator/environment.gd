class_name MapEnvironment extends Node2D

var grass_bounds:Rect2

@export var grass_scene : PackedScene

@onready var mountain_anchor := $MountainAnchor

func update(bounds:Rect2) -> void:
	# the big rectangle for grass
	var mult_x := 15
	var mult_y := 0.75 * Global.config.sprite_size
	var new_anchor := Vector2(bounds.position.x * mult_x, bounds.position.y + bounds.size.y - mult_y)
	var new_size := Vector2(bounds.size.x * mult_x, 10 * mult_y)
	grass_bounds = Rect2(new_anchor, new_size)
	
	# some shadow underneath the mountain to "anchor" it more into the grass.
	var extra_size := (1.0 + 2.0 * Global.config.mountain_size_increase_at_bottom) * 1.67
	var anchor_size := Vector2(bounds.size.x, 0.45*mult_y) * extra_size / Global.config.sprite_size
	mountain_anchor.set_scale(anchor_size)
	mountain_anchor.material.set_shader_parameter("color", Global.config.mountain_anchor_color)
	
	# place big grass along the top line
	var num_big_grass := 72
	for i in range(num_big_grass):
		var g = grass_scene.instantiate()
		var rand_pos := grass_bounds.position + Vector2(randf() * grass_bounds.size.x, 0)
		g.set_position(rand_pos)
		g.modulate = Global.config.grass_color
		g.set_scale(randf_range(1.0, 1.45)*Vector2.ONE)
		g.set_rotation(randf_range(-0.25, 0.25) * PI)
		add_child(g)
	
	# place tiny grass (of different color) within the grass bounds
	var num_tiny_grass := 128
	for i in range(num_tiny_grass):
		var g = grass_scene.instantiate()
		var rand_pos := grass_bounds.position + Vector2(randf(), randf()) * grass_bounds.size
		g.set_position(rand_pos)
		g.modulate = Global.config.grass_color.darkened(randf_range(0.15, 0.35))
		g.set_scale(randf_range(0.2, 0.5)*Vector2.ONE)
		g.set_rotation(randf_range(-0.25, 0.25) * PI)
		add_child(g)
	
	queue_redraw()

func _draw() -> void:
	draw_rect(grass_bounds, Global.config.grass_color, true, -1, false)
