class_name Progression extends Node2D

@export var prog_data : ProgressionData

func activate() -> void:
	prog_data.score_changed.connect(on_score_changed)
	GSignal.game_over.connect(on_game_over)

func start_game() -> void:
	prog_data.reset()

func on_score_changed(new_score:int) -> void:
	if new_score < prog_data.score_target: return
	
	# go up a level and plan how long this one will last
	var interval : int = round(Global.config.prog_score_interval_per_level * pow(Global.config.prog_score_interval_increase_per_level, prog_data.level))
	prog_data.set_target_score(prog_data.score_target + interval)
	prog_data.change_level(+1)

func on_game_over(we_won:bool) -> void:
	print("Game Over!")
	print("We won? ", we_won)
