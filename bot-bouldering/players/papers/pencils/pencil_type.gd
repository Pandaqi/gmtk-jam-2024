extends Resource 
class_name PencilType

@export var frame := 0 ## frame in spritesheet to display
@export var color := Color(1,1,1) ## color of line drawn on paper (should match sprite icon)
@export var desc := "" ## short description of what it does
@export var ink_factor := 1.0 ## how quickly it exhausts ink

func on_start(_l:Line, _pf:ModulePaperFollower) -> void:
	pass

func on_end(_l:Line, _pf:ModulePaperFollower) -> void:
	pass

func update(_pf:ModulePaperFollower, line:Line, speed:float) -> Vector2:
	var move_vec := Vector2.ZERO
	var cur_anchor := line.cur_point
	
	# while we have more to go, and the line hasn't ended yet
	while speed > 0 and not line.travel_is_done():
		var new_vec := line.points[line.cur_index+1] - cur_anchor
		var dist := new_vec.length()
		
		# if we can fully make the next leap, do it
		# also update index and anchor (first point BEHIND us) to match
		if dist < speed:
			line.cur_index += 1
			move_vec += new_vec
			cur_anchor = line.points[line.cur_index]
			speed -= dist
			continue
		
		# otherwise, do what we can and stop
		move_vec += speed * new_vec.normalized()
		speed = 0.0
	
	line.cur_point += move_vec
	return move_vec
