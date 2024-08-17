class_name ModuleDrawer extends Node2D

@export var cursor : ModuleCursor
@export var zoomer : ModuleZoomer
@export var pencils : ModulePencils
@onready var entity = get_parent()

var lines : Array[Line] = []
var total_length := 0.0

var max_length := 2.5

const MAX_DIST_NEW_LINE := 0.1

signal line_started(l:Line)
signal line_finished(l:Line)

# @TODO: this entire ink management might move to pencils instead, notsure
signal ink_changed()
signal ink_exhausted()
signal ink_bounds_changed()

func activate() -> void:
	cursor.moved.connect(on_cursor_moved)
	cursor.pressed.connect(on_cursor_pressed)
	zoomer.size_changed.connect(on_size_changed)
	entity.reset.connect(on_reset)

func change_ink_bounds(dib:float) -> void:
	max_length = clamp(max_length + dib, 0.5, 5.0)
	ink_bounds_changed.emit()
	update_ink_left()

func on_reset() -> void:
	for line in lines:
		line.queue_free()
	lines = []
	queue_redraw()

func on_cursor_pressed(c:ModuleCursor) -> void:
	if c.is_pressed: start_line(c)
	else: finish_line()

func get_current_line() -> Line:
	return lines.back()

func count() -> int:
	return lines.size()

func get_total_length() -> float:
	var num := 0.0
	for line in lines:
		num += line.get_length()
	return num

func start_line(c:ModuleCursor) -> void:
	if not close_enough_to_prev_line(c):
		print("Start closer to prev line!")
		return
	
	var new_line := Line.new(pencils.get_active_pencil())
	add_child(new_line)
	lines.append(new_line)
	
	line_started.emit(new_line)

func finish_line() -> void:
	var cur_line := get_current_line()
	if cur_line.finished: return
	cur_line.finalize()
	
	if not cur_line.is_valid():
		lines.pop_back()
		print("Invalid line!")
		return
	
	line_finished.emit(cur_line)

func close_enough_to_prev_line(c:ModuleCursor) -> bool:
	if count() <= 0: return true 
	
	var end_point = get_current_line().back()
	var dist := c.get_relative_position().distance_to(end_point)
	
	var close_enough := dist <= MAX_DIST_NEW_LINE
	return close_enough

func on_cursor_moved(pos_rel:Vector2) -> void:
	var cur_line := get_current_line()
	cur_line.add_point(pos_rel)
	cur_line.update(zoomer)
	
	update_ink_left()

func update_ink_left() -> void:
	total_length = get_total_length()
	if total_length >= max_length:
		on_ink_exhausted()
	ink_changed.emit(get_ink_ratio())

func on_ink_exhausted() -> void:
	ink_exhausted.emit()
	finish_line()

func get_ink_ratio() -> float:
	return clamp(get_total_length() / max_length, 0.0, 1.0)

func on_size_changed(size:Rect2) -> void:
	queue_redraw()

func _draw() -> void:
	# base paper
	draw_rect(zoomer.bounds, Color(1,1,1), true)
	
	# the individual lines
	for line in lines:
		line.update(zoomer)
