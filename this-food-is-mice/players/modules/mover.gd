class_name ModuleMover extends Node2D

@onready var entity : CharacterBody2D = get_parent()
@export var input : ModuleInput
@export var tool_switcher : ModuleToolSwitcher
@export var prog_data : ProgressionData

var prev_vec := Vector2.ZERO
var speed_factor := 1.0

signal moved(vec:Vector2)
signal stopped()

func activate() -> void:
	prog_data.level_changed.connect(on_level_changed)
	input.moved.connect(on_moved)

func on_level_changed(new_level:int) -> void:
	speed_factor = 1.0 + Global.config.player_speed_increase_per_level * new_level

func on_moved(vec:Vector2, _dt:float) -> void:
	var speed := get_speed()
	entity.velocity = vec * speed
	entity.move_and_slide()
	
	if vec.length() > 0.003:
		moved.emit(vec)
		prev_vec = vec
	else:
		stopped.emit()

func get_speed() -> float:
	return Global.config.scale(Global.config.player_move_speed) * speed_factor * tool_switcher.get_speed_factor()
