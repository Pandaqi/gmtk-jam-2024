class_name Player extends CharacterBody2D

@onready var mover : ModuleMover = $Mover
@onready var tool_switcher : ModuleToolSwitcher = $ToolSwitcher

func activate() -> void:
	mover.activate()
	tool_switcher.activate()
