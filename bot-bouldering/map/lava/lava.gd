class_name LavaThreat extends Node2D

@export var map_data : MapData

func _ready():
	set_position(Vector2(0, Global.config.scale(Global.config.map_lava_start_y)))

func _process(dt:float) -> void:
	move_up(dt)

func move_up(dt:float) -> void:
	var new_pos := get_position() + Vector2.UP * Global.config.scale(Global.config.map_lava_speed) * dt
	set_position(new_pos)
	
	var players := get_tree().get_nodes_in_group("PlayerBots")
	for p in players:
		if p.global_position.y < new_pos.y: continue
		print("Lava took you!")
		p.player.remove_all_lives()

func _draw() -> void:
	var size := map_data.bounds.size
	var thickness := 20.0
	var bounds := Rect2(-0.5*size.x, 0, size.x, thickness)
	draw_rect(bounds, Color(1,0,0), true)
