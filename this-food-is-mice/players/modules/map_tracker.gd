class_name ModuleMapTracker extends Node2D

signal obstacle_entered(o:Obstacle)
signal obstacle_exited(o:Obstacle)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Obstacle: return
	obstacle_entered.emit(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is not Obstacle: return
	obstacle_exited.emit(body)
