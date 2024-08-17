extends PencilType
class_name PencilInvert

func update(pf:ModulePaperFollower, line:Line, speed:float) -> Vector2:
	return -1 * super.update(pf, line, speed)
