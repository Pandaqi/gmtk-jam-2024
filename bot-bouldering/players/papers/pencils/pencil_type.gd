extends Resource 
class_name PencilType

@export var frame := 0 ## frame in spritesheet to display
@export var color := Color(1,1,1) ## color of line drawn on paper (should match sprite icon)
@export var desc := "" ## short description of what it does
@export var ink_factor := 1.0 ## how quickly it exhausts ink
@export var follow_mask := Vector2.ZERO ## only follows lines if dot product with this mask is > 0; (0,0) just turns it off
@export var stop_at_obstacle := false ## destroy the line/insta-end it if we hit an obstacle
@export var vec_scale_factor := 1.0

func on_start(_l:LineFollower, _pf:ModulePaperFollower) -> void:
	pass

func on_end(line:LineFollower, _pf:ModulePaperFollower) -> void:
	line.time_traveled = 0.0
	line.target_travel_time = line.get_length_absolute()

func update(line:LineFollower, _pf:ModulePaperFollower, speed:float) -> Vector2:
	return line.advance_default(speed)
