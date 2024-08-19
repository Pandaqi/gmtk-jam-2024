extends PencilType
class_name PencilLoose

func on_start(_l:LineFollower, pf:ModulePaperFollower) -> void:
	pf.faller.set_falling(true)

func on_end(_l:LineFollower, pf:ModulePaperFollower) -> void:
	pf.faller.set_falling(false)
