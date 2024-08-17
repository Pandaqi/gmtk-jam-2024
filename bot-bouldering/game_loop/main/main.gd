extends Node2D

@onready var map : Map = $Map
@onready var players : Players = $Players
@onready var state : State = $State

func _ready() -> void:
	state.activate()
	map.activate()
	players.activate()
