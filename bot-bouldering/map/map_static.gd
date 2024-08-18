class_name MapStatic extends Node2D

var chunk_size : Vector2
@export var map_data : MapData
@onready var gen : MapGenerator = $Generator

func activate() -> void:
	determine_config()
	gen.generate()
	queue_redraw()

func determine_config() -> void:
	var ms := Global.config.mountain_size_in_chunks
	var chunk_pixels := Global.config.scale_bounds(Global.config.map_chunk_pixel_size_bounds)
	
	chunk_size = Vector2(chunk_pixels.rand_float(), chunk_pixels.rand_float())
	print(chunk_pixels)
	print(chunk_size)
	var map_bounds := Rect2(
		0, -chunk_size.y*ms.y, 
		chunk_size.x*ms.x, chunk_size.y*ms.y
	)
	map_data.chunk_size = chunk_size
	map_data.bounds = map_bounds
	
	map_data.generator = gen


func _draw() -> void:
	draw_rect(map_data.bounds, Color(0.5, 0.5, 0.5), true, -1, true)
