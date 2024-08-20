class_name Player extends Node2D

enum PlayerState
{
	DRAWING,
	MOVING
}

@export var player_bot_scene : PackedScene
@export var player_paper_scene : PackedScene
@onready var audio_player := $AudioStreamPlayer

var player_bot : PlayerBot
var player_paper : PlayerPaper

@export var prog_data : ProgressionData

var state := PlayerState.DRAWING

signal state_changed(st:PlayerState)

func activate(papers_layer:CanvasLayer, ui_layer:CanvasLayer) -> void:
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
	
	player_bot = pb
	player_paper = pp
	
	pb.done.connect(change_state)
	pp.done.connect(change_state)
	
	pb.activate()
	pp.activate(ui_layer)
	
	# init call
	state = PlayerState.MOVING
	change_state()

func change_state() -> void:
	if is_drawing():
		state = PlayerState.MOVING
	else:
		state = PlayerState.DRAWING
	audio_player.play()
	state_changed.emit(state)
	GSignal.player_state_changed.emit(state)

func is_drawing() -> bool:
	return state == PlayerState.DRAWING

func is_moving() -> bool:
	return state == PlayerState.MOVING
