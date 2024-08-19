extends Node2D

@onready var map : MapStatic = $Map
@onready var players : Players = $Players
@onready var progression : Progression = $Progression
@onready var tooltips : Tooltips = $Tooltips
@onready var tutorial : Tutorial = $Tutorial

func _ready() -> void:
	progression.activate()
	map.activate()
	players.activate()
	tooltips.activate()
	tutorial.activate()
	
	if progression.is_first_level():
		tutorial.appear(true)
