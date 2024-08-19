class_name MapGenerator extends Node2D

@export var map_data : MapData
@export var prog_data : ProgressionData
@export var obstacle_scene : PackedScene
@export var wall_scene : PackedScene
@export var finish_type : ObstacleType
@export var star_type : ObstacleType

var num_stars := 0
var num_finishes := 0

func generate() -> void:
	var all_chunks : Array[Vector2] = []
	for y in range(map_data.mountain_size_in_chunks.y):
		for x in range(map_data.mountain_size_in_chunks.x):
			all_chunks.append(Vector2(x,y))
	all_chunks.shuffle()
	
	# place finishes; always one at top, the others don't matter
	var top_chunk := Vector2.ZERO
	for chunk in all_chunks:
		if chunk.y < (map_data.mountain_size_in_chunks.y - 1): continue
		top_chunk = chunk
		break
	
	map_data.finish_node = place_obstacle_at_chunk(top_chunk, finish_type)
	
	num_finishes = Global.config.mapgen_num_finishes.rand_int()
	if prog_data.level <= 0: num_finishes = 1
	for i in range(num_finishes - 1):
		place_obstacle_at_chunk(all_chunks.pop_back(), finish_type)
	
	# place the stars to collect
	num_stars = Global.config.mapgen_num_star_bounds.rand_int()
	for i in range(num_stars):
		place_obstacle_at_chunk(all_chunks.pop_back(), star_type)

	# step through mountain
	# for each remaining "chunk", add something (wall or obstacle)
	for chunk in all_chunks:
		var place_obstacle := randf() <= 0.25
		if place_obstacle:
			place_obstacle_at_chunk(chunk)
			continue
		place_wall_at_chunk(chunk) 

func array_has_vector(list:Array[Vector2], target:Vector2) -> bool:
	for elem in list:
		if elem.is_equal_approx(target): return true
	return false

func place_wall_at_chunk(ch:Vector2) -> ObstacleWall:
	var rand_pos := get_random_position_in_chunk(ch)
	return place_wall_at(rand_pos)

func place_wall_at(pos:Vector2) -> ObstacleWall:
	var node : ObstacleWall = wall_scene.instantiate()
	node.set_position(pos)
	
	var rot_subdiv := Global.config.obstacle_rotation_subdiv
	var rand_rot := randf() * 2 * PI
	rand_rot = floor(rand_rot / rot_subdiv) * rot_subdiv
	node.set_rotation(rand_rot)
	
	add_child(node)
	return node

func place_obstacle_at_chunk(ch:Vector2, forced_type:ObstacleType = null) -> Obstacle:
	var rand_pos := get_random_position_in_chunk(ch)
	return place_obstacle_at(rand_pos, forced_type)

func place_obstacle_at(pos:Vector2, forced_type:ObstacleType = null) -> Obstacle:
	var node : Obstacle = obstacle_scene.instantiate()
	node.set_position(pos)
	add_child(node)
	
	var rand_type : ObstacleType = map_data.obstacles_available.pick_random()
	if forced_type: rand_type = forced_type
	node.set_type(rand_type)
	return node

func get_random_position_in_chunk(pos:Vector2) -> Vector2:
	var top_left_x := map_data.bounds.position.x + pos.x * map_data.chunk_size.x
	var top_left_y := -(pos.y + 1) * map_data.chunk_size.y
	var top_left := Vector2(top_left_x, top_left_y)
	var bounds := Rect2(top_left, map_data.chunk_size)
	return get_random_position_in_rect(bounds)

func get_random_position_in_rect(bds:Rect2) -> Vector2:
	return bds.position + Vector2(randf(), randf()) * bds.size

func get_random_position_at_top() -> Vector2:
	var bds := map_data.bounds
	return bds.position + Vector2(randf(), 0) * bds.size
