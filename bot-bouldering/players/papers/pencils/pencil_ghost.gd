extends PencilType
class_name PencilGhost

func on_start(l:Line, pf:ModulePaperFollower) -> void:
	pf.entity.set_ghost(true)

func on_end(l:Line, pf:ModulePaperFollower) -> void:
	pf.entity.set_ghost(false)
