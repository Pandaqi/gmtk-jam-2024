class_name UIPencils extends Node2D

@export var pencils : ModulePencils
@export var pencil_scene : PackedScene
var pencil_nodes : Array[UIPencil] = []

var ui_scale := 0.25

func _ready() -> void:
	pencils.pencils_changed.connect(on_pencils_changed)
	pencils.active_changed.connect(on_active_changed)
	set_scale(ui_scale * Vector2.ONE)

func on_active_changed(pt:PencilType) -> void:
	for node in pencil_nodes:
		node.set_focus(node.type == pt)

func on_pencils_changed(available:Array[PencilType], unlocked:Array[PencilType]) -> void:
	var num := unlocked.size()
	while pencil_nodes.size() < num:
		var p : UIPencil = pencil_scene.instantiate()
		add_child(p)
		pencil_nodes.append(p)
	
	var offset_per_node := Vector2.RIGHT * 256.0
	var global_offset := -0.5 * (num - 1) * offset_per_node
	for i in range(pencil_nodes.size()):
		var node := pencil_nodes[i]
		var should_show := i < num
		node.set_visible(should_show)
		node.set_position(global_offset + i * offset_per_node)
		
		if not should_show: return
		var type_data := unlocked[i]
		node.set_data(type_data, available.has(type_data))
