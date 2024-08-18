extends Resource
class_name ToolType

@export var title := ""
@export var frame := 0
@export var desc := ""
@export var color := Color(1,1,1)
@export var node : PackedScene = null
@export var equippable := true
@export var single_use := false
@export var required_for_survival := false
@export var min_num := 1
@export var max_num := 1

@export var in_use_hide_sprite := false
@export var in_use_walk_speed := 1.0
