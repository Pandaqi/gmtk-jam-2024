class_name ModuleTurn extends Node2D

@onready var entity : PlayerPaper = get_parent()
@onready var timer : Timer = $Timer

var base_time := 30.0
var time_scale := 1.0
var active := false

signal turn_started()
signal turn_timed_out()
signal turn_over()

func activate() -> void:
	entity.reset.connect(on_reset)
	entity.done.connect(on_done)
	timer.timeout.connect(on_timer_timeout)

func on_reset() -> void:
	start_timer()
	turn_started.emit()
	active = true

func on_done() -> void:
	active = false
	stop_timer()
	turn_over.emit()

func start_timer() -> void:
	timer.wait_time = base_time * time_scale
	timer.start()

func stop_timer() -> void:
	timer.stop()

func get_time_left() -> float:
	return timer.time_left

func on_timer_timeout() -> void:
	turn_timed_out.emit()

func change_time_scale(ts:float) -> void:
	time_scale = clamp(time_scale * ts, 0.25, 4.0)
