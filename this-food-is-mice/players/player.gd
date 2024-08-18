class_name Player extends CharacterBody2D

@onready var mover : ModuleMover = $Mover
@onready var tool_switcher : ModuleToolSwitcher = $ToolSwitcher
@onready var visuals : ModuleVisualsPlayer = $Visuals

func activate() -> void:
	visuals.activate()
	mover.activate()
	tool_switcher.activate()
