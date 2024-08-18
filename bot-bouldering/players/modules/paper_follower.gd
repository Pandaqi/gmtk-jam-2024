class_name ModulePaperFollower extends Node2D

@onready var entity : PlayerBot = get_parent()
@export var map_data : MapData

var following := false
var lines : Array[LineFollower]
var follow_speed := 0.2
var trail : Array[Vector2] = [] # this is mostly for debugging
var freefall := false
var gravity := 5.0
var move_in_realtime := false # whether to wait for all pencils to finish, or move immediately as soon as player has drawn something

signal done()
signal started()

signal line_started(l:LineFollower)
signal line_ended(l:LineFollower)

func activate() -> void:
	follow_speed = Global.config.scale(Global.config.player_follow_speed)
	gravity = Global.config.scale(Global.config.player_gravity)
	move_in_realtime = Global.config.player_moves_in_realtime
	
	entity.paper.done.connect(on_all_drawings_done)
	entity.paper.drawer.line_finished.connect(on_line_finished)

func on_all_drawings_done() -> void:
	if move_in_realtime: return
	
	for line in entity.paper.drawer.lines:
		add_line(line)
	
	start()

func on_line_finished(l:Line) -> void:
	if not move_in_realtime: return
	add_line(l)
	start()

func add_line(line:Line) -> void:
	var new_line := LineFollower.new(line, map_data)
	lines.append(new_line)

func start() -> void:
	var nothing_drawn := lines.size() <= 0
	if nothing_drawn:
		entity.player.change_lives(-1)
		done.emit()
		return
	
	print("Bot should start")
	following = true
	
	started.emit()

func stop() -> void:
	print("Bot should stop")
	entity.velocity = Vector2.ZERO
	freefall = false
	following = false
	done.emit()

func _process(dt:float) -> void:
	follow_lines(dt)
	apply_gravity(dt)
	entity.move_and_slide()

func apply_gravity(dt) -> void:
	if not freefall: return
	entity.velocity.y += gravity * dt

func follow_lines(dt:float) -> void:
	if not following: return
	if lines.size() <= 0:
		stop()
		return
	
	var first_line : LineFollower = get_current_line()
	if not first_line.travel_has_started():
		on_line_following_started(first_line)
	
	var vec := first_line.advance(self, follow_speed * dt)
	
	if not freefall:
		entity.velocity = vec / dt
	
	# @NOTE: the -1/2PI is because our bot starts facing forward/up, instead of right as default
	var target_rot := entity.velocity.angle() + 0.5 * PI
	var smoothed_rot : float = lerp(entity.global_rotation, target_rot, 3*dt)
	entity.global_rotation = smoothed_rot

	update_trail()
	
	if first_line.travel_is_done():
		lines.pop_front()
		on_line_following_ended(first_line)

func on_line_following_started(l:LineFollower) -> void:
	l.on_start(self)
	line_started.emit(l)

func on_line_following_ended(l:LineFollower) -> void:
	l.on_end(self)
	line_ended.emit(l)

func get_current_line() -> LineFollower:
	if lines.size() <= 0: return null
	return lines.front()

func get_distance_left() -> float:
	var sum := 0.0
	for line in lines:
		sum += line.get_length_absolute()
	return sum

func update_trail() -> void:
	trail.append(entity.global_position)
	queue_redraw()

func _draw() -> void:
	if trail.size() < 2: return
	var trail_local : Array[Vector2] = []
	for point in trail:
		trail_local.append(to_local(point))
	draw_polyline(trail_local, Color(1,1,1), 4, true)
