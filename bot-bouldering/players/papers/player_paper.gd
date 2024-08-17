class_name PlayerPaper extends Node2D

@export var player : Player
@export var player_bot : PlayerBot

@export var pencils : ModulePencils
@export var drawer : ModuleDrawer
@export var zoomer : ModuleZoomer
@export var ui : ModulePaperUI
@export var turn : ModuleTurn

signal done()
signal reset()

func _ready() -> void:
	pencils.pencils_exhausted.connect(on_all_lines_drawn)
	player_bot.paper_follower.done.connect(on_bot_done)
	
	ui.activate()
	pencils.activate()
	drawer.activate()
	turn.activate()
	zoomer.activate()
	
	on_bot_done()

func on_all_lines_drawn() -> void:
	done.emit()

func on_bot_done() -> void:
	reset.emit()
