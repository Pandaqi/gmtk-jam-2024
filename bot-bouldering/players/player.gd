class_name Player extends Node2D

@export var player_bot_scene : PackedScene
@export var player_paper_scene : PackedScene

var lives := 1
var score := 0

signal lives_changed(new_lives:int)
signal score_changed(new_score:int)

func activate(papers_layer:CanvasLayer) -> void:
	# create our components
	var pb : PlayerBot = player_bot_scene.instantiate()
	add_child(pb)
	var pp : PlayerPaper = player_paper_scene.instantiate()
	
	if Global.config.player_paper_on_top_of_bot:
		add_child(pp)
	else:
		papers_layer.add_child(pp)
	
	# give them all an easy link to each other
	pb.player = self
	pb.paper = pp
	
	pp.player = self
	pp.player_bot = pb
	
	pb.activate()
	pp.activate()

func change_lives(dl:int) -> void:
	lives = clamp(lives + dl, 0, 9)
	lives_changed.emit(lives)
	
	if lives <= 0:
		GSignal.game_over.emit(false)

func remove_all_lives() -> void:
	change_lives(-lives)

func change_score(ds:int) -> void:
	score = clamp(score + ds, 0, 99999)
	score_changed.emit(score)
