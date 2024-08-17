extends Resource
class_name Config

@export_group("Debug")
@export var skip_pregame := true
@export var skip_postgame := true
@export var debug_bodies := true
@export var debug_disable_sound := false
@export var debug_labels := false

@export_group("Map")
@export var sprite_size := 256.0
@export var mountain_size_in_chunks := Vector2(20, 20)

@export_subgroup("Chunks")
@export var map_chunk_pixel_size := 1.0 # ~sprite_size
@export var map_chunks_ahead := 4
@export var map_chunks_behind := 2
var map_chunk_num_walls := Bounds.new(4,8)
var map_chunk_num_obstacles := Bounds.new(4,8)

@export_subgroup("Lava")
@export var map_lava_speed := 0.2 # ~sprite_size
@export var map_lava_start_y := 1.0 # ~sprite_size

@export_subgroup("Obstacles")
var wall_size_bounds := Bounds.new(0.5, 1.5)
@export var wall_size_subdiv := 0.075 # ~sprite_size
@export var obstacle_base_radius := 0.25 # ~sprite_size
@export var obstacle_rotation_subdiv := 0.25 * PI

@export_subgroup("Camera")
@export var camera_edge_margin := Vector2(64.0, 64.0)
@export var camera_min_size := Vector2(4.0, 2.0) # ~sprite_size

@export_group("Player")
@export var player_base_size := 0.225 # ~sprite_size
@export var player_follow_speed := 0.2
@export var player_move_speed := 4.0 # ~sprite_size
@export var player_gravity := 1.0 # ~sprite_size
@export var player_paper_on_top_of_bot := true

@export_subgroup("Turns")
@export var turn_duration := 20.0 # seconds
@export var turns_require_all_ink := false

@export_subgroup("Pencils")
@export var pencils_change_by_zoom := false
@export var pencils_auto_advance_after_line := true
var pencil_num_bounds := Bounds.new(1, 4)

@export_subgroup("Drawing & Ink")
@export var ink_default := 2.5 # ~line_lengths
var ink_bounds := Bounds.new(0.5, 5.0)
@export var drawing_max_dist_to_old_line := 0.075

@export_subgroup("Canvas")
@export var canvas_zoom_speed := 0.1
var canvas_base_scale_bounds := Bounds.new(0.5, 2.0)
var canvas_dimension_bounds := Bounds.new(0.6, 1.15)

func scale(val:float) -> float:
	return val * sprite_size

func scale_vector(vec:Vector2) -> Vector2:
	return vec * sprite_size

func scale_bounds(b:Bounds) -> Bounds:
	return b.clone().scale(sprite_size)
