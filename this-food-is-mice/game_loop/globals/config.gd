extends Resource
class_name Config

@export_group("Debug")
@export var skip_pregame := true
@export var debug_disable_sound := false
@export var debug_show_mice := true
@export var debug_labels := true

@export_group("General")
@export var sprite_size := 256.0
@export var gameloop_num_pies := 3

@export_group("Map")
@export var map_size := Vector2(10, 7)
@export var camera_edge_margin := Vector2(32.0, 32.0)

@export_group("Players")
@export var player_move_speed := 2.0 # ~sprite_size
@export var player_starting_scale := 0.33
@export var player_max_scale := 1.75
@export var player_scale_increase_per_level := 0.1
@export var player_speed_increase_per_level := 0.1

@export_group("Mice")
var mouse_speed_bounds := Bounds.new(1.0, 0.35) # lives 0%->100%
var mouse_bite_size_bounds := Bounds.new(0.65, 1.5) # ~sprite_scale, lives 0%->100%
@export var mouse_max_lives := 9
@export var mouse_min_lives_perma_visible := 7
var mouse_body_bounds := Bounds.new(0.25, 1.0) # ~sprite_size
var mouse_clue_timer := Bounds.new(4.5, 0.75) # seconds; lives 0%->100%
var mouse_footstep_scale := Bounds.new(0.2, 0.8) # ~sprite_size, lives 0%->100%
var mouse_footstep_volume := Bounds.new(-9, -2) # lives 0%->100%
var mouse_footstep_dur := Bounds.new(2.5, 6.0) # lives 0%->100%
var mouse_bite_volume := Bounds.new(-6, 0)

@export_subgroup("Spawning")
var mouse_spawn_bounds := Bounds.new(1,3)
@export var mouse_spawn_tick := 3.0
@export var mouse_spawn_prob := 0.66

@export_group("Obstacles")
@export var obstacle_num_bites_remove := 4 ## after this many bites, the thing removes itself
@export var obstacle_min_spawn_dist := 1.5 # ~sprite_size
@export var obstacle_starting_num := 6

@export_group("Tools")
@export var tool_knockback_force := 6.0 # ~sprite_size
@export var tool_knockback_damping := 1.0
@export var tool_magnify_time_before_kill := 4.0

@export_group("Progression")
@export var prog_score_interval_per_level := 2
@export var prog_score_interval_increase_per_level := 1.05

func scale(val:float) -> float:
	return val * sprite_size

func scale_vector(vec:Vector2) -> Vector2:
	return vec * sprite_size

func scale_bounds(b:Bounds) -> Bounds:
	return b.clone().scale(sprite_size)
