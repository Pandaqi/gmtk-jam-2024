class_name ModuleVisualsObstacle extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@export var bite_receiver : ModuleBiteReceiver

func activate() -> void:
	bite_receiver.bitten.connect(on_bitten)
	bite_receiver.healed.connect(on_healed)
	sprite.material = sprite.material.duplicate(false)
	update_shader()

func set_tool(tt:ToolType) -> void:
	sprite.material.set_shader_parameter("frame", tt.frame)

func get_center() -> Vector2:
	return sprite.global_position

func get_size() -> Vector2:
	return Global.config.sprite_size * Vector2.ONE

func on_bitten(_num:int) -> void:
	update_shader()

func on_healed() -> void:
	update_shader()

func update_shader() -> void:
	sprite.material.set_shader_parameter("real_size", get_size())
	sprite.material.set_shader_parameter("bite_centers", bite_receiver.bite_centers)
	sprite.material.set_shader_parameter("bite_sizes", bite_receiver.bite_sizes)
