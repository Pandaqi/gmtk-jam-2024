class_name ModuleCursor extends Node2D

var is_pressed := false

@export var zoomer : ModuleZoomer
@export var turn : ModuleTurn
@onready var label_debug : Label = $LabelDebug

signal pressed(c:ModuleCursor)
signal moved(pos:Vector2)

func _input(ev:InputEvent) -> void:
	if not turn.active: return
	
	if ev is InputEventMouseButton:
		if ev.button_index == 1:
			on_click(ev.pressed)
	
	if ev is InputEventMouseMotion:
		on_mouse_move()

func get_relative_position() -> Vector2:
	return zoomer.get_relative_position_on_paper(global_position)

func on_mouse_move() -> void:
	var pos := get_global_mouse_position()
	if zoomer.is_out_of_bounds(pos): 
		if is_pressed: on_click(false)
		return
	global_position = pos
	
	if not is_pressed: return
	moved.emit(zoomer.get_relative_position_on_paper(pos))

func on_click(p:bool) -> void:
	is_pressed = p
	label_debug.set_text("YES" if is_pressed else "NO")
	pressed.emit(self)
