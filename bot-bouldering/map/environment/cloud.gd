class_name Cloud extends Node2D

var speed := 1.0
var dir := 1
var exiting := false

@export var map_data : MapData

signal screen_exited(c:Cloud)

func reappear(sp:float, d:int) -> void:
	exiting = false
	speed = sp
	dir = d
	
	set_scale(randf_range(0.2, 2.0) * Vector2.ONE)
	modulate.a = randf_range(0.2, 0.66)

func _process(dt:float) -> void:
	var new_pos := global_position + Vector2.RIGHT*dir*speed*dt
	set_position(new_pos)
	handle_out_of_bounds()

func handle_out_of_bounds() -> void:
	if exiting: return
	
	if dir > 0 and global_position.x > (map_data.bounds.position.x + 4*map_data.bounds.size.x):
		on_exit()
	
	if dir < 0 and global_position.x < (4*map_data.bounds.position.x):
		on_exit()

func on_exit() -> void:
	exiting = true
	var tw := get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(self, "modulate:a", 0.0, 0.1)
	await tw.finished
	screen_exited.emit(self)
