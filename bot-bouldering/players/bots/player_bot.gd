class_name PlayerBot extends CharacterBody2D

@export var player : Player
@export var paper : PlayerPaper
@export var map_data : MapData
@export var paper_follower : ModulePaperFollower
@onready var col_shape : CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D

var base_size := 18.0
var size_scale := 1.0
var is_ghost := false

func activate() -> void:
	set_position( map_data.get_player_starting_position() )
	base_size = Global.config.scale(Global.config.player_base_size)
	paper_follower.activate()
	call_deferred("change_size")

func get_bounds() -> Rect2:
	var radius : float = col_shape.shape.radius
	var size := 2 * radius * Vector2.ONE
	var pos := global_position - 0.5 * size
	return Rect2(pos, size)

func _physics_process(_dt:float) -> void:
	check_if_out_of_bounds()
	check_if_at_top()
	keep_paper_with_us()

func check_if_out_of_bounds() -> void:
	var bds := map_data.bounds
	if global_position.x < bds.position.x or global_position.x > bds.position.x + bds.size.x:
		print("Out of bounds!")
		player.remove_all_lives()

func check_if_at_top() -> void:
	if not map_data.is_above_mountain_top(global_position): return
	print("Reached the top! Yay!")
	GSignal.game_over.emit(true)

func keep_paper_with_us() -> void:
	if not Global.config.player_paper_on_top_of_bot: return
	paper.global_position = global_position
	paper.global_rotation = global_rotation

func change_size(ds:float = 1.0) -> void:
	size_scale = clamp(size_scale * ds, 0.25, 4.0)
	var new_radius := size_scale * base_size
	var shp := CircleShape2D.new()
	shp.radius = new_radius
	col_shape.shape = shp
	sprite.set_scale(2.0 * new_radius / Global.config.sprite_size * Vector2.ONE)

func set_ghost(val:bool) -> void:
	is_ghost = val
	
	modulate.a = 0.4 if is_ghost else 1.0
	set_collision_layer_value(1, not is_ghost)
	set_collision_mask_value(1, not is_ghost)
	
