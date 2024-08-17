class_name PlayerBot extends CharacterBody2D

@export var player : Player
@export var map_data : MapData
@export var paper : PlayerPaper
@export var paper_follower : ModulePaperFollower
@onready var col_shape : CollisionShape2D = $CollisionShape2D

var base_size := 18.0
var size_scale := 1.0
var is_ghost := false

func _ready() -> void:
	paper_follower.activate()
	call_deferred("change_size")

func get_bounds() -> Rect2:
	var radius : float = col_shape.shape.radius
	var size := 2 * radius * Vector2.ONE
	var pos := global_position - 0.5 * size
	return Rect2(pos, size)

func _physics_process(_dt:float) -> void:
	check_if_out_of_bounds()

func check_if_out_of_bounds() -> void:
	var bds := map_data.bounds
	if global_position.x < bds.position.x or global_position.x > bds.position.x + bds.size.x:
		print("Out of bounds!")
		player.remove_all_lives()

func change_size(ds:float = 1.0) -> void:
	size_scale = clamp(size_scale * ds, 0.25, 4.0)
	var shp := CircleShape2D.new()
	shp.radius = size_scale * base_size
	col_shape.shape = shp

func set_ghost(val:bool) -> void:
	is_ghost = val
	
	modulate.a = 0.4 if is_ghost else 1.0
	set_collision_layer_value(1, not is_ghost)
	set_collision_mask_value(1, not is_ghost)
	
