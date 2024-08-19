extends Resource
class_name ProgressionData

var first_load := true
var level := -1
var lives := 0
var score := 0
var bot_size_scale := 1.0
var zoomer_extra_scale := 1.0
var canvas_rotation := 0.0

signal level_changed(new_level:int)
signal lives_changed(new_lives:int)
signal score_changed(new_score:int)

func reset() -> void:
	change_score(-score)
	if first_load: reset_fully()

func reset_fully() -> void:
	change_lives(-lives + Global.config.player_starting_lives)
	change_level(-level)
	first_load = false
	bot_size_scale = 1.0
	zoomer_extra_scale = 1.0
	canvas_rotation = 0.0

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

func change_level(dl:int) -> void:
	level = clamp(level + dl, 0, 99)
	level_changed.emit(level)

func save_state(players:Players) -> void:
	var player : Player = players.get_all()[0]
	bot_size_scale = player.player_bot.size_scale
	zoomer_extra_scale = player.player_paper.zoomer.extra_scale_from_obstacle
	canvas_rotation = player.player_paper.rotation_factor
