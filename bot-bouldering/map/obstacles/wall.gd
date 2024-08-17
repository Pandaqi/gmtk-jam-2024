class_name ObstacleWall extends StaticBody2D

@onready var col_shape : CollisionShape2D = $CollisionShape2D

var is_rectangle := false

func _ready() -> void:
	var size_bounds := Global.config.scale_bounds(Global.config.wall_size_bounds)
	var subdiv := Global.config.scale(Global.config.wall_size_subdiv)
	var rand_size := Vector2(size_bounds.rand_float(), size_bounds.rand_float())
	rand_size.x = floor(rand_size.x/subdiv) * subdiv
	rand_size.y = floor(rand_size.y/subdiv) * subdiv
	
	change_size(rand_size)

func change_size(new_size:Vector2) -> void:
	var shp
	
	is_rectangle = randf() <= 0.5
	if is_rectangle:
		shp = RectangleShape2D.new()
		shp.size = new_size
	else: 
		shp = CircleShape2D.new()
		var avg_size := 0.5 * (new_size.x + new_size.y)
		shp.radius = 0.5 * avg_size
	
	col_shape.shape = shp
	queue_redraw()

func _draw() -> void:
	if is_rectangle:
		var bounds_raw : Vector2 = col_shape.shape.size
		var bounds := Rect2(-0.5*bounds_raw.x, -0.5*bounds_raw.y, bounds_raw.x, bounds_raw.y)
		draw_rect(bounds, Color(1,1,1), true)
		return
	
	draw_circle(Vector2.ZERO, col_shape.shape.radius, Color(1,1,1), true)
