class_name Players extends Node2D

@export var player_scene : PackedScene
@export var map_data : MapData

func activate() -> void:
	spawn()

func spawn() -> void:
	var p : Player = player_scene.instantiate()
	p.set_position(map_data.query_position())
	map_data.map_node.layers.add_to_layer("entities", p)
	p.activate()
	
	print("Placed player")
	print(p.global_position)
	
