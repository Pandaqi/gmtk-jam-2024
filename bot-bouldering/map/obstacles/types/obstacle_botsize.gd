extends ObstacleType
class_name ObstacleBotsize

func on_body_entered(_o:Obstacle, body:PlayerBot) -> void:
	var delta_size := 1.0 + 0.3*dir
	body.call_deferred("change_size", delta_size)
