class_name Tutorial extends CanvasLayer

@onready var cont := $Container
@onready var sprite := $Container/Sprite2D

var active := false
var cur_tut := -1
var max_tuts := 4
var tut_sides := ["left", "right", "right", "left"]
var game_over := false

func activate() -> void:
	set_visible(false)

func on_game_over(we_won:bool) -> void:
	if OS.is_debug_build() and Global.config.skip_postgame: 
		call_deferred("restart")
		return
	
	appear()
	game_over = true
	
	var frame := 5 if we_won else 4
	sprite.set_frame(frame)
	tween_pop_up("left")

func appear(load_next := false) -> void:
	if load_next and (OS.is_debug_build() and Global.config.skip_pregame): return
	
	set_visible(true)
	get_tree().paused = true
	active = true
	if load_next: load_next_tut()

func disappear() -> void:
	set_visible(false)
	active = false
	get_tree().paused = false

func get_tut_scale() -> Vector2:
	var raw_size := Vector2(575, 900)
	var vp_size := get_viewport().get_visible_rect().size
	var match_scale : float = min(vp_size.x / raw_size.x, vp_size.y / raw_size.y)
	if match_scale < 1.0:
		return Vector2.ONE * match_scale
	return Vector2.ONE

func get_tut_pos(forced_side:="") -> Vector2:
	var vp_size := get_viewport().get_visible_rect().size
	var side : String = tut_sides[cur_tut] if not forced_side else forced_side
	if side == "left":
		return Vector2(0.25*vp_size.x, 0.5*vp_size.y)
	return Vector2(0.75*vp_size.x, 0.5*vp_size.y)

func load_next_tut() -> void:
	cur_tut += 1
	if cur_tut >= max_tuts:
		disappear()
		return

	sprite.set_frame(cur_tut)

	tween_pop_up()

func tween_pop_up(forced_side:="") -> void:
	cont.set_position(get_tut_pos(forced_side))
	sprite.set_scale(get_tut_scale())
	
	var tw := get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	cont.set_scale(Vector2.ZERO)
	tw.tween_property(cont, "scale", Vector2.ONE*1.2, 0.2)
	tw.tween_property(cont, "scale", Vector2.ONE, 0.1)

func _input(ev:InputEvent) -> void:
	if not active: return
	if not (ev is InputEventMouseButton): return
	if ev.button_index != 1: return
	if ev.pressed: return
	
	if not game_over:
		# DEFERRED to prevent double-registering click within game logic
		call_deferred("load_next_tut") 
		return
	
	if game_over:
		call_deferred("restart")

func restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
