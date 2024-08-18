class_name ModuleMagnifyTracker extends Node2D

@onready var entity : CharacterBody2D = get_parent()
var glasses : Array[ToolMagnifyingGlass] = []
@export var body : ModuleBody
@export var mover : ModuleMoverMouse

var perma_visible = false

func activate() -> void:
	body.lives_changed.connect(on_lives_changed)

func on_lives_changed(new_lives:int) -> void:
	perma_visible = (new_lives >= Global.config.mouse_min_lives_perma_visible)

func add(mg:ToolMagnifyingGlass) -> void:
	glasses.append(mg)

func clear() -> void:
	glasses = []

func _process(_dt:float) -> void:
	if entity.dead: return
	check_if_magnified()
	clear()

func check_if_magnified() -> void:
	if OS.is_debug_build() and Global.config.debug_show_mice: return
	entity.request_visibility( should_be_visible() )

func should_be_visible() -> bool:
	if perma_visible: return true
	if mover.is_knocked_back(): return true
	return glasses.size() > 0
