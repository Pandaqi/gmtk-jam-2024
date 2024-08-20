class_name Tooltips extends CanvasLayer

var tooltip_nodes : Array[UITooltip] = []
var tooltip_modules : Array[ModuleTooltip] = []

@export var tooltip_node : PackedScene
@export var feedback_node : PackedScene

func activate() -> void:
	await get_tree().create_timer(0.25).timeout
	GSignal.tooltip.connect(on_tooltip)
	GSignal.feedback.connect(on_feedback)

func on_feedback(pos:Vector2, text:String, convert_pos := false) -> void:
	var f : FeedbackInstance = feedback_node.instantiate()
	if convert_pos:
		pos = get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()*pos
	f.set_position(pos)
	add_child(f)
	f.set_text(text)

func on_tooltip(should_show:bool, mod:ModuleTooltip) -> void:
	if should_show:
		var n = tooltip_node.instantiate()
		n.set_position(mod.get_anchor_position())
		add_child(n)
		n.set_data(mod)
		tooltip_nodes.append(n)
		tooltip_modules.append(mod)
		return
	
	var idx := tooltip_modules.find(mod)
	if idx < 0: return
	tooltip_nodes[idx].queue_free()
	tooltip_nodes.remove_at(idx)
	tooltip_modules.remove_at(idx)
