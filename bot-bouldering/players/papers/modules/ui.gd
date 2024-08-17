class_name ModulePaperUI extends Node2D

@onready var ink_left : UIElement = $InkLeft
@onready var time_left : UIElement = $TimeLeft
@onready var lives : UIElement = $Lives
@onready var score : UIElement = $Score
@onready var entity : PlayerPaper = get_parent()

@export var drawer : ModuleDrawer
@export var turn : ModuleTurn

func activate() -> void:
	drawer.ink_changed.connect(on_ink_changed)
	entity.player.lives_changed.connect(on_lives_changed)
	entity.player.score_changed.connect(on_lives_changed)

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
	
	
	
	
