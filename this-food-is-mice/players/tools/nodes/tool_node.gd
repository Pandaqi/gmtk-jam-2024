class_name ToolNode extends Node2D

var tool_switcher : ModuleToolSwitcher
var active := false
var prevent_switching := false

signal active_changed(val:bool)

func activate(ts:ModuleToolSwitcher) -> void:
	tool_switcher = ts
	set_active(false)

func on_button_pressed(pressed:bool) -> void:
	set_active(pressed)

func set_active(val:bool) -> void:
	active = val
	active_changed.emit(val)
	
	if tool_switcher.cur_tool.in_use_hide_sprite:
		tool_switcher.visuals.set_visible(not active)

func shutdown() -> void:
	if tool_switcher.cur_tool.in_use_hide_sprite:
		tool_switcher.visuals.set_visible(true)
