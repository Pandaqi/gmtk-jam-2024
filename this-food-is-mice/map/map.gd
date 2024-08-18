class_name Map extends Node2D

@export var map_data : MapData
@export var prog_data : ProgressionData
@export var obstacle_scene : PackedScene

@onready var bg = $BG
@onready var layers : MapLayers = $Layers
@export var tool_pie : ToolType

signal generated()

func activate() -> void:
	prog_data.level_changed.connect(on_level_changed)
	generate()
	bg.activate()

func generate() -> void:
	map_data.map_node = self
	
	var size := Global.config.map_size
	var size_pixels := size * Global.config.sprite_size
	map_data.bounds = Rect2(Vector2.ZERO, size_pixels)

func on_level_changed(new_level:int) -> void:
	print("Level Changed", new_level)
	if new_level == 0:
		unlock_starting_types()
		return
	unlock_new_type()

func unlock_starting_types() -> void:
	var num_obstacles := Global.config.obstacle_starting_num
	var final_starting_types : Array[ToolType] = []
	var starting_tools := prog_data.starting_tools.duplicate(false)
	
	# add everything at least the min number of times
	for i in range(starting_tools.size()-1,-1,-1):
		var tool : ToolType = starting_tools[i]
		prog_data.unlock_tool(tool)
		
		for a in range(tool.min_num):
			final_starting_types.append(tool)
		
		if tool.max_num <= tool.min_num:
			starting_tools.remove_at(i)
	
	# then fill it up
	while final_starting_types.size() < num_obstacles:
		var rand_pick : ToolType = null 
		if starting_tools.size() > 0:
			rand_pick = starting_tools.pick_random()
		
		final_starting_types.append(rand_pick)
		
		# remove from options if at maximum
		var num_of_type := 0
		for type in final_starting_types:
			if type == rand_pick: num_of_type += 1
		
		if num_of_type >= rand_pick.max_num:
			starting_tools.erase(rand_pick)
	
	# now just spawn the stuff according to the list
	final_starting_types.shuffle()
	for type in final_starting_types:
		spawn(type)
	
	generated.emit()

func unlock_new_type() -> void:
	var all_types := map_data.all_tools
	var types_unlocked := prog_data.tools_unlocked
	var types_available : Array[ToolType] = []
	for type in all_types:
		if types_unlocked.has(type): continue
		types_available.append(type)
	
	if types_available.size() <= 0: return
	
	var rand_type : ToolType = types_available.pick_random()
	prog_data.unlock_tool(rand_type)
	
	var num := randi_range(rand_type.min_num, rand_type.max_num)
	for i in range(num):
		spawn(rand_type)

func spawn(type:ToolType) -> void:
	var o : Obstacle = obstacle_scene.instantiate()
	o.set_position(get_random_position())
	layers.add_to_layer("entities", o)
	o.activate()
	o.set_tool(type)
	o.died.connect(on_obstacle_died)

func get_all() -> Array[Node]:
	return get_tree().get_nodes_in_group("Obstacles")

func on_obstacle_died(o:Obstacle) -> void:
	check_if_game_over()

func check_if_game_over() -> void:
	var num_surv := 0
	for node in get_all():
		node = node as Obstacle
		if not node.tool: continue
		if not node.tool.required_for_survival: continue
		num_surv += 1
	
	if num_surv > 0: return
	GSignal.game_over.emit(false)

func get_random_position() -> Vector2:
	return map_data.query_position({
		"avoid": get_all(),
		"dist": Global.config.scale(Global.config.obstacle_min_spawn_dist),
		"edge_margin": 0.75*Global.config.sprite_size*Vector2.ONE
	})
