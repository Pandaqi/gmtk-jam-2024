extends Resource
class_name ProgressionData

var score := 0
var score_target := 0
var level := 0
var is_paused := false

var tools_unlocked : Array[ToolType] = []
@export var starting_tools : Array[ToolType] = []

signal score_changed(new_score:int)
signal score_target_changed(new_target:int)
signal level_changed(new_level:int)
signal type_unlocked(tt:ToolType)
signal paused_changed(p:bool)

func reset() -> void:
	tools_unlocked = []
	score_target = 0
	level = -1
	change_score(-score)

func set_target_score(ts:int) -> void:
	score_target = ts
	score_target_changed.emit(ts)

func change_score(ds:int) -> void:
	score = clamp(score + ds, 0, 9999)
	score_changed.emit(score)

func change_level(dl:int) -> void:
	level = clamp(level + dl, 0, 99)
	level_changed.emit(level)

func unlock_tool(tt:ToolType) -> void:
	tools_unlocked.append(tt)
	type_unlocked.emit(tt)

func pause() -> void:
	is_paused = true
	paused_changed.emit(true)

func unpause() -> void:
	is_paused = false
	paused_changed.emit(false)
