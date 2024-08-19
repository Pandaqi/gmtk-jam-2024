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
@export var mountain_size_increase_per_level := 1
@export var max_mountain_size := Vector2(10, 20)
@export var mountain_color_dark := Color(1,1,1)
@export var mountain_color_light := Color(1,1,1)
@export var mountain_noise_increments := 0.05 # ~sprite_size
@export var mountain_noise_scale := 1.0
@export var mountain_noise_displacement := 1.0 # ~sprite_size

@export_subgroup("Chunks")
var map_chunk_pixel_size_bounds := Bounds.new(0.5, 1.5) # ~sprite_size
@export var map_chunks_ahead := 4
@export var map_chunks_behind := 2
var map_chunk_num_walls := Bounds.new(4,8)
var map_chunk_num_obstacles := Bounds.new(4,8)

@export_subgroup("Generator")
var mapgen_num_star_bounds := Bounds.new(1,3)
var mapgen_num_finishes := Bounds.new(1,2)

@export_subgroup("Lava")
@export var map_lava_enabled := false
@export var map_lava_speed := 0.2 # ~sprite_size
@export var map_lava_start_y := 1.0 # ~sprite_size

@export_subgroup("Obstacles")
var wall_size_bounds := Bounds.new(0.2, 0.75) # ~chunk_size
@export var wall_size_subdiv := 0.075 # ~sprite_size
@export var obstacle_base_radius := 0.25 # ~sprite_size
@export var obstacle_rotation_subdiv := 0.25 * PI

@export_subgroup("Camera")
@export var camera_edge_margin := Vector2(64.0, 64.0)
@export var camera_min_size := Vector2(4.0, 2.0) # ~sprite_size

@export_group("Game Rules")
@export var must_end_perfectly := false
@export var max_distance_left_at_end := 1.0 # ~sprite_size
@export var win_if_at_top := false
@export var lose_life_if_not_finished_at_turn_end := true

@export_group("Player")
@export var player_base_size := 0.225 # ~sprite_size
@export var player_follow_speed := 2.5 # ~sprite_size
@export var player_gravity := 1.0 # ~sprite_size
@export var player_paper_on_top_of_bot := true
@export var player_moves_in_realtime := false
@export var player_starting_lives := 3

@export_subgroup("Turns")
@export var turn_duration := 20.0 # seconds
@export var turns_have_limited_duration := true
@export var turns_require_all_ink := false
@export var turns_require_ink_relative_match := false
@export var turns_ink_relative_margin := 0.175

@export_subgroup("Pencils")
@export var pencils_change_by_zoom := false
@export var pencils_auto_advance_after_line := true
var pencil_num_bounds := Bounds.new(1, 4)
@export var pencil_unlock_probability := 0.5
@export var pencil_unlock_max_interval := 3

@export_subgroup("Drawing & Ink")
@export var ink_default := 2.5 # ~line_lengths
var ink_bounds := Bounds.new(0.5, 5.0)
@export var drawing_max_dist_to_old_line := 0.075
@export var drawing_min_dist_to_prev_point := 0.0125

@export_subgroup("Canvas")
@export var canvas_zoom_speed := 0.1
var canvas_base_scale_bounds := Bounds.new(0.5, 2.0)
var canvas_dimension_bounds := Bounds.new(0.6, 1.15)
@export var canvas_line_width := 2
var canvas_rand_rotation_bounds := Bounds.new(-0.25*PI, 0.25*PI)

func scale(val:float) -> float:
	return val * sprite_size

func scale_vector(vec:Vector2) -> Vector2:
	return vec * sprite_size

func scale_bounds(b:Bounds) -> Bounds:
	return b.clone().scale(sprite_size)
