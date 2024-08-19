class_name Players extends Node2D

@export var player_scene : PackedScene
@export var papers_layer : CanvasLayer
@export var ui_layer : CanvasLayer

var players : Array[Player] = []

func activate() -> void:
	var p : Player = player_scene.instantiate()
	add_child(p)
	players.append(p)
	p.activate(papers_layer, ui_layer)

func get_all() -> Array[Player]:
	return players.duplicate(false)
