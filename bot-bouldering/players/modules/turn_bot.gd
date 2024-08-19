class_name ModuleTurnBot extends Node2D

@onready var entity : PlayerBot = get_parent()
@export var paper_follower : ModulePaperFollower

var active := false

signal turn_started()
signal turn_over()

func activate() -> void:
	entity.reset.connect(on_reset)
	paper_follower.done.connect(on_follow_done)

func on_reset() -> void:
	start_turn()

func start_turn() -> void:
	active = true
	turn_started.emit()

func end_turn() -> void:
	if not active: return
	turn_over.emit()

func on_follow_done() -> void:
	end_turn()
