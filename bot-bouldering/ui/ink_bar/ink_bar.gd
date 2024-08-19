class_name UIInkBar extends Node2D

@onready var bar_start := $BarStart
@onready var bar_end := $BarEnd
@onready var ink_cont := $Ink

@export var drawer : ModuleDrawer

var ink_bars : Array[UIInkBarPencil]
var ink_bar_types : Array[PencilType]
@export var ink_bar_pencil_scene : PackedScene

# If false, it displays a unique bar for each line type, with relative usage levels


func activate() -> void:
	drawer.ink_changed.connect(on_ink_changed)
	ink_cont.set_position(bar_start.position)

func on_ink_changed(ink_ratio:float) -> void:
	maintain_bar_per_pencil()
	
	var display_multi := Global.config.turns_require_ink_relative_match
	if display_multi:
		var data := drawer.ink_relative
		
		var display_order := range(data.size())
		display_order.sort_custom(func(a, b):
			if data[a] < data[b]: return true
			return false
		)
		
		for i in range(data.size()):
			ink_bars[i].set_height(data[i] * get_bar_height())
			ink_bars[i].z_index = data.size() + 1 - display_order.find(i)
		return
	
	ink_bars[0].set_height(ink_ratio * get_bar_height())
	return

func get_bar_height() -> float:
	return abs( (bar_end.global_position - bar_start.global_position).y )

func get_bar_for_type(tp:PencilType) -> UIInkBarPencil:
	return ink_bars[ ink_bar_types.find(tp) ]

func maintain_bar_per_pencil() -> void:
	var pencil_types := drawer.get_pencils_in_drawing()
	
	# add those missing
	for type in pencil_types:
		if ink_bar_types.has(type): continue
		
		var ibp : UIInkBarPencil = ink_bar_pencil_scene.instantiate()
		ibp.type = type
		ink_bar_types.append(type)
		ink_bars.append(ibp)
		ink_cont.add_child(ibp)
	
	# remove those unused anymore
	for i in range(ink_bars.size()-1, -1, -1):
		if pencil_types.has(ink_bars[i].type): continue
		ink_bars[i].queue_free()
		ink_bars.remove_at(i)
		ink_bar_types.remove_at(i)

func get_center() -> Vector2:
	return 0.5 * (bar_start.global_position + bar_end.global_position)
