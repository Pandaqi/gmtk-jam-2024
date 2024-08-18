class_name ModuleMagnifyTracker extends Node2D

@onready var entity : CharacterBody2D = get_parent()
var glasses : Array[ToolMagnifyingGlass] = []
@export var body : ModuleBody
@export var mover : ModuleMoverMouse
@onready var prog_bar : TextureProgressBar = $ProgCont/TextureProgressBar

var perma_visible = false
var time_magnified := 0.0

func activate() -> void:
	body.lives_changed.connect(on_lives_changed)

func on_lives_changed(new_lives:int) -> void:
	perma_visible = (new_lives >= Global.config.mouse_min_lives_perma_visible)

func add(mg:ToolMagnifyingGlass) -> void:
	glasses.append(mg)

func clear() -> void:
	glasses = []

func get_time_mag_ratio() -> float:
	return clamp(time_magnified / Global.config.tool_magnify_time_before_kill, 0.0, 1.0)

func change_time_magnified(dtm:float) -> void:
	time_magnified += dtm
	
	var ratio := get_time_mag_ratio()
	prog_bar.set_value( ratio * 100 )
	if ratio >= 1.0:
		entity.kill()

func reset_time_magnified() -> void:
	change_time_magnified(-time_magnified)

func _process(dt:float) -> void:
	if entity.dead: return
	check_if_in_view(dt)
	clear()

func check_if_in_view(dt:float) -> void:
	if is_magnified():
		change_time_magnified(dt)
	else:
		reset_time_magnified()
	entity.request_visibility( should_be_visible() )

func is_magnified() -> bool:
	return glasses.size() > 0

func should_be_visible() -> bool:
	if OS.is_debug_build() and Global.config.debug_show_mice: return true
	if perma_visible: return true
	if mover.is_knocked_back(): return true
	return is_magnified()
