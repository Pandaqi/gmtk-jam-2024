extends Node2D

@onready var map : Map = $Map
@onready var mice : Mice = $Mice
@onready var players : Players = $Players
@onready var progression : Progression = $Progression

func _ready() -> void:
	map.activate()
	mice.activate()
	players.activate()
	progression.activate()
