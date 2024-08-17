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

var CHANGE_BY_ZOOM := true
var REQUIRE_ALL_INK := false
var AUTO_ADVANCE := false

signal pencils_exhausted()
signal active_changed(p:PencilType)
signal pencils_changed(available:Array[PencilType], unlocked:Array[PencilType])

func activate() -> void:
	drawer.line_finished.connect(on_line_finished)
	zoomer.size_changed.connect(on_size_changed)
	turn.turn_timed_out.connect(on_turn_timed_out)
	entity.reset.connect(on_reset)
	
	# @DEBUGGING
	add_new_type(pencil_move)
	add_new_type(pencil_jump)

func on_size_changed(_new_size:Rect2) -> void:
	if not CHANGE_BY_ZOOM: return
	var epsilon := 0.0001 # just to prevent it wrapping back around on max 100% ratio
	var idx : int = floor((zoomer.get_scale_ratio()+epsilon) * pencils_available.size())
	set_index(idx)

func on_reset() -> void:
	pencils_available = pencils_unlocked.duplicate(false)
	pencils_available.shuffle()
	on_change()
	
	active_index = -1
	grab_next()

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

func get_active_pencil() -> PencilType:
	return pencils_available[active_index]

func on_line_finished(l:Line) -> void:
	if not REQUIRE_ALL_INK: 
		pencils_available.erase(l.type)
		on_change()
	check_if_done()
	if AUTO_ADVANCE and (not REQUIRE_ALL_INK):
		grab_next()

func check_if_done() -> void:
	var all_pencils_used := pencils_available.size() <= 0
	var no_ink := drawer.get_ink_ratio() <= 0.0
	if all_pencils_used or no_ink:
		exhaust_pencils()

func exhaust_pencils() -> void:
	pencils_available = []
	pencils_exhausted.emit()

func on_turn_timed_out() -> void:
	exhaust_pencils()

func add_new_type(forced_type:PencilType = null) -> void:
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
	pencils_unlocked.erase(get_active_pencil())
	on_change()

func remove_type(tp:PencilType) -> void:
	pencils_unlocked.erase(tp)
	on_change()

func on_change() -> void:
	grab_next()
	pencils_changed.emit(pencils_available, pencils_unlocked)
