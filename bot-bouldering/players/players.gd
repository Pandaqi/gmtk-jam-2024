class_name Players extends Node2D

@export var player_scene : PackedScene
@export var papers_layer : CanvasLayer

func activate() -> void:
	var p : Player = player_scene.instantiate()
	add_child(p)
	p.activate(papers_layer)
