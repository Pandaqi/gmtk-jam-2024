class_name Progression extends Node2D

func activate() -> void:
	GSignal.game_over.connect(on_game_over)

func on_game_over(we_won:bool) -> void:
	print("Game Over!")
	print("We won? ", we_won)
