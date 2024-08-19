extends ObstacleType
class_name ObstacleInk

func on_body_entered(_o:Obstacle, body:PlayerBot) -> void:
	body.paper.drawer.change_ink_bounds(dir)
