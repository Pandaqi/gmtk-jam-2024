extends Node2D

@onready var map : Map = $Map
@onready var mice : Mice = $Mice
@onready var players : Players = $Players
@onready var progression : Progression = $Progression
@onready var ui : UI = $UI
@onready var tutorial : Tutorial = $Tutorial

func _ready() -> void:
	ui.activate()
	progression.activate()
	map.activate()
	mice.activate()
	players.activate()
	tutorial.activate()
	
	tutorial.show_start_explanation()
	progression.start_game()
