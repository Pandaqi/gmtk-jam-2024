class_name Progression extends Node2D

@export var prog_data : ProgressionData
@export var map_data : MapData
@export var paper_data : PaperData
@export var players : Players
@export var tutorial : Tutorial

@onready var audio_lose := $AudioLose
@onready var audio_win := $AudioWin

var we_won := false

func activate() -> void:
	prog_data.reset()
	GSignal.game_over.connect(on_game_over)
	prepare_first_level_if_needed()
	
	if should_debug_level():
		prog_data.level = Global.config.debug_level

func should_debug_level() -> bool:
	return (OS.is_debug_build() and Global.config.debug_level >= 0)

func replay_debug_levels_if_needed() -> void:
	if not should_debug_level(): return
	for i in range(Global.config.debug_level):
		prepare_next_level(0)

func prepare_first_level_if_needed() -> void:
	if not is_first_level(): return
	paper_data.reset()
	
	for type in paper_data.pencils_starting:
		paper_data.unlock_pencil(type)

func is_first_level() -> bool:
	return prog_data.level <= 0

func on_game_over(w:bool) -> void:
	we_won = w
	call_deferred("end_game")

func end_game() -> void:
	print("GAME OVER")
	print("We won? ", we_won)
	
	if not we_won:
		audio_lose.play()
		prog_data.first_load = true
	else:
		audio_win.play()
		prepare_next_level()

	tutorial.on_game_over(we_won)

func prepare_next_level(dl := +1) -> void:
	prog_data.change_level(dl)
	prog_data.change_lives(Global.config.player_extra_lives_for_levelup)
	
	prog_data.save_state(players) # some stuff is persistent between restarts
	
	# unlock obstacles (if needed)
	if map_data.has_unlockables():
		map_data.unlock(map_data.obstacles_locked.pick_random())
	
	# unlock pencils (if needed)
	var wanna_unlock := randf() <= Global.config.pencil_unlock_probability
	var must_unlock : bool = abs(prog_data.level - paper_data.last_pencil_unlock) >= Global.config.pencil_unlock_max_interval
	var can_unlock := paper_data.has_unlockable_pencils() and paper_data.pencils_available.size() < Global.config.pencil_max_num
	if (must_unlock or wanna_unlock) and can_unlock:
		paper_data.unlock_pencil(paper_data.pencils_locked.pick_random())
		paper_data.last_pencil_unlock = prog_data.level

func restart() -> void:
	get_tree().reload_current_scene()

func go_back() -> void:
	get_tree().change_scene_to_file("res://game_loop/menu/menu.tscn")
