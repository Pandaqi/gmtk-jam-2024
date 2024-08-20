class_name ModulePather extends Node2D

@onready var entity = get_parent()

@export var map_data : MapData
@export var type_empty : PencilType
@export var visuals : ModuleVisualsObstacle

var path : Line
var path_follower : LineFollower
var paused := false
var active := false

func activate() -> void:
	create_path()
	active = true
	GSignal.player_state_changed.connect(on_state_changed)

func on_state_changed(new_state:Player.PlayerState) -> void:
	paused = (new_state != Player.PlayerState.MOVING)

func create_path() -> void:
	var bds := map_data.bounds
	var start_point := global_position
	var end_point := Vector2(bds.position.x, start_point.y) + Vector2(randf_range(0.0, 0.5), 0)*bds.size.x
	if start_point.x < bds.get_center().x:
		end_point = Vector2(bds.position.x, start_point.y) + Vector2(randf_range(0.5, 1.0), 0)*bds.size.x
	
	path = Line.new(type_empty)
	path.add_point(start_point)
	path.add_point(end_point)
	
	create_new_follower(1)

func _process(dt:float) -> void:
	follow_path(dt)

func create_new_follower(dir:int) -> void:
	path_follower = LineFollower.new(path, map_data, dir, false)
	path_follower.start_travel()

func follow_path(dt:float) -> void:
	if not active: return
	if paused: return

	var follow_speed := Global.config.scale(Global.config.player_follow_speed) * dt
	var vec := path_follower.advance(null, follow_speed)
	entity.global_position += vec
	visuals.set_flip(vec.x < 0)
	
	if path_follower.travel_is_done():
		create_new_follower(-path_follower.travel_dir)
	
	queue_redraw()

func _draw() -> void:
	if not active: return
	draw_polyline([to_local(path_follower.points_absolute.front()), to_local(path_follower.points_absolute.back())], Color(1,1,1,0.66), 4, true)
	
