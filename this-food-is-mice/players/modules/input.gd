class_name ModuleInput extends Node2D

signal moved(vec:Vector2, dt:float)
signal button_pressed(pressed:bool)

func _process(dt:float) -> void:
	var h := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var v := Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	moved.emit(Vector2(h,v), dt)

func _input(ev:InputEvent) -> void:
	if ev.is_action_released("ui_accept"):
		button_pressed.emit(false)
	if ev.is_action_pressed("ui_accept"):
		button_pressed.emit(true)
