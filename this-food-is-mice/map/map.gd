class_name Map extends Node2D

@export var map_data : MapData
@export var obstacle_scene : PackedScene

@onready var bg = $BG
@onready var layers : MapLayers = $Layers
@export var tool_pie : ToolType

func activate() -> void:
	generate()
	
	bg.activate()

func generate() -> void:
	map_data.map_node = self
	
	var size := Global.config.map_size
	var size_pixels := size * Global.config.sprite_size
	map_data.bounds = Rect2(Vector2.ZERO, size_pixels)
	
	var num_obstacles := 10
	
	# everything appears at least once
	var tools : Array[ToolType] = map_data.all_tools.duplicate(false)
	var num_pies := Global.config.gameloop_num_pies
	for i in range(num_pies-1):
		tools.append(tool_pie)
	
	while tools.size() < num_obstacles:
		tools.append(null)
	tools.shuffle()
	
	for i in range(num_obstacles):
		var o : Obstacle = obstacle_scene.instantiate()
		o.set_position(get_random_position())
		layers.add_to_layer("entities", o)
		o.activate()
		o.set_tool(tools.pop_back())
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

# @TODO
func get_random_position() -> Vector2:
	return map_data.query_position()
