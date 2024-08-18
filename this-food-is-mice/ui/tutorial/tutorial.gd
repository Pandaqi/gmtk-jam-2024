class_name Tutorial extends Node2D

@export var map_data : MapData
@export var prog_data : ProgressionData
@export var tut_sprite : PackedScene

var tut_sprite_size := Vector2(500, 750)
var has_shown_start := false

signal done()

func activate() -> void:
	prog_data.type_unlocked.connect(on_type_unlocked)

func on_type_unlocked(tt:ToolType) -> void:
	if not has_shown_start: return
	appear(tt)

func show_start_explanation() -> void:
	prog_data.pause()
	
	var offset_per_node := Vector2.RIGHT * tut_sprite_size.x
	var global_offset := -0.5 * (3 - 1) * offset_per_node
	var center := map_data.bounds.get_center()
	for i in range(3):
		var t : TutorialSprite = tut_sprite.instantiate()
		t.set_position(center + global_offset + i*offset_per_node)
		add_child(t)
		t.set_base_tutorial(i)
		await t.done
	
	has_shown_start = true
	done.emit()
	
	prog_data.unpause()

func appear(tt:ToolType) -> void:
	prog_data.pause()
	
	var center := map_data.bounds.get_center()
	var t : TutorialSprite = tut_sprite.instantiate()
	t.set_position(center)
	add_child(t)
	t.set_tool(tt)
	await t.done
	
	prog_data.unpause()
