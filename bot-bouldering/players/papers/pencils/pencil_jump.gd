extends PencilType
class_name PencilJump

func on_start(line:LineFollower, pf:ModulePaperFollower) -> void:
	line.time_traveled = 0.0
	line.target_travel_time = (line.points_absolute.back() - line.points_absolute.front()).length()
	pf.entity.set_ghost(true)

func on_end(_line:LineFollower, pf:ModulePaperFollower) -> void:
	pf.entity.set_ghost(false)

# @TODO: maybe more of a jumping motion/tween: fast start, slower ending
func update(line:LineFollower, pf:ModulePaperFollower, speed:float) -> Vector2:
	
	line.time_traveled += speed
	if line.time_traveled >= line.target_travel_time:
		line.traveling = false
		return Vector2.ZERO
	
	var vec : Vector2 = line.points_absolute.back() - line.points_absolute.front()
	return vec.normalized() * speed
