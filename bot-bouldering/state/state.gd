class_name Progression extends Node2D

var level := 0

func activate() -> void:
	GSignal.game_over.connect(on_game_over)

func on_game_over(we_won:bool) -> void:
	print("GAME OVER")
	print("We won? ", we_won)
	restart() # @TODO: replace with actual gameover screen

func restart() -> void:
	get_tree().reload_current_scene()

func go_back() -> void:
	get_tree().change_scene_to_file("res://game_loop/menu/menu.tscn")
