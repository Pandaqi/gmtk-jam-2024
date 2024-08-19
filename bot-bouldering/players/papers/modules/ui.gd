class_name ModulePaperUI extends Node2D

@export var prog_data : ProgressionData

@onready var ink_left : UIElement = $InkLeft
@onready var time_left : UIElement = $TimeLeft
@onready var lives : UIElement = $Lives
@onready var score : UIElement = $Score
@onready var pencils : UIPencils = $Pencils
@onready var entity : PlayerPaper = get_parent()
@onready var ink_bar : UIInkBar = $InkBar

@export var drawer : ModuleDrawer
@export var turn : ModuleTurn

func activate(ui_layer:CanvasLayer) -> void:
	get_parent().remove_child(self)
	ui_layer.add_child(self)
	
	ink_bar.activate()
	
	drawer.ink_changed.connect(on_ink_changed)
	prog_data.lives_changed.connect(on_lives_changed)
	prog_data.score_changed.connect(on_score_changed)
	on_lives_changed(prog_data.lives)
	on_score_changed(prog_data.score)
	
	pencils.global_position = ink_bar.get_center() + Vector2(-128.0, 0)
	
	get_viewport().size_changed.connect(on_resize)
	on_resize()

func on_resize() -> void:
	var vp_size := get_viewport_rect().size
	set_position(0.5*vp_size)

func on_ink_changed(ink_ratio:float) -> void:
	ink_left.update(str(round(ink_ratio * 100)) + "%")

func _process(_dt:float) -> void:
	on_turn_changed()

func on_turn_changed() -> void:
	var tm_nice : int = round(turn.get_time_left())
	time_left.update(str(tm_nice))

func on_lives_changed(new_lives:int) -> void:
	lives.update(str(new_lives))

func on_score_changed(new_score:int) -> void:
	score.update(str(new_score))
	
	
	
	
