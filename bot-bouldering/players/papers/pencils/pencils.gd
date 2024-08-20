class_name ModulePencils extends Node2D

@export var paper_data : PaperData
@export var pencils_unlocked : Array[PencilType]
@export var pencils_available : Array[PencilType]
@export var drawer : ModuleDrawer
@export var zoomer : ModuleZoomer
@export var turn : ModuleTurn
@onready var entity = get_parent()

@export var pencil_move : PencilType
@export var pencil_jump : PencilJump

var active_index := -1

signal pencils_exhausted()
signal active_changed(p:PencilType)
signal pencils_changed(available:Array[PencilType], unlocked:Array[PencilType])

func activate() -> void:
	drawer.line_finished.connect(on_line_finished)
	zoomer.size_changed.connect(on_size_changed)
	entity.done.connect(on_turn_done)
	entity.reset.connect(on_reset)
	
	pencils_unlocked = paper_data.pencils_available.duplicate(false)
	pencils_available = pencils_unlocked.duplicate(false)

func on_size_changed(_new_size:Rect2) -> void:
	if not Global.config.pencils_change_by_zoom: return
	var epsilon := 0.0001 # just to prevent it wrapping back around on max 100% ratio
	var idx : int = clamp( floor((zoomer.get_scale_ratio()-epsilon) * pencils_available.size()) , 0, pencils_available.size() - 1)
	set_index(idx)

func on_reset() -> void:
	pencils_available = pencils_unlocked.duplicate(false)
	on_change()
	set_index(0)

func grab_next() -> void:
	if count() <= 0: return
	set_index(active_index + 1)

func set_index(idx:int) -> void:
	if count() <= 0: return
	active_index = (idx + count()) % count()
	on_active_change()

func on_active_change() -> void:
	active_changed.emit(get_active_pencil())

func count() -> int:
	return pencils_available.size()

func count_unlocked() -> int:
	return pencils_unlocked.size()

func get_active_pencil() -> PencilType:
	return pencils_available[active_index]

func on_line_finished(l:Line) -> void:
	var erase_line_after_use := (not Global.config.turns_require_all_ink) and (not Global.config.turns_require_ink_relative_match)
	if erase_line_after_use: 
		pencils_available.erase(l.type)
		on_change()
	
	check_if_done()
	
	if Global.config.pencils_auto_advance_after_line:
		grab_next()

func check_if_done() -> void:
	if Global.config.turns_require_ink_relative_match: return
	
	var all_pencils_used := pencils_available.size() <= 0
	var no_ink := drawer.get_ink_ratio() <= 0.0
	if all_pencils_used or no_ink:
		exhaust_pencils()

func exhaust_pencils() -> void:
	pencils_available = []
	pencils_exhausted.emit()

func on_turn_done() -> void:
	exhaust_pencils()

func add_new_type(forced_type:PencilType = null) -> void:
	if count_unlocked() >= Global.config.pencil_num_bounds.end: 
		print("Already at max pencils!")
		return
	
	if not forced_type:
		var all_types := paper_data.all_pencils
		var types_not_used : Array[PencilType] = []
		for type in all_types:
			if pencils_unlocked.has(type): continue
			types_not_used.append(type)

		if types_not_used.size() <= 0:
			print("Already have all pencils!")
			return
		
		forced_type = types_not_used.pick_random()
	
	pencils_unlocked.append(forced_type)
	pencils_available.append(forced_type)
	on_change()

func remove_current_type() -> void:
	remove_type(get_active_pencil())

func remove_type(tp:PencilType) -> void:
	if count_unlocked() <= Global.config.pencil_num_bounds.start:
		print("Can't go below minimum pencils")
		return 
	pencils_unlocked.erase(tp)
	on_change()

func on_change() -> void:
	set_index(active_index)
	pencils_changed.emit(pencils_available, pencils_unlocked)
