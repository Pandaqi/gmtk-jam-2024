class_name ModuleVisualsMouse extends Node2D

@export var body : ModuleBody
@export var mover : ModuleMoverMouse
@onready var sprite : Sprite2D = $Sprite2D

func activate() -> void:
	body.body_changed.connect(on_body_changed)

func _process(_dt:float) -> void:
	sprite.flip_h = mover.prev_vec.x < 0

func on_body_changed(new_size:Vector2) -> void:
	var new_scale := new_size.x / Global.config.sprite_size * Vector2.ONE
	sprite.set_scale(new_scale)
