extends ObstacleType
class_name ObstacleCanvas

func on_body_entered(_o:Obstacle, body:PlayerBot) -> void:
	body.paper.zoomer.change_extra_scale(1.0 + 0.25*dir)
