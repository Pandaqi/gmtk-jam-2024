class_name ModuleToolSwitcher extends Node2D

@onready var entity : Player = get_parent()
@export var map_tracker : ModuleMapTracker

@export var input : ModuleInput
@export var mover : ModuleMover
@export var visuals : ModuleVisualsPlayer

var cur_tool : ToolType = null
var cur_tool_node : ToolNode = null

@export var def_tool : ToolType

signal tool_switched(tt:ToolType)
signal tool_used()

func activate() -> void:
	visuals.done_slamming.connect(on_done_slamming)
	map_tracker.obstacle_entered.connect(on_obstacle_entered)
	input.button_pressed.connect(on_button_pressed)
	switch_tool(def_tool)

func has_tool() -> bool:
	return cur_tool != null

func can_switch() -> bool:
	if not cur_tool_node: return true
	if cur_tool_node.prevent_switching: return false
	return true

func on_button_pressed(pressed:bool) -> void:
	if not has_tool(): return
	if cur_tool_node: 
		cur_tool_node.on_button_pressed(pressed)
		tool_used.emit()
	#if not pressed and cur_tool.single_use:
		#call_deferred("reset_tool")

func on_done_slamming() -> void:
	if not has_tool(): return
	if not cur_tool.single_use: return
	reset_tool()

func on_obstacle_entered(o:Obstacle) -> void:
	if not o.tool or not o.tool.equippable: return
	if not can_switch(): return
	var is_same_tool := o.tool == cur_tool
	if is_same_tool: return
	call_deferred("switch_tool", o.tool)

func reset_tool() -> void:
	switch_tool(null)

func switch_tool(tt:ToolType) -> void:
	if cur_tool_node:
		cur_tool_node.shutdown()
		cur_tool_node.queue_free()
	
	cur_tool = tt
	cur_tool_node = null
	
	if cur_tool and cur_tool.node:
		cur_tool_node = tt.node.instantiate()
		add_child(cur_tool_node)
		cur_tool_node.activate(self)
	
	tool_switched.emit(cur_tool)

func get_speed_factor() -> float:
	if not cur_tool_node or not cur_tool_node.active: return 1.0
	return cur_tool.in_use_walk_speed
