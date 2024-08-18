class_name ModuleClueGiver extends Node2D

@export var body : ModuleBody
@export var mover : ModuleMoverMouse
@export var bite_giver : ModuleBiteGiver
@onready var timer : Timer = $Timer
@onready var audio_footsteps : AudioStreamPlayer2D = $AudioFootsteps
@onready var audio_bite : AudioStreamPlayer2D = $AudioBite
@export var footsteps_scene : PackedScene
@export var map_data : MapData

func activate() -> void:
	restart_timer()
	bite_giver.bit.connect(on_bit)
	timer.timeout.connect(on_timer_timeout)

# @NOTE: might want to decouple reaching a target and biting
func on_bit(_o:Obstacle) -> void:
	var volume_db := Global.config.mouse_bite_volume.interpolate(body.get_lives_ratio())
	audio_bite.pitch_scale = randf_range(0.95, 1.05)
	audio_bite.volume_db = volume_db
	audio_bite.play()

func restart_timer() -> void:
	timer.wait_time = Global.config.mouse_clue_timer.interpolate( body.get_lives_ratio() )
	timer.start()

func on_timer_timeout() -> void:
	give_clue()
	restart_timer()

func give_clue() -> void:
	if mover.is_knocked_back(): return
	
	var volume_db := Global.config.mouse_footstep_volume.interpolate(body.get_lives_ratio())
	audio_footsteps.pitch_scale = randf_range(0.9, 1.1)
	audio_footsteps.volume_db = volume_db
	audio_footsteps.play()
	
	var f = footsteps_scene.instantiate()
	f.set_position(global_position)
	f.set_rotation(mover.prev_vec.angle())
	
	var footstep_scale := Global.config.mouse_footstep_scale.interpolate(body.get_lives_ratio())
	var footstep_stay_dur := Global.config.mouse_footstep_dur.interpolate(body.get_lives_ratio())
	f.set_scale(footstep_scale * Vector2.ONE)
	
	map_data.map_node.layers.add_to_layer("floor", f)
	f.activate(footstep_stay_dur)
