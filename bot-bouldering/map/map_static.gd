class_name MapStatic extends Node2D

var chunk_size : Vector2
@export var map_data : MapData
@export var prog_data : ProgressionData
@export var progression : Progression

@onready var gen : MapGenerator = $Generator
@onready var env : MapEnvironment = $Environment
@onready var clouds : Clouds = $Clouds

@onready var cracks := $Cracks
@export var crack_scene : PackedScene

@export var grass_scene : PackedScene

var polygon_edge : Array[Vector2] = []
var polygon_edge_shrunk : Array[Vector2] = []
var edge_lines : Array[WobblyLineGenerator] = []

func activate() -> void:
	determine_config()
	prepare_first_level_if_needed()
	gen.generate()
	add_decorations()
	clouds.activate()
	queue_redraw()

func determine_config() -> void:
	var orig_size := Global.config.mountain_size_in_chunks
	var max_size := Global.config.max_mountain_size
	var ms := orig_size
	
	# we really only want the mountain to become taller, but we shouldn't neglect width too much, so it kind of lags behind
	ms.y += Global.config.mountain_size_increase_per_level * prog_data.level
	ms.y = clamp(round(ms.y), orig_size.y, max_size.y)
	if ms.x < 0.5*ms.y:
		ms.x = ceil(0.5*ms.y)
	
	ms.x = clamp(round(ms.x), orig_size.x, max_size.x)
	
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
	if prog_data.level > 0 and not progression.should_debug_level(): return
	
	map_data.reset()
	for type in map_data.obstacles_starting:
		map_data.unlock(type)
	
	progression.replay_debug_levels_if_needed()

func add_decorations() -> void:
	var bds := map_data.bounds
	var size_increase_at_bottom := Global.config.mountain_size_increase_at_bottom
	
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
	
	# an inner polygon to get a sort of border around the edge
	polygon_edge_shrunk = []
	for line in edge_lines:
		line.regenerate(0.5)
		line.scale(0.9765)
		polygon_edge_shrunk += line.points.duplicate(false)
	
	# random cracks throughout the mountain
	var num_cracks := 32
	for i in range(num_cracks):
		var rand_pos := map_data.bounds.position + map_data.bounds.size * Vector2(randf(), randf())
		var c = crack_scene.instantiate()
		c.set_position(rand_pos)
		c.set_scale(Vector2(randf_range(0.2, 0.45), randf_range(0.2, 0.45)))
		c.set_rotation(randf_range(-0.1, 0.1) * PI)
		c.modulate = Global.config.mountain_color_dark
		c.modulate.a = randf_range(0.33, 0.85)
		cracks.add_child(c)
	
	# some overlapping grass at the bottom edge to anchor the mountain even more
	var num_tiny_grass := 32
	for i in range(num_tiny_grass):
		var g = grass_scene.instantiate()
		var rand_pos := corners[3] + (corners[2] - corners[3]) * Vector2(randf(), 0)
		g.set_position(rand_pos)
		g.modulate = Global.config.mountain_anchor_color
		g.set_scale(randf_range(0.1, 0.3)*Vector2.ONE)
		g.set_rotation(randf_range(-0.25, 0.25) * PI)
		add_child(g)

func _draw() -> void:
	draw_polygon(polygon_edge, [Global.config.mountain_color_dark]) 
	draw_polygon(polygon_edge_shrunk, [Global.config.mountain_color_light]) 
