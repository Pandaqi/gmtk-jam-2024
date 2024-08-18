class_name ModuleMover extends Node2D

@onready var entity : CharacterBody2D = get_parent()
@export var input : ModuleInput

var prev_vec := Vector2.ZERO

func activate() -> void:
	input.moved.connect(on_moved)

func on_moved(vec:Vector2, _dt:float) -> void:
	var speed := get_speed()
	entity.velocity = vec * speed
	entity.move_and_slide()
	
	if vec.length() > 0.003:
		prev_vec = vec

func get_speed() -> float:
	return Global.config.scale(Global.config.player_move_speed)
