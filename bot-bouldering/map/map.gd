class_name MapDynamic extends Node2D

var chunk_size : Vector2
var chunks : Array[MapChunk] = []

@export var map_data : MapData
@export var chunk_scene : PackedScene

func activate() -> void:
	var ms := Global.config.mountain_size_in_chunks
	var chunk_pixels := Global.config.scale(Global.config.map_chunk_pixel_size)
	
	chunk_size = Vector2(ms.x * chunk_pixels, chunk_pixels)
	var map_bounds := Rect2(
		-0.5*chunk_size.x, -chunk_size.y*ms.y, 
		chunk_size.x, chunk_size.y*ms.y
	)
	map_data.chunk_size = chunk_size
	map_data.bounds = map_bounds
	queue_redraw()

func _physics_process(_dt:float) -> void:
	generate_ahead_of_players()

func generate_ahead_of_players() -> void:
	# detect the player bounds
	var player_bots = get_tree().get_nodes_in_group("PlayerBots")
	var highest_pos = INF
	var lowest_pos = INF
	for bot in player_bots:
		highest_pos = min(bot.global_position.y, highest_pos)
		lowest_pos = max(bot.global_position.y, lowest_pos)
	
	# determine which set of chunks we'll need for that
	var highest_chunk = map_data.get_chunk_from_y(highest_pos) + Global.config.map_chunks_ahead
	var lowest_chunk = max(map_data.get_chunk_from_y(lowest_pos) - Global.config.map_chunks_behind, 0)
	var chunks_needed := []
	for i in range(lowest_chunk, highest_chunk+1):
		chunks_needed.append(i)
	
	# compare with what we already have to know what to add/destroy
	for i in range(chunks.size()-1,-1,-1):
		var chunk = chunks[i]
		var keep := chunks_needed.has(chunk.index)
		if keep: 
			chunks_needed.erase(chunk.index)
			continue
		
		chunks.remove_at(i)
		chunk.kill()
	
	for idx in chunks_needed:
		var new_chunk : MapChunk = chunk_scene.instantiate()
		new_chunk.index = idx
		new_chunk.set_position(Vector2(0, -idx*chunk_size.y))
		add_child(new_chunk)
		chunks.append(new_chunk)
		new_chunk.generate(chunk_size)

func _draw() -> void:
	draw_rect(map_data.bounds, Color(0.5, 0.5, 0.5), true)
