class_name ModuleBody extends Node2D

@export var mover : ModuleMoverMouse
@export var col_shape : CollisionShape2D

var lives := 0

signal lives_changed(new_lives:int)
signal body_changed(new_size:Vector2)

func activate() -> void:
	mover.target_reached.connect(on_target_reached)
	change_lives(1)

func on_target_reached(_o:Obstacle) -> void:
	change_lives(+1)

func change_lives(dl:int) -> void:
	lives = clamp(lives + dl, 0, Global.config.mouse_max_lives)
	lives_changed.emit(lives)
	call_deferred("update_body")

func get_lives_ratio() -> float:
	return clamp(lives / Global.config.mouse_max_lives, 0.0, 1.0)

func update_body() -> void:
	var bounds := Global.config.scale_bounds(Global.config.mouse_body_bounds)
	var size := bounds.interpolate(get_lives_ratio())
	 # because of the fake perspective/2D y-sorting, the actual bodies are all squished flat on Y-axis
	var size_vector := Vector2(1, 0.2) * size
	
	var shp = RectangleShape2D.new()
	shp.size = size_vector
	col_shape.shape = shp
	col_shape.set_position(Vector2(0, -0.5*size_vector.y))
	
	body_changed.emit(size_vector)
	
