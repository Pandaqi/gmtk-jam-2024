extends Resource
class_name ObstacleType

@export var frame := 0
@export var desc := ""
@export var color := Color(1,1,1)
@export var dir := 1
@export var radius_min_factor := 1.0
@export var radius_max_factor := 1.0
@export var destroy_on_visit := true ## the best thing for gameplay is really to destroy everything after single use
@export var destroyable := true

func on_body_entered(_o:Obstacle, _body:PlayerBot) -> void:
	pass

func on_body_exited(_o:Obstacle, _body:PlayerBot) -> void:
	pass

func update(_o:Obstacle, _dt: float) -> void:
	pass

func get_random_radius() -> float:
	var base_radius := Global.config.scale(Global.config.obstacle_base_radius)
	return Bounds.new(base_radius * radius_min_factor, base_radius * radius_max_factor).rand_float()
