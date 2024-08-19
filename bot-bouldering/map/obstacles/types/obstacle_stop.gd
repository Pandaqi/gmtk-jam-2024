extends ObstacleType
class_name ObstacleStop

func on_body_entered(_o:Obstacle, body:PlayerBot) -> void:
	body.paper_follower.stop(true)
