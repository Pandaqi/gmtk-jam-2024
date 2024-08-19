extends ObstacleType
class_name ObstaclePen

func on_body_entered(_o:Obstacle, body:PlayerBot) -> void:
	if dir > 0:
		body.paper.pencils.add_new_type()
	else:
		var cur_line := body.paper_follower.get_current_line()
		if not cur_line:
			body.paper.pencils.remove_current_type()
			return
		
		body.paper.pencils.remove_type(cur_line.line.type)
