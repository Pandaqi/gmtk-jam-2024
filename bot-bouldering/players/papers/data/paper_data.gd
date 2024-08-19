extends Resource
class_name PaperData

@export var all_pencils : Array[PencilType] = []
@export var pencils_starting : Array[PencilType] = []
var pencils_locked : Array[PencilType] = []
var pencils_available : Array[PencilType] = []

var last_pencil_unlock = 0 ## level when last pencil unlocked

func reset() -> void:
	pencils_locked = all_pencils.duplicate(true)
	pencils_available = []
	last_pencil_unlock = 0

func unlock_pencil(tp:PencilType) -> void:
	pencils_locked.erase(tp)
	pencils_available.append(tp)

func has_unlockable_pencils() -> bool:
	return pencils_locked.size() > 0
