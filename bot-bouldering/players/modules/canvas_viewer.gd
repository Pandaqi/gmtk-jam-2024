class_name ModuleCanvasViewer extends Node2D

@export var paper_follower : ModulePaperFollower

var canvas_bounds : Rect2

# @TODO: this is WRONG now after the recent changes for v2
func _physics_process(dt:float) -> void:
	var size := paper_follower.follow_speed * Vector2.ONE
	canvas_bounds = Rect2(-0.5*size, size)
	queue_redraw()

func _draw() -> void:
	draw_rect(canvas_bounds, Color(1,1,1,0.33), true)
