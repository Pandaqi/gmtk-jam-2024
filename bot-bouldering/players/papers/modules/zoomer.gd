class_name ModuleZoomer extends Node2D

@export var anchor := Vector2(0.5, 1)
@export var turn : ModuleTurn

var bounds_raw : Rect2
var bounds : Rect2

var base_scale := 1.0
var base_dimensions := Vector2(0.5, 1)
var base_size := 256
var size_bounds = Bounds.new(0.5, 2.0)

var extra_scale_from_obstacle := 1.0

var zoom_speed := 0.1

signal size_changed(bounds:Rect2)
signal size_factor_changed()

func activate() -> void:
	change_size(0)

func _input(ev:InputEvent) -> void:
	if not turn.active: return
	if ev.is_action_pressed("zoom_in"):
		change_size(+1)
	if ev.is_action_pressed("zoom_out"):
		change_size(-1)

func change_size(dir:int) -> void:
	base_scale = size_bounds.clamp_value(base_scale + dir*zoom_speed)
	
	var new_size := base_dimensions * base_scale * base_size * extra_scale_from_obstacle
	bounds_raw.position = Vector2.ZERO
	bounds_raw.size = new_size
	
	bounds = Rect2(
		bounds_raw.position - anchor * bounds_raw.size,
		bounds_raw.size
	)
	
	size_changed.emit(bounds)

func change_extra_scale(es:float) -> void:
	extra_scale_from_obstacle = clamp(extra_scale_from_obstacle * es, 0.25, 4.0)
	size_factor_changed.emit()
	change_size(0)

func get_relative_position_on_paper(pos:Vector2) -> Vector2:
	return (to_local(pos) - bounds.position) / bounds.size

func get_absolute_position_on_paper(pos_rel:Vector2) -> Vector2:
	return bounds.position + pos_rel * bounds.size

func is_out_of_bounds(pos:Vector2) -> bool:
	var pos_rel := get_relative_position_on_paper(pos)
	return pos_rel.x < 0.0 or pos_rel.x > 1.0 or pos_rel.y < 0.0 or pos_rel.y > 1.0

func get_scale_ratio() -> float:
	return size_bounds.get_ratio(base_scale)
