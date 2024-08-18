extends Node2D

@onready var map : MapStatic = $Map
@onready var players : Players = $Players
@onready var progression : Progression = $Progression

func _ready() -> void:
	progression.activate()
	map.activate()
	players.activate()
