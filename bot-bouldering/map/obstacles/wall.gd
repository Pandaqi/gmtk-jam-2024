class_name ObstacleWall extends StaticBody2D

@onready var col_shape : CollisionPolygon2D = $CollisionPolygon2D
@export var map_data : MapData

var shape : WallShape
var polygon : PackedVector2Array
var polygon_shadow : PackedVector2Array

func _ready() -> void:
	z_index = 1
	
	var chunk_size : float = 0.5 * (map_data.chunk_size.x + map_data.chunk_size.y)
	var size_bounds := Global.config.wall_size_bounds.clone().scale(chunk_size)
	var subdiv := Global.config.scale(Global.config.wall_size_subdiv)
	var rand_size := Vector2(size_bounds.rand_float(), size_bounds.rand_float())
	rand_size.x = floor(rand_size.x/subdiv) * subdiv
	rand_size.y = floor(rand_size.y/subdiv) * subdiv
	
	shape = map_data.all_wall_shapes.pick_random()
	
	change_size(rand_size)

func change_size(new_size:Vector2) -> void:
	var points : Array[Vector2] = shape.get_points()
	for i in range(points.size()):
		points[i] *= 0.5*new_size
	
	var bevel_size := Global.config.scale(Global.config.wall_bevel_size)
	var points_beveled := PathBeveler.new().bevel(points, bevel_size)
	col_shape.polygon = points_beveled
	polygon = col_shape.polygon
	
	polygon_shadow = []
	for point in polygon:
		# to_local->to_global shenanigans to ensure the shadow is always downward, no matter how we're rotated
		polygon_shadow.append(to_local( to_global(point) + Vector2.DOWN * Global.config.scale(Global.config.shadow_dist) ))
	
	queue_redraw()

func kill() -> void:
	self.queue_free()

func _draw() -> void:
	draw_polygon(polygon_shadow, [Color(0,0,0,0.45)])
	draw_polygon(polygon, [Global.config.wall_color])
