class_name Clouds extends Node2D

var clouds : Array[Node2D]

@export var map_data : MapData

@export var cloud_scene : PackedScene

func activate() -> void:
	prepare_all_clouds()

func prepare_all_clouds() -> void:
	var num := 12
	for i in range(num):
		var c : Cloud = cloud_scene.instantiate()
		add_child(c)
		clouds.append(c)
		c.screen_exited.connect(on_cloud_exited)
		on_cloud_exited(c)

func get_random_position_in_world() -> Vector2:
	var bds := map_data.bounds
	
	return bds.position + Vector2(randf(), randf()) * bds.size

func get_screen_bounds_in_world() -> Rect2:
	var vp_size := get_viewport_rect().size
	var conv :=  get_viewport().get_canvas_transform().affine_inverse()
	return Rect2(Vector2.ZERO * conv, vp_size * conv)

func on_cloud_exited(c:Cloud) -> void:
	var rand_speed := Global.config.scale_bounds(Global.config.cloud_speed_bounds).rand_float()
	var rand_dir := 1 if randf() <= 0.5 else -1
	
	var bds := map_data.bounds
	var extra_margin := Vector2(2.5,1)
	var rand_pos := bds.position*extra_margin + Vector2(0, (randf() - 0.25)*bds.size.y)
	if rand_dir < 0:
		rand_pos = bds.position + Vector2(bds.size.x, (randf() - 0.25)*bds.size.y) * extra_margin
	c.set_position(rand_pos)

	c.reappear(rand_speed, rand_dir)
