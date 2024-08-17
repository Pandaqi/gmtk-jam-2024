class_name ModuleTurn extends Node2D

@onready var entity : PlayerPaper = get_parent()
@onready var timer : Timer = $Timer
@export var pencils : ModulePencils

var time_scale := 1.0
var active := false

signal turn_started()
signal turn_timed_out()
signal turn_over()

func activate() -> void:
	pencils.pencils_exhausted.connect(on_all_lines_drawn)
	timer.timeout.connect(on_timer_timeout)
	entity.reset.connect(on_reset)
	active = false

func on_reset() -> void:
	start_timer()
	turn_started.emit()
	active = true

func end_turn() -> void:
	if not active: return
	
	active = false
	stop_timer()
	turn_over.emit()

func start_timer() -> void:
	timer.stop()
	timer.wait_time = Global.config.turn_duration * time_scale
	timer.start()

func stop_timer() -> void:
	timer.stop()

func get_time_left() -> float:
	return timer.time_left

func on_timer_timeout() -> void:
	end_turn()

func on_all_lines_drawn() -> void:
	end_turn()

func change_time_scale(ts:float) -> void:
	time_scale = clamp(time_scale * ts, 0.25, 4.0)
