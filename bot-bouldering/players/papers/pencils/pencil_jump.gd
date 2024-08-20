extends PencilType
class_name PencilJump

func on_start(line:LineFollower, pf:ModulePaperFollower) -> void:
	line.time_traveled = 0.0
	line.target_travel_time = (line.points_absolute.back() - line.points_absolute.front()).length()
	pf.entity.set_ghost(true)

func on_end(_line:LineFollower, pf:ModulePaperFollower) -> void:
	pf.entity.set_ghost(false)

func update(line:LineFollower, pf:ModulePaperFollower, speed:float) -> Vector2:
	
	var vec : Vector2 = line.points_absolute.back() - line.points_absolute.front()
	var total_dist := vec.length()
	var old_fraction := line.time_traveled / line.target_travel_time
	var tween_speed := 3.5
	var old_dist := pow(old_fraction, 1.0/tween_speed) * total_dist
	
	line.time_traveled = min(line.time_traveled + speed, line.target_travel_time)
	
	var new_fraction := line.time_traveled / line.target_travel_time
	var new_dist := pow(new_fraction, 1.0/tween_speed) * total_dist
	var speed_tweened : float = abs(new_dist - old_dist)
	if new_fraction >= 1.0:
		line.traveling = false

	return vec.normalized() * speed_tweened
