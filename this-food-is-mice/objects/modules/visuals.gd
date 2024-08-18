class_name ModuleVisualsObstacle extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@export var bite_receiver : ModuleBiteReceiver

func activate() -> void:
	bite_receiver.bitten.connect(on_bitten)
	bite_receiver.healed.connect(on_healed)
	sprite.material = sprite.material.duplicate(false)
	update_shader()

func get_center() -> Vector2:
	return sprite.global_position

# @TODO: eventually we'll have the properly sized sprite instead, so we don't scale the Sprite2D to fake it
func get_size() -> Vector2:
	return Global.config.sprite_size * scale * Vector2.ONE

func on_bitten(_num:int) -> void:
	update_shader()

func on_healed() -> void:
	update_shader()

func update_shader() -> void:
	sprite.material.set_shader_parameter("real_size", get_size())
	sprite.material.set_shader_parameter("bite_centers", bite_receiver.bite_centers)
	sprite.material.set_shader_parameter("bite_sizes", bite_receiver.bite_sizes)
