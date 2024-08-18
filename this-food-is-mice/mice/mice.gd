class_name Mice extends Node2D

@export var mouse_scene : PackedScene
@export var map_data : MapData

@onready var timer : Timer = $Timer

func activate() -> void:
	timer.timeout.connect(on_timer_timeout)
	on_timer_timeout()

func restart_timer() -> void:
	timer.wait_time = Global.config.mouse_spawn_tick
	timer.start()

func on_timer_timeout() -> void:
	refresh()
	restart_timer()

func get_all() -> Array[Node]:
	return get_tree().get_nodes_in_group("Mice")

func refresh() -> void:
	var num := get_all().size()
	var bounds := Global.config.mouse_spawn_bounds
	if num >= bounds.end: return
	
	while num < bounds.start:
		spawn()
		num += 1
	
	if randf() <= Global.config.mouse_spawn_prob and num < bounds.end:
		spawn()

func spawn() -> void:
	var m : Mouse = mouse_scene.instantiate()
	m.set_position(map_data.get_random_edge_position())
	map_data.map_node.layers.add_to_layer("entities", m)
	m.activate()
