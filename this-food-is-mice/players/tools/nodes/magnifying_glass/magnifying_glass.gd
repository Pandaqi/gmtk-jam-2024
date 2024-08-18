class_name ToolMagnifyingGlass extends ToolNode
	
func set_active(val:bool) -> void:
	super.set_active(val)
	set_visible(val) # @TODO: might change later when I want to permanently show a key hint or magnifying glass sprite, even if unused

func _process(_dt:float) -> void:
	place_correctly()
	show_mice_in_range()

# @TODO: actually use sprite center for this, not anchor pos in world
func place_correctly() -> void:
	if not active: return
	
	var dir = 1 if tool_switcher.mover.prev_vec.x >= 0 else -1
	set_position(Vector2.RIGHT * dir * 128.0)

func show_mice_in_range() -> void:
	if not active: return
	
	var mice = get_tree().get_nodes_in_group("Mice")
	var radius := 0.5 * 512 # @TODO: read from config, allow changing on the fly
	for m in mice:
		m = m as Mouse
		var dist : float = m.global_position.distance_to(global_position)
		if dist > radius: continue
		m.magnify_tracker.add(self)
		
