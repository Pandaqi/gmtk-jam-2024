class_name ModuleZoomer extends Node2D

@export var anchor := Vector2(0.5, 1)
@export var turn : ModuleTurn
@export var prog_data : ProgressionData
@onready var audio_player := $AudioStreamPlayer

var bounds_raw : Rect2
var bounds : Rect2

var base_scale := 1.0
var base_dimensions := Vector2(0.5, 1)
var extra_scale_from_obstacle := 1.0

signal size_changed(bounds:Rect2)
signal size_factor_changed()

func activate() -> void:
	anchor = Vector2(0.5, 0.5)
	
	turn.turn_over.connect(on_turn_over)
	
	extra_scale_from_obstacle = prog_data.zoomer_extra_scale
	
	var bdim_bounds := Global.config.canvas_dimension_bounds
	base_dimensions = Vector2(bdim_bounds.rand_float(), bdim_bounds.rand_float())
	change_size(0)

func on_turn_over() -> void:
	reset_scale()

func _input(ev:InputEvent) -> void:
	if not turn.active: return
	if ev.is_action_pressed("zoom_in"):
		change_size(+1)
	if ev.is_action_pressed("zoom_out"):
		change_size(-1)

func change_size(dir:int) -> void:
	base_scale = Global.config.canvas_base_scale_bounds.clamp_value(base_scale + dir*Global.config.canvas_zoom_speed)
	
	if not audio_player.is_playing():
		audio_player.pitch_scale = randf_range(0.96, 1.04)
		audio_player.play()
	
	var new_size := base_dimensions * base_scale * extra_scale_from_obstacle * Global.config.sprite_size
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

func reset_scale() -> void:
	base_scale = 1.0
	change_size(0)

func get_scale_ratio() -> float:
	return Global.config.canvas_base_scale_bounds.get_ratio(base_scale)
