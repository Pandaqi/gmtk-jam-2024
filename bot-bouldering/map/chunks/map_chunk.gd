class_name MapChunk extends Node2D

@export var wall_scene : PackedScene
@export var obstacle_scene : PackedScene
@export var map_data : MapData

var index := 0

func generate(chunk_size:Vector2) -> void:
	var num_walls := Global.config.map_chunk_num_walls.rand_int()
	var rot_subdiv := Global.config.obstacle_rotation_subdiv
	for i in range(num_walls):
		var w = wall_scene.instantiate()
		w.set_position( get_random_position(chunk_size) )
		
		var rand_rot := randf() * 2 * PI
		rand_rot = floor(rand_rot / rot_subdiv) * rot_subdiv
		w.set_rotation(rand_rot)
		add_child(w)
	
	var num_obstacles := Global.config.map_chunk_num_obstacles.rand_int()
	for i in range(num_obstacles):
		var w = obstacle_scene.instantiate()
		w.set_position( get_random_position(chunk_size) )
		add_child(w)
		w.set_type(map_data.all_obstacles.pick_random())

func kill() -> void:
	self.queue_free()

func get_random_position(size:Vector2) -> Vector2:
	return Vector2(randf() - 0.5, -randf()) * size
