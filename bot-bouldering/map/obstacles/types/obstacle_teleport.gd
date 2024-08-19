extends ObstacleType
class_name ObstacleTeleport

func on_body_entered(o:Obstacle, body:PlayerBot) -> void:
	var all_obstacles = body.get_tree().get_nodes_in_group("Obstacles")
	var teleporters = []
	for obs in all_obstacles:
		if obs.type != o.type: continue
		if obs == o: continue
		teleporters.append(obs)
	
	if teleporters.size() <= 0:
		print("No teleporters to go to!")
		return
	
	var rand_pos : Vector2 = teleporters.pick_random().global_position
	
	# destroy all teleporters; this is a simple way to prevent the endless loop of A<->B
	for teleport in teleporters:
		teleport.queue_free()
	
	body.set_deferred("global_position", rand_pos)
