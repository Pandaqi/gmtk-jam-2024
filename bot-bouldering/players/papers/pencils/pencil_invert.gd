extends PencilType
class_name PencilInvert

func update(line:LineFollower, pf:ModulePaperFollower, speed:float) -> Vector2:
	return -1 * super.update(line, pf, speed)
