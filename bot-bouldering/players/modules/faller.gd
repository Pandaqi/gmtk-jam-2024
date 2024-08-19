class_name ModuleFaller extends Node2D

@onready var entity : PlayerBot = get_parent()
@export var map_data : MapData
@export var paper_follower : ModulePaperFollower

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
	if global_position.y > (bds.position.y + bds.size.y + epsilon):
		set_falling(false)
		return
	
	var off_bounds_side := not Geometry2D.is_point_in_polygon(global_position, map_data.polygon_edge)
	if off_bounds_side:
		set_falling(true)
	else:
		set_falling(false)

# @TODO: testing if it's fun to give the player a single control while the robot walks
# @TODO: I should have a clear marker somewhere though whether the robot is actually allowed to move => the player should have a clear variable "is_drawing" and "is_executing"
func _input(ev:InputEvent) -> void:
	if not entity.player.is_moving(): return
	if not (ev is InputEventMouseButton): return
	if ev.button_index != 1: return
	
	if Global.config.click_while_moving_makes_fall:
		set_falling(ev.pressed)
	
	if Global.config.click_while_moving_freezes_bot:
		paper_follower.set_freeze(ev.pressed)
