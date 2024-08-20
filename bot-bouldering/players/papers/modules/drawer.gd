class_name ModuleDrawer extends Node2D

@export var cursor : ModuleCursor
@export var zoomer : ModuleZoomer
@export var pencils : ModulePencils
@onready var entity : PlayerPaper = get_parent()
@onready var outline : ModuleDrawerOutline = $Outline
@onready var bottom_marker := $BottomMarker

@onready var audio_player := $AudioStreamPlayer2D

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
	if lines.size() <= 0: return null
	return lines.back()

func count() -> int:
	return lines.size()

func get_total_length() -> float:
	var num := 0.0
	for line in lines:
		num += line.get_length()
	return num

func start_line(c:ModuleCursor) -> void:
	if zoomer.is_out_of_bounds(c.get_drawing_position()): return
	if not close_enough_to_prev_line(c):
		GSignal.feedback.emit(global_position, "Too far away from last line!")
		return
	
	var new_line := Line.new(pencils.get_active_pencil())
	add_child(new_line)
	lines.append(new_line)
	
	line_started.emit(new_line)

func has_active_line() -> bool:
	return get_current_line() and not get_current_line().finished

func finish_line() -> void:
	var cur_line := get_current_line()
	if not has_active_line(): return
	
	audio_player.stop()
	if not cur_line.is_valid():
		lines.pop_back()
		calculate_relative_ink_levels() # if we don't do this, the check of "have we used all pencils" will fail for a single frame, which can be enough to trigger the game to start
		GSignal.feedback.emit(global_position, "Too short!")
		print("Invalid line!")
		return
	
	cur_line.finalize()
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
	if not has_active_line(): return
	if too_close_to_prev_point(pos_rel): return
	
	var cur_line := get_current_line()
	
	# @NOTE: this is necessary to prevent updates that are TOO BIG (if someone moves the moues REALLY FAST) that would ruin our relative ink checks
	var is_match := false
	var points_chunked := [pos_rel]
	if cur_line.count() > 1:
		points_chunked =  chunk_line_between_points(cur_line.back(), pos_rel)
	
	for point in points_chunked:
		cur_line.add_point(point)
		is_match = calculate_relative_ink_levels() or is_match
	cur_line.update(zoomer)
	
	if not audio_player.is_playing():
		audio_player.pitch_scale = randf_range(0.95, 1.05)
		audio_player.play()
	
	update_ink_left()
	if is_match:
		ink_relative_matched.emit()

func chunk_line_between_points(a:Vector2, b:Vector2) -> Array[Vector2]:
	var dir := (b-a).normalized()
	var step_size := 0.001
	var cur_point := a
	var points : Array[Vector2] = []
	while true:
		var dist_left = cur_point.distance_to(b)
		var temp_step_size : float = min(dist_left, step_size)
		cur_point += dir * dist_left
		points.append(cur_point)
		if temp_step_size < step_size: break
	return points

func update_ink_left() -> void:
	total_length = get_total_length()
	if total_length >= total_length_max:
		on_ink_exhausted()
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

func calculate_relative_ink_levels() -> bool:
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
	
	var shortest_line := INF
	ink_relative = []
	for i in range(line_lengths.size()):
		var length_rel := (line_lengths[i] - min_length) / float(max_length - min_length) 
		shortest_line = min(shortest_line, length_rel)
		ink_relative.append(length_rel)
	
	if not Global.config.turns_require_ink_relative_match: return false
	
	# @NOTE: checks line-by-line, so a line only needs to be close to ONE other line to be "equally used"
	# Used to check for absolute error (just do max_error check once in inner loop), but that was too hard
	var max_error := 0.0
	for i in range(ink_relative.size()):
		var min_error := INF
		for j in range(ink_relative.size()):
			if i == j: continue
			min_error = min(min_error, abs(ink_relative[j] - ink_relative[i]))
		max_error = max(max_error, min_error)
	
	var max_error_margin := Global.config.turns_ink_relative_margin
	var close_enough = max_error <= max_error_margin
	var all_lines_drawn := count() >= pencils.count_unlocked()
	var shortest_line_too_small := shortest_line < max_error
	if (not close_enough) or (not all_lines_drawn) or shortest_line_too_small: return false
	
	return true

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
