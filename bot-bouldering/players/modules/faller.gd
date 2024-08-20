class_name ModuleFaller extends Node2D

@onready var entity : PlayerBot = get_parent()
@export var map_data : MapData
@export var paper_follower : ModulePaperFollower
@onready var audio_player := $AudioStreamPlayer2D

var freefall := false
var gravity := 5.0

signal falling_changed(val:bool)

func activate() -> void:
	gravity = Global.config.scale(Global.config.player_gravity)

func set_falling(val:bool) -> void:
	if val == freefall: return
	
	freefall = val
	entity.velocity = Vector2.ZERO
	falling_changed.emit(val)
	
	if freefall:
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player.play()
		paper_follower.clear_trail()
		GSignal.feedback.emit(global_position, "Freefall!", true)

func is_falling() -> bool:
	return freefall

func _physics_process(dt:float) -> void:
	apply_gravity(dt)
	check_if_out_of_bounds()

func apply_gravity(dt) -> void:
	if not freefall: return
	entity.velocity = Vector2(0, entity.velocity.y + gravity * dt)
	entity.move_and_slide()

func check_if_out_of_bounds() -> void:
	var bds := map_data.bounds
	var epsilon := 2.5 # just to make sure it doesn't trigger at game start
	# reset player to starting pos, because otherwise it's just a mess
	if global_position.y > (bds.position.y + bds.size.y + epsilon):
		set_falling(false)
		entity.global_position = map_data.get_player_starting_position() + Vector2.UP * epsilon
		return
	
	var off_bounds_side := not Geometry2D.is_point_in_polygon(global_position, map_data.polygon_edge)
	if off_bounds_side:
		set_falling(true)

func _input(ev:InputEvent) -> void:
	if not entity.player.is_moving(): return
	if not (ev is InputEventMouseButton): return
	if ev.button_index != 1: return
	
	if Global.config.click_while_moving_makes_fall:
		set_falling(ev.pressed)
	
	if Global.config.click_while_moving_freezes_bot:
		paper_follower.set_freeze(ev.pressed)
