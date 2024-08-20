class_name Obstacle extends Node2D

var type : ObstacleType


@onready var col_shape : CollisionShape2D = $Area2D/CollisionShape2D
@onready var tooltip : ModuleTooltip = $Tooltip
@onready var area := $Area2D
@onready var audio_grab := $AudioGrab
@export var pather : ModulePather
@export var visuals : ModuleVisualsObstacle

signal size_changed(new_radius:float)

func _ready() -> void:
	visuals.activate()

func set_type(tp:ObstacleType) -> void:
	z_index = 100
	
	type = tp
	visuals.set_type(tp)
	tooltip.set_desc(tp.desc)
	
	if tp.needs_path:
		pather.activate()
	
	var rand_radius := tp.get_random_radius()
	var shp := CircleShape2D.new()
	shp.radius = rand_radius
	col_shape.shape = shp
	size_changed.emit(rand_radius)

func _physics_process(dt:float) -> void:
	type.update(self, dt)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not PlayerBot: return
	body.paper_follower.on_obstacle_entered(self)
	type.on_body_entered(self, body)
	if type.destroy_on_visit:
		call_deferred("kill")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is not PlayerBot: return
	type.on_body_exited(self, body)

func kill() -> void:
	area.monitoring = false
	
	var tw := get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(self, "scale", Vector2.ONE*1.2, 0.1)
	tw.tween_property(self, "scale", Vector2.ZERO, 0.2)
	
	audio_grab.pitch_scale = randf_range(0.95, 1.05)
	audio_grab.play()
	await audio_grab.finished
	
	self.queue_free()
