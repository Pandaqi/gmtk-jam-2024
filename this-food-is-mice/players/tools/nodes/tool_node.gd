class_name ToolNode extends Node2D

var tool_switcher : ModuleToolSwitcher
var active := false
var prevent_switching := false

func activate(ts:ModuleToolSwitcher) -> void:
	tool_switcher = ts
	set_active(false)

func on_button_pressed(pressed:bool) -> void:
	set_active(pressed)

func set_active(val:bool) -> void:
	active = val
