extends PencilType
class_name PencilLoose

func on_start(_l:LineFollower, pf:ModulePaperFollower) -> void:
	pf.freefall = true

func on_end(_l:LineFollower, pf:ModulePaperFollower) -> void:
	pf.freefall = false
