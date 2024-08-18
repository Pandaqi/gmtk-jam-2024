class_name GameUI extends Node2D

@onready var label_score : Label = $LabelScore
@onready var label_target : Label = $LabelTarget
@onready var label_level : Label = $LabelLevel
@export var prog_data : ProgressionData

func activate() -> void:
	get_viewport().size_changed.connect(on_resize)
	prog_data.score_changed.connect(on_score_changed)
	prog_data.score_target_changed.connect(on_score_target_changed)
	prog_data.level_changed.connect(on_level_changed)
	on_resize()

func on_level_changed(new_level:int) -> void:
	label_level.set_text(str(new_level + 1))

func on_score_changed(new_score:int) -> void:
	label_score.set_text(str(new_score))

func on_score_target_changed(new_target:int) -> void:
	label_target.set_text(str(new_target))

func on_resize() -> void:
	var vp_size := get_viewport_rect().size
	set_position(Vector2(0.5*vp_size.x, 64.0))
