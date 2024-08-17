extends ObstacleType
class_name ObstacleTime

func on_body_entered(o:Obstacle, body:PlayerBot) -> void:
	body.paper.turn.change_time_scale(1.0 + 0.25*dir)
