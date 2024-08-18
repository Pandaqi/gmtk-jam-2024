class_name ModuleBiteGiver extends Node2D

@export var mover : ModuleMoverMouse
@onready var entity : Mouse = get_parent()

signal bit(o:Obstacle)

func activate() -> void:
	mover.target_reached.connect(on_target_reached)

func on_target_reached(o:Obstacle) -> void:
	o.bite_receiver.take_bite(self)
	bit.emit(o)
