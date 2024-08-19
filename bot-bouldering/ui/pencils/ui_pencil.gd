class_name UIPencil extends Node2D

var type : PencilType
@onready var sprite : Sprite2D = $Sprite2D
@onready var tooltip : ModuleTooltip = $Tooltip

var base_alpha := 1.0
var focused := false

func set_data(tp:PencilType, is_available:bool) -> void:
	type = tp
	
	tooltip.set_desc(tp.desc)
	sprite.set_frame(tp.frame)
	
	base_alpha = 1.0 if is_available else 0.4
	sprite.modulate.a = base_alpha

func set_focus(val:bool) -> void:
	if focused == val: return
	
	focused = val
	
	z_index = 100 if focused else 0
	
	var tw := get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	if val:
		tw.tween_property(self, "scale", Vector2.ONE*1.4, 0.2)
		tw.tween_property(self, "scale", Vector2.ONE*1.3, 0.1)
		tw.parallel().tween_property(self, "modulate:a", 1.0 * base_alpha, 0.1)
	else:
		tw.tween_property(self, "scale", Vector2.ONE*1.4, 0.1)
		tw.tween_property(self, "scale", Vector2.ONE*1.0, 0.2)
		tw.parallel().tween_property(self, "modulate:a", 0.4 * base_alpha, 0.2)
