extends ObstacleType
class_name ObstacleLife

func on_body_entered(_o:Obstacle, body:PlayerBot) -> void:
	body.player.prog_data.change_lives(dir)
