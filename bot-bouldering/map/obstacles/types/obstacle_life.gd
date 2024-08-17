extends ObstacleType
class_name ObstacleLife

func on_body_entered(o:Obstacle, body:PlayerBot) -> void:
	body.player.change_lives(dir)
