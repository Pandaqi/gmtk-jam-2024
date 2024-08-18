class_name ModuleVisualsMouse extends Node2D

@export var body : ModuleBody
@onready var sprite : Sprite2D = $Sprite2D

func activate() -> void:
	body.body_changed.connect(on_body_changed)

func on_body_changed(new_size:Vector2) -> void:
	var new_scale := new_size / Global.config.sprite_size
	sprite.set_scale(new_scale)
