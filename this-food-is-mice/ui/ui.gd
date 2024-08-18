class_name UI extends CanvasLayer

@onready var game_ui : GameUI = $GameUI

func activate() -> void:
	game_ui.activate()
