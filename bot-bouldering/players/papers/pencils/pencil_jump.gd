extends PencilType
class_name PencilJump

var target_travel_time := 0.0
var time_traveled := 0.0

# @TODO: this only works because pencils only appear ONCE in the entire game; if we can have multiple jumps, we'd need to duplicate this resource, or let PaperFollower track this time
func on_start(l:Line, pf:ModulePaperFollower) -> void:
	time_traveled = 0.0
	target_travel_time = (l.back() - l.front()).length()
	pf.entity.set_ghost(true)

func on_end(l:Line, pf:ModulePaperFollower) -> void:
	pf.entity.set_ghost(false)

# @TODO: maybe more of a jumping motion/tween: fast start, slower ending
func update(pf:ModulePaperFollower, line:Line, speed:float) -> Vector2:
	
	time_traveled += speed
	if time_traveled >= target_travel_time:
		line.traveling = false
		return Vector2.ZERO
	
	var vec := line.back() - line.front()
	return vec.normalized() * speed
