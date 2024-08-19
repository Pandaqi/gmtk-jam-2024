class_name Obstacle extends Node2D

var type : ObstacleType

@onready var sprite : Sprite2D = $Sprite2D
@onready var col_shape : CollisionShape2D = $Area2D/CollisionShape2D
@onready var tooltip : ModuleTooltip = $Tooltip

func set_type(tp:ObstacleType) -> void:
	type = tp
	sprite.set_frame(tp.frame)
	tooltip.set_desc(tp.desc)
	
	var rand_radius := tp.get_random_radius()
	var shp := CircleShape2D.new()
	shp.radius = rand_radius
	col_shape.shape = shp
	
	sprite.set_scale(2.0 * rand_radius / 256.0 * Vector2.ONE)

func _physics_process(dt:float) -> void:
	type.update(self, dt)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not PlayerBot: return
	type.on_body_entered(self, body)
	if type.destroy_on_visit:
		kill()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is not PlayerBot: return
	type.on_body_exited(self, body)

func kill() -> void:
	self.queue_free()
