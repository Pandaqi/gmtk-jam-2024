class_name Obstacle extends Node2D

var type : ObstacleType

@onready var sprite : Sprite2D = $Sprite2D
@onready var shadow : Sprite2D = $Shadow
@onready var col_shape : CollisionShape2D = $Area2D/CollisionShape2D
@onready var tooltip : ModuleTooltip = $Tooltip

func set_type(tp:ObstacleType) -> void:
	z_index = 100
	
	type = tp
	sprite.set_frame(tp.frame)
	shadow.set_frame(tp.frame)
	tooltip.set_desc(tp.desc)
	
	var rand_radius := tp.get_random_radius()
	var shp := CircleShape2D.new()
	shp.radius = rand_radius
	col_shape.shape = shp
	
	sprite.set_scale(2.0 * rand_radius / 256.0 * Vector2.ONE)
	shadow.set_scale(sprite.scale)
	
	shadow.set_position(to_local(global_position + Vector2.DOWN * Global.config.scale(Global.config.shadow_dist)))

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
