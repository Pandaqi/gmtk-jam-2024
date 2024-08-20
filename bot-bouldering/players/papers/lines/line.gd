class_name Line extends Node2D

var type : PencilType
var points : Array[Vector2] = []
var points_scaled : Array[Vector2] = []
var finished := false
var total_length := 0.0
var focus_tween : Tween = null

func _init(p:PencilType = null) -> void:
	type = p

func clone() -> Line:
	var l := Line.new(type)
	l.points = points.duplicate(true)
	return l

func add_point(p:Vector2) -> void:
	if finished: return
	points.append(p)
	
	if points.size() <= 1: return
	var segment_length := p.distance_to(points[points.size() - 2])
	segment_length *= type.ink_factor
	total_length += segment_length

func finalize() -> void:
	finished = true

func count() -> int:
	return points.size()

func is_valid() -> bool:
	return count() >= 2

func front() -> Vector2:
	return points.front()

func back() -> Vector2:
	return points.back()

func get_length() -> float:
	return total_length

func unfocus() -> void:
	modulate = Color(1,1,1,0.35)
	if focus_tween: focus_tween.stop()

func focus() -> void:
	var dur := 0.125
	var tw := get_tree().create_tween()
	tw.set_loops(1000)
	tw.tween_property(self, "modulate", Color(2, 1, 1, 0.66), dur)
	tw.tween_property(self, "modulate", Color(1,1,1,1), dur)
	
	focus_tween = tw

func kill() -> void:
	unfocus()
	self.queue_free()

func update(z:ModuleZoomer) -> void:
	if not is_valid(): return
	
	points_scaled = []
	for point in points:
		points_scaled.append(z.get_absolute_position_on_paper(point))
	
	queue_redraw()

func _draw() -> void:
	if not is_valid(): return
	draw_polyline(points_scaled, type.color, Global.config.canvas_line_width, true)
