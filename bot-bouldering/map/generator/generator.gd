class_name MapGenerator extends Node2D

@export var map_data : MapData
@export var obstacle_scene : PackedScene
@export var wall_scene : PackedScene
@export var finish_type : ObstacleType
@export var star_type : ObstacleType

var num_stars := 0

func generate() -> void:
	var all_chunks : Array[Vector2] = []
	for y in range(Global.config.mountain_size_in_chunks.y):
		for x in range(Global.config.mountain_size_in_chunks.x):
			all_chunks.append(Vector2(x,y))
	
	# place the stars to collect
	all_chunks.shuffle()
	num_stars = Global.config.mapgen_num_star_bounds.rand_int()
	var star_chunks : Array[Vector2] = []
	for i in range(num_stars):
		star_chunks.append(all_chunks.pop_back())
	
	# place finish at the top
	var finish : Obstacle = obstacle_scene.instantiate()
	finish.set_position( get_random_position_at_top() )
	add_child(finish)
	finish.set_type(finish_type)
	
	map_data.finish_node = finish
	
	# step through mountain from bottom to top
	# for each "chunk", add something (wall or obstacle)
	for y in range(Global.config.mountain_size_in_chunks.y):
		for x in range(Global.config.mountain_size_in_chunks.x):
			var pos_chunk := Vector2(x,y)
			var is_star := array_has_vector(star_chunks, pos_chunk)
			var random_pos := get_random_position_in_chunk(pos_chunk)
			var place_obstacle := randf() <= 0.25 or is_star
			if place_obstacle:
				place_obstacle_at(random_pos, is_star)
				continue
			place_wall_at(random_pos) 

func array_has_vector(list:Array[Vector2], target:Vector2) -> bool:
	for elem in list:
		if elem.is_equal_approx(target): return true
	return false

func place_wall_at(pos:Vector2) -> void:
	var node : ObstacleWall = wall_scene.instantiate()
	node.set_position(pos)
	
	var rot_subdiv := Global.config.obstacle_rotation_subdiv
	var rand_rot := randf() * 2 * PI
	rand_rot = floor(rand_rot / rot_subdiv) * rot_subdiv
	node.set_rotation(rand_rot)
	
	add_child(node)

func place_obstacle_at(pos:Vector2, is_star:bool) -> void:
	var node : Obstacle = obstacle_scene.instantiate()
	node.set_position(pos)
	add_child(node)
	
	var rand_type : ObstacleType = map_data.all_obstacles.pick_random()
	if is_star: rand_type = star_type
	node.set_type(rand_type)

func get_random_position_in_chunk(pos:Vector2) -> Vector2:
	var top_left := Vector2(pos.x,-(pos.y+1)) * map_data.chunk_size
	var bounds := Rect2(top_left, map_data.chunk_size)
	return get_random_position_in_rect(bounds)

func get_random_position_in_rect(bds:Rect2) -> Vector2:
	return bds.position + Vector2(randf(), randf()) * bds.size

func get_random_position_at_top() -> Vector2:
	var bds := map_data.bounds
	return bds.position + Vector2(randf(), 0) * bds.size
