class_name ModuleVisualsObstacle extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var shadow : Sprite2D = $Shadow
@onready var entity : Obstacle = get_parent() 

func activate() -> void:
	entity.size_changed.connect(on_size_changed)

func on_size_changed(new_radius:float) -> void:
	sprite.set_scale(2.0 * new_radius / Global.config.sprite_size * Vector2.ONE)
	shadow.set_scale(sprite.scale)
	shadow.set_position(to_local(global_position + Vector2.DOWN * Global.config.scale(Global.config.shadow_dist)))

func set_type(tp:ObstacleType) -> void:
	sprite.set_frame(tp.frame)
	shadow.set_frame(tp.frame)
	
func set_flip(v:bool) -> void:
	sprite.flip_h = v
	shadow.flip_h = v
