class_name ModuleDrawer extends Node2D

@export var cursor : ModuleCursor
@export var zoomer : ModuleZoomer
@export var pencils : ModulePencils
@onready var entity : PlayerPaper = get_parent()
@onready var outline : ModuleDrawerOutline = $Outline
@onready var bottom_marker := $BottomMarker

var lines : Array[Line] = []
var ink_relative : Array[float] = []
var total_length := 0.0
var total_length_max := 1.0

signal line_started(l:Line)
signal line_finished(l:Line)

# @TODO: this entire ink management might move to pencils instead, notsure
signal ink_changed()
signal ink_exhausted()
signal ink_bounds_changed()
signal ink_relative_matched()

func activate() -> void:
	total_length_max = Global.config.ink_default
	
	cursor.moved.connect(on_cursor_moved)
	cursor.pressed.connect(on_cursor_pressed)
	zoomer.size_changed.connect(on_size_changed)
	entity.reset.connect(on_reset)
	entity.player_bot.paper_follower.line_started.connect(on_line_started)
	entity.player_bot.paper_follower.line_ended.connect(on_line_ended)

func change_ink_bounds(dib:float) -> void:
	total_length_max = Global.config.ink_bounds.clamp_value(total_length_max + dib)
	ink_bounds_changed.emit()
	update_ink_left()

func on_reset() -> void:
	for line in lines:
		line.queue_free()
	lines = []
	refresh_drawing()

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
		GSignal.feedback.emit(global_position, "Too far away from last line!")
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
		GSignal.feedback.emit(global_position, "Too short!")
		print("Invalid line!")
		return
	
	calculate_relative_ink_levels()
	line_finished.emit(cur_line)

func close_enough_to_prev_line(c:ModuleCursor) -> bool:
	if count() <= 0: return true 
	
	var end_point = get_current_line().back()
	var dist := c.get_relative_position().distance_to(end_point)
	
	var close_enough := dist <= Global.config.drawing_max_dist_to_old_line
	return close_enough

func too_close_to_prev_point(pos:Vector2) -> bool:
	var cur_line := get_current_line()
	if not cur_line: return false
	if cur_line.count() <= 0: return false
	
	var dist := cur_line.back().distance_to(pos)
	return dist <= Global.config.drawing_min_dist_to_prev_point

func on_cursor_moved(pos_rel:Vector2) -> void:
	if too_close_to_prev_point(pos_rel): return
	
	var cur_line := get_current_line()
	cur_line.add_point(pos_rel)
	cur_line.update(zoomer)
	
	update_ink_left()

func update_ink_left() -> void:
	total_length = get_total_length()
	if total_length >= total_length_max:
		on_ink_exhausted()
	calculate_relative_ink_levels()
	ink_changed.emit(get_ink_ratio())

func on_ink_exhausted() -> void:
	if Global.config.turns_require_ink_relative_match: return
	ink_exhausted.emit()
	finish_line()

func get_ink_ratio() -> float:
	return clamp(1.0 - get_total_length() / total_length_max, 0.0, 1.0)

func on_line_started(lf:LineFollower) -> void:
	var line := lf.line
	for other_line in lines:
		other_line.unfocus()
	line.focus()

func on_line_ended(lf:LineFollower) -> void:
	var line := lf.line
	lines.erase(line)
	line.kill()
	refresh_drawing()

func on_size_changed(rect:Rect2) -> void:
	material.set_shader_parameter("real_size", rect.size)
	var num_tiles := 6
	var ideal_tile_size : Vector2 = min(rect.size.x / num_tiles, rect.size.y / num_tiles) * Vector2.ONE
	material.set_shader_parameter("tile_size", ideal_tile_size)
	refresh_drawing()

func get_pencils_in_drawing() -> Array[PencilType]:
	var arr : Array[PencilType] = []
	for line in lines:
		if arr.has(line.type): continue
		arr.append(line.type)
	return arr

func get_length_for_pencil(pt:PencilType) -> float:
	var sum := 0.0
	for line in lines:
		if line.type != pt: continue
		sum += line.get_length()
	return sum

func calculate_relative_ink_levels() -> void:
	# aggregate data about line lengths
	var line_lengths : Array[float] = []
	var max_length := -INF
	var min_length := INF
	for tp in get_pencils_in_drawing():
		var length := get_length_for_pencil(tp)
		max_length = max(max_length, length)
		min_length = min( min(min_length, length - 0.01), 0.1)
		line_lengths.append(length)
	
	# set ink size as relative to whole
	ink_relative = []
	for i in range(line_lengths.size()):
		var length_rel := (line_lengths[i] - min_length) / float(max_length - min_length)
		ink_relative.append(length_rel)
	
	if not Global.config.turns_require_ink_relative_match: return
	
	var max_error := 0.0
	for i in range(ink_relative.size()):
		for j in range(ink_relative.size()):
			max_error = max(max_error, abs(ink_relative[j] - ink_relative[i]))
	
	var close_enough = max_error <= Global.config.turns_ink_relative_margin
	var all_lines_drawn := count() >= pencils.count_unlocked()
	if (not close_enough) or (not all_lines_drawn): return
	
	ink_relative_matched.emit()

func refresh_drawing() -> void:
	queue_redraw()
	outline.queue_redraw()
	
	var marker_font_size := 20.0
	bottom_marker.set_position(Vector2.DOWN * (0.5 * zoomer.bounds.size.y + 0.66*marker_font_size))

func _draw() -> void:
	# base paper
	draw_rect(zoomer.bounds, Color(1,1,1), true, -1, false)
	
	# the individual lines
	for line in lines:
		line.update(zoomer)
