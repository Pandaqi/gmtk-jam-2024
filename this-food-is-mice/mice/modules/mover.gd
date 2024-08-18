class_name ModuleMoverMouse extends Node2D

@onready var entity : Mouse = get_parent()
var elements_in_order : Array[Obstacle] = []
var prev_vec := Vector2.ZERO

var knockback_force := Vector2.ZERO

signal target_reached(o:Obstacle)
signal knockback_started()
signal knockback_ended()

func activate() -> void:
	determine_path()

func determine_path() -> void:
	var arr := get_tree().get_nodes_in_group("Obstacles")
	elements_in_order = []
	for elem in arr:
		elements_in_order.append(elem as Obstacle)
	elements_in_order.shuffle()

func count_targets() -> int:
	return elements_in_order.size()

func is_done() -> bool:
	return count_targets() <= 0

func _physics_process(dt:float) -> void:
	handle_knockback(dt)
	handle_target_following()

func handle_knockback(dt:float) -> void:
	if not is_knocked_back(): return
	
	knockback_force *= 1.0 - Global.config.tool_knockback_damping * dt
	entity.velocity = knockback_force
	entity.move_and_slide()
	
	if not is_knocked_back(): 
		on_knockback_over()

func handle_target_following() -> void:
	if entity.dead: return
	if is_done() or is_knocked_back(): return
	
	var first_target : Obstacle = get_target()
	if not first_target: return
	
	var vec := (first_target.global_position - global_position).normalized()
	entity.velocity = vec * get_speed()
	entity.move_and_slide()
	
	prev_vec = vec
	
func get_speed() -> float:
	return Global.config.scale(Global.config.mouse_speed)

func get_target() -> Obstacle:
	if is_done(): return null
	if not is_instance_valid(elements_in_order.front()):
		elements_in_order.pop_front()
		return null
	return elements_in_order.front()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != get_target(): return
	on_target_reached()

func on_target_reached() -> void:
	var t := get_target()
	t.on_mouse_arrived(entity)
	target_reached.emit(t)
	elements_in_order.pop_front()
	
	if is_done():
		entity.kill()

func is_knocked_back() -> bool:
	return knockback_force.length() > 0.5

func knockback(origin:Vector2, force:float) -> void:
	var vec_away := (global_position - origin).normalized()
	knockback_force = vec_away * force
	knockback_started.emit()

func on_knockback_over() -> void:
	entity.request_visibility(false)
	knockback_ended.emit()
