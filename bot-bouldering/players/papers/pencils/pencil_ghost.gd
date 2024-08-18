extends PencilType
class_name PencilGhost

func on_start(l:LineFollower, pf:ModulePaperFollower) -> void:
	pf.entity.set_ghost(true)

func on_end(l:LineFollower, pf:ModulePaperFollower) -> void:
	pf.entity.set_ghost(false)
