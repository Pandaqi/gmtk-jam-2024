class_name UIPencil extends Node2D

var type : PencilType
@onready var sprite : Sprite2D = $Sprite2D

func set_data(tp:PencilType, is_available:bool) -> void:
	type = tp
	
	sprite.set_frame(tp.frame)
	
	var alpha := 1.0 if is_available else 0.4
	sprite.modulate.a = alpha

func set_focus(val:bool) -> void:
	var sc := Vector2.ONE*1.2 if val else Vector2.ONE
	sprite.set_scale(sc)
