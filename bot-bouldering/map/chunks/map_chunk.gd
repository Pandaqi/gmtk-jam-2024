class_name MapChunk extends Node2D

@export var wall_scene : PackedScene
@export var obstacle_scene : PackedScene
@export var map_data : MapData

var index := 0

func generate(chunk_size:Vector2) -> void:
	var num_walls := 5
	for i in range(num_walls):
		var w = wall_scene.instantiate()
		w.set_position( get_random_position(chunk_size) )
		w.set_rotation( randf() * 2 * PI)
		add_child(w)
	
	var num_spikes := 5
	for i in range(num_spikes):
		var w = obstacle_scene.instantiate()
		w.set_position( get_random_position(chunk_size) )
		add_child(w)
		w.set_type(map_data.all_obstacles.pick_random())

func kill() -> void:
	self.queue_free()

func get_random_position(size:Vector2) -> Vector2:
	return Vector2(randf() - 0.5, -randf()) * size
