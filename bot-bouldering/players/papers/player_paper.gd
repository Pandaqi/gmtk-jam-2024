class_name PlayerPaper extends Node2D

@export var player : Player
@export var player_bot : PlayerBot

@export var pencils : ModulePencils
@export var drawer : ModuleDrawer
@export var zoomer : ModuleZoomer
@export var ui : ModulePaperUI
@export var turn : ModuleTurn
@export var cursor : ModuleCursor

signal done()
signal reset()

func activate(ui_layer:CanvasLayer) -> void:
	turn.turn_over.connect(on_turn_over)
	player.state_changed.connect(on_state_changed)
	
	ui.activate(ui_layer)
	cursor.activate()
	pencils.activate()
	drawer.activate()
	turn.activate()
	zoomer.activate()
	
	set_rotation(Global.config.canvas_rand_rotation_bounds.rand_float())
	
	get_viewport().size_changed.connect(on_resize)
	on_resize()

func on_resize() -> void:
	var vp_size := get_viewport_rect().size
	set_position(Vector2(0.25, 0.5)*vp_size)

func on_turn_over() -> void:
	done.emit()

func on_state_changed(new_state:Player.PlayerState) -> void:
	if new_state != Player.PlayerState.DRAWING: return
	reset.emit()
