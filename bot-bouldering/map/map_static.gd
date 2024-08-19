class_name MapStatic extends Node2D

var chunk_size : Vector2
@export var map_data : MapData
@export var prog_data : ProgressionData

@onready var gen : MapGenerator = $Generator
@onready var env : MapEnvironment = $Environment

var polygon_edge : Array[Vector2] = []
var polygon_edge_shrunk : Array[Vector2] = []
var edge_lines : Array[WobblyLineGenerator] = []

func activate() -> void:
	determine_config()
	prepare_first_level_if_needed()
	gen.generate()
	add_decorations()
	queue_redraw()

func determine_config() -> void:
	var orig_size := Global.config.mountain_size_in_chunks
	var max_size := Global.config.max_mountain_size
	var ms := orig_size
	
	# we really only want the mountain to become taller, but we shouldn't neglect width too much, so it kind of lags behind
	ms.y += Global.config.mountain_size_increase_per_level * prog_data.level
	ms.y = clamp(ms.y, orig_size.y, max_size.y)
	if ms.x < 0.5*ms.y:
		ms.x = ceil(0.5*ms.y)
	
	ms.x = clamp(ms.x, orig_size.x, max_size.x)
	
	var chunk_pixels := Global.config.scale_bounds(Global.config.map_chunk_pixel_size_bounds)
	
	chunk_size = Vector2(chunk_pixels.rand_float(), chunk_pixels.rand_float())
	var map_bounds := Rect2(
		-0.5*chunk_size.x*ms.x, -chunk_size.y*ms.y, 
		chunk_size.x*ms.x, chunk_size.y*ms.y
	)
	map_data.chunk_size = chunk_size
	map_data.mountain_size_in_chunks = ms
	map_data.bounds = map_bounds
	
	map_data.generator = gen
	env.update(map_bounds)

func prepare_first_level_if_needed() -> void:
	if prog_data.level > 0: return
	
	map_data.reset()
	for type in map_data.obstacles_starting:
		map_data.unlock(type)

func add_decorations() -> void:
	var bds := map_data.bounds
	var size_increase_at_bottom := 0.25
	
	var corners : Array[Vector2] = [
		bds.position,
		bds.position + Vector2(bds.size.x, 0),
		bds.position + bds.size*Vector2(1.0+size_increase_at_bottom, 1),
		bds.position*Vector2(1.0+2*size_increase_at_bottom, 1) + Vector2(0, bds.size.y)
	]
	
	polygon_edge = []
	edge_lines = []
	for i in range(4):
		var start_point := corners[i]
		var end_point := corners[(i + 1) % 4]
		
		# bottom edge is flat
		if i == 2:
			polygon_edge += [start_point, end_point]
			continue
		
		var line := WobblyLineGenerator.new()
		line.generate(start_point, end_point)
		edge_lines.append(line)
		polygon_edge += line.points.duplicate(false)
	
	map_data.polygon_edge = polygon_edge
		
	polygon_edge_shrunk = []
	for line in edge_lines:
		line.regenerate(0.5)
		line.scale(0.9765)
		polygon_edge_shrunk += line.points.duplicate(false)
	

func _draw() -> void:
	draw_polygon(polygon_edge, [Global.config.mountain_color_dark]) 
	draw_polygon(polygon_edge_shrunk, [Global.config.mountain_color_light]) 
