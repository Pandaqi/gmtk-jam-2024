extends ObstacleType
class_name ObstacleScore

func on_body_entered(o:Obstacle, body:PlayerBot) -> void:
	body.player.prog_data.change_score(dir)
