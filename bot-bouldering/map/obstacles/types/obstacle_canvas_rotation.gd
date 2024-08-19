extends ObstacleType
class_name ObstacleCanvasRotation

func on_body_entered(_o:Obstacle, body:PlayerBot) -> void:
	body.paper.change_canvas_rotation(0.2)
