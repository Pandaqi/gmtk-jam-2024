class_name Footsteps extends Node2D

func activate(dur:float) -> void:
	modulate.a = 1.0
	
	var tw := get_tree().create_tween()
	tw.tween_property(self, "modulate:a", 0.0, dur)
	
	await tw.finished
	queue_free()
