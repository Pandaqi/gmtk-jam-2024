extends PencilType
class_name PencilLoose

func on_start(l:Line, pf:ModulePaperFollower) -> void:
	pf.freefall = true

func on_end(l:Line, pf:ModulePaperFollower) -> void:
	pf.freefall = false
