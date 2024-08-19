extends ObstacleType
class_name ObstacleBomb

func on_body_entered(_o:Obstacle, body:PlayerBot) -> void:
	var nodes := body.get_tree().get_nodes_in_group("Obstacles") + body.get_tree().get_nodes_in_group("Walls")
	var bomb_dist := Global.config.scale(Global.config.bomb_dist)
	for node in nodes:
		if node is Obstacle and not node.type.destroyable: continue
		
		var dist : float = node.global_position.distance_to(body.global_position)
		if dist > bomb_dist: continue
		
		node.kill()
