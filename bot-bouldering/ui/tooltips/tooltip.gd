class_name UITooltip extends Node2D

@onready var label : Label = $Label

func set_data(mod:ModuleTooltip) -> void:
	label.set_text(mod.text)
