class_name Map extends Node2D

var chunk_size := 128.0
var mountain_width_in_chunks := 10.0
var mountain_height_in_chunks := 30.0
var chunks_ahead := 4
var chunks_behind := 2
var chunks : Array[MapChunk] = []

@export var map_data : MapData
@export var chunk_scene : PackedScene

func _ready() -> void:
	var chunk_size := get_total_chunk_size()
	map_data.bounds = Rect2(
		-0.5*chunk_size.x, -chunk_size.y*mountain_height_in_chunks, 
		chunk_size.x, chunk_size.y*mountain_height_in_chunks
	)
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
	var highest_chunk = get_chunk_from_y(highest_pos) + chunks_ahead
	var lowest_chunk = max(get_chunk_from_y(lowest_pos) - chunks_behind, 0)
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
		new_chunk.set_position(Vector2(0, -idx*chunk_size))
		add_child(new_chunk)
		chunks.append(new_chunk)
		new_chunk.generate(get_total_chunk_size())

func get_total_chunk_size() -> Vector2:
	return Vector2(mountain_width_in_chunks * chunk_size, chunk_size)

func get_chunk_from_y(val:float) -> int:
	return floor(abs(val) / chunk_size)

func _draw() -> void:
	draw_rect(map_data.bounds, Color(0.5, 0.5, 0.5), true)
