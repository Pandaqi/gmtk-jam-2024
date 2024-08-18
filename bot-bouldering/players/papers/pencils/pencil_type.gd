extends Resource 
class_name PencilType

@export var frame := 0 ## frame in spritesheet to display
@export var color := Color(1,1,1) ## color of line drawn on paper (should match sprite icon)
@export var desc := "" ## short description of what it does
@export var ink_factor := 1.0 ## how quickly it exhausts ink

func on_start(_l:LineFollower, _pf:ModulePaperFollower) -> void:
	pass

func on_end(_l:LineFollower, _pf:ModulePaperFollower) -> void:
	pass

func update(line:LineFollower, _pf:ModulePaperFollower, speed:float) -> Vector2:
	return line.advance_default(speed)
